require 'set'

module ActionView
  module Helpers

    # Provides a set of helper functions for calling jQuery JavaScript functions.
    # 
    # To be able to use these helpers, you have to add the blow tag in your pages:
    #   <%= include_jq4r %>
    # This tag will help you to include the necessary JavaScript files.
    module JQueryHelper
      unless const_defined? :AJAX_CALLBACKS
        AJAX_CALLBACKS = Set.new([:beforeSend, :complete, :error, :success])
        AJAX_OPTIONS = Set.new([:async, :cache, :contentType, :dataType, :global, :ifModified,
                               :processData, :timeout, :type])
      end
      
      # To include the necessary JavaScript files.
      # 
      # @author ericsk
      def include_jq4r
        javascript_include_tag 'jq4r'
      end

      # This method is jQuery-based implementation of the original <tt>link_to_remote</tt> method.
      # 
      # See ActionView::Helpers::PrototypeHelper::link_to_remote to know how the method works.
      # 
      # The callback functions that may be specified are (in order):
      # 
      # <tt>beforeSend</tt>   Called before the AJAX submit.
      #
      # <tt>error</tt>        Called when the AJAX action is completed and the HTTP status code
      #                       is *NOT* in the 2XX range.
      #                       
      # <tt>success</tt>      Called when the AJAX action is completed and the HTTP status code
      #                       is in the 2XX range.
      #
      # <tt>complete</tt>     Called when the AJAX action is completed after the error/success 
      #                       callback functions.
      #
      # You may also customize the AJAX action settings by specifying the options. See
      # http://docs.jquery.com/Ajax/jQuery.ajax#options to lookup the options.
      #
      # @author ericsk
      def jquery_link_to_remote(name, options = {}, html_options = {})
        link_to_function(name, jq_remote_func(options), html_options)
      end
      alias_method :jq_link_to_remote, :jquery_link_to_remote

      # Load data from a remote action and update the content of the specified element.
      # 
      # The element which is needed to be updated is specified by <tt>options[:update]</tt> or
      # <tt>options[:load_to]</tt>.
      # 
      # @author ericsk
      def jquery_load_from_remote(name, options = {}, html_options = {})
        url_options = options[:url]
        url_options = url_options.merge(:escape => false) if url_options.is_a?(Hash)
        options[:load_to] ||= options[:update]
        link_to_function(name, jq_remote_func("$('##{options[:load_to]}').load('#{url_options}')"), html_options)
      end
      alias_method :jq_load_from_remote, :jquery_load_from_remote

      # As the original <tt>form_remote_tag</tt> helper, it creates a <tt>form</tt> tags and
      # overrides the <tt>onsubmit</tt> event by the AJAX functions.
      # 
      # See jq_link_to_remote to see which callbacks and customizations could be specified.
      # 
      # @author ericsk
      def jquery_form_remote_tag(options = {}, &block)
        options[:form] = true
        options[:type] ||= 'POST'
        options[:html] ||= {}
        options[:html][:onsubmit] = 
          (options[:html][:onsubmit] ? options[:html][:onsubmit] + "; " : "") +
          "#{jq_remote_func(options)}; return false;"
        form_tag(options[:html].delete(:action) || url_for(options[:url]), options[:html], &block)
      end
      alias_method :jq_form_remote_tag, :jquery_form_remote_tag

      # jQuery-based implementation of <tt>remote_form_for</tt>
      # 
      # @author ericsk
      def jquery_remote_form_for(object_name, *args, &proc)
        options = args.last.is_a?(Hash) ? args.pop : {}
        concat(jq_form_remote_tag(options), proc.binding)
        fields_for(object_name, *(args << options), &proc)
        concat('</form>', proc.binding)
      end
      alias_method :jquery_form_remote_for, :jquery_remote_form_for
      alias_method :jq_form_remote_for, :jquery_remote_form_for
      alias_method :jq_remote_form_for, :jquery_remote_form_for

      # Creates a button that submit specified <tt>options[:data]</tt> (<tt>options[:with]</tt>) or 
      # the whole form data to a remote action.
      # 
      # @author ericsk
      def jquery_submit_to_remote(name, value, options = {})
        options[:data] ||= options[:with] or "$('form').formSerialize()"
        
        options[:html] ||= {}
        options[:html][:type] = 'button'
        options[:html][:onclick] = "#{jq_remote_func(options)}; return false;"
        options[:html][:name] = name
        options[:html][:value] = value

        tag("input", options[:html], false)
      end
      alias_method :jq_submit_to_remote, :jquery_submit_to_remote
      
      # Periodically call a remote action.
      # 
      # @author ericsk
      def jquery_periodically_call_remote(options = {})
        freq = options[:frequency] || 10 # every 10 seconds by default
        code = "setInterval(function(){#{jq_remote_func(options)}}, #{freq} * 1000)"
        javascript_tag(code)
      end
      alias_method :jq_periodically_call_remote, :jquery_periodically_call_remote
      
      # Create a observer for a form field. If the <tt>options[:frequency]</tt> is specified,
      # the callback function will be fired on the Timer event. Otherwise, the callbacks will 
      # be fired on the *CHANGE* event(except for 'radio' and 'checkbox' fields, they are observed
      # on the *CLICK* event).
      # 
      # @author ericsk
      def jquery_observe_field(field_id, options = {})
        func = options[:function] || jq_remote_func(options)
        if options[:frequency] && options[:frequency] > 0 # time interval
          code = "evt='#{field_id}_evt';"
          code << "$('##{field_id}').bind(evt,function(e){#{func}});setInterval(function(){$('##{field_id}').trigger(evt);},#{options[:frequency]}*1000);"
        else # event observer
          code = "t=$('##{field_id}').type.toLowerCase();"
          code << "if(t=='checkbox'||t=='radio'){evt='click';}"
          code << "else{evt='change';}"
          code << "$('##{field_id}').bind(evt,function(e){#{func}});"
        end
        javascript_tag(code)
      end
      alias_method :jq_observe_field, :jquery_observe_field
      
      # Create a observer for a form. If the <tt>options[:frequency]</tt> is specified,
      # the callback function will be fired on the Timer event. Otherwise, the observers will
      # be registered on each field in the form.
      # 
      # @author ericsk
      def jquery_observe_form(form_id, options = {})
        func = options[:function] || jq_remote_func(options)
        if options[:frequency] && options[:frequency] > 0 # by time interval
          code = "'#{form_id}_evt';$('##{form_id}').bind(evt,function(e){#{func}}); setInterval(function(){$('##{form_id}').trigger(evt);},#{options[:frequency]}*1000);"
        else # by event
          code = "$('##{form_id} :input').each(function(i, elem){";
          code << "if(elem.type!='submit'&&elem.type!='button'&&elem.type!='reset'){"
          code << "evt=(elem.type=='radio'||elem.type=='checkbox')?'click':'change';"
          code << "$(elem).bind(evt,function(e){#{func}});"
          code << "}});"
        end
        javascript_tag(code)
      end
      alias_method :jq_observe_form, :jquery_observe_form
      
      # Create the jQuery animation.
      # 
      # @author ericsk
      def jquery_visual_effect(name, element_id, options = {})
        speed = options[:speed] or "slow"
        callback = options[:function] or jq_remote_func(options)
        
        code = "$('##{element_id}').#{name.to_s.camelize :lower}("
        case name.to_s.downcase
        when "animate"
          code << "{#{options[:params]}, {#{options[:animate_options]}}}"
        when "fade_to"
          code << "'#{speed}', #{options[:opacity]}, function(){#{callback}});"
        else
          code << "'#{speed}', function(){#{callback}});"
        end
      end
      alias_method :jq_visual_effect, :jquery_visual_effect
      
      # Wrap the <tt>options</tt> hash to the JSON-like options, especially for the
      # remote actions.
      # 
      # @author ericsk
      def jquery_remote_func(options)
        func = "$.ajax({"

        url_options = options[:url]
        url_options = url_options.merge(:escape => false) if url_options.is_a?(Hash)   
        func << "url: '#{url_for(url_options)}'"
        
        if options[:form]
          options[:data] = "$('form').formSerialize()"
        else
          options[:data] ||= options[:with]
        end
        func << ",data: #{options[:data]}" if options[:data]
        
        options[:complete] ||= ""
        options[:complete] << "$('##{options[:update]}').html(request.responseText);" if options[:update]
        
        options[:error] ||= options[:failure]
        
        options.each do |name, value|
          if AJAX_CALLBACKS.include?(name)
              func << ",#{name}: function(request) {#{value}}"
          elsif AJAX_OPTIONS.include?(name)
            func << ",#{name}: '#{value}'"
          end
        end

        func << "})"

        func = "#{options[:before]}; #{func}" if options[:before]
        func = "#{func}; #{options[:after]}" if options[:after]
        func = "if (#{options[:condition]}) { #{func}; }" if options[:condition]
        func = "if (confirm('#{escape_javascript(options[:confirm])}')) { #{func}; }" if options[:confirm]
        func
      end
      alias_method :jq_remote_func, :jquery_remote_func

    end
  end
end
