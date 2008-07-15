# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

module Jq4r
  module Jq4rRjsHelper
    
    # <tt>before</tt>
    # <tt>after</tt>
    # <tt>wrap</tt>
    def jquery_insert_html(position, id, *options_for_render)
      call "$('#{id}').#{position}", render(*options_for_render)
    end
    
    def jquery_replace_html(id, *options_for_render)
      call "$('#{id}').html", render(*options_for_render)
    end
    
    def jquery_replace(id, *options_for_render)
      call "$('#{id}').replaceWith", render(*options_for_render)
    end
    
    def jquery_remove(*ids)
      jquery_loop_on_multiple_args 'remove', ids
    end
    
    def jquery_hide(*ids)
      jquery_loop_on_multiple_args 'hide', ids
    end
    
    def jquery_show(*ids)
      jquery_loop_on_multiple_args 'show', ids
    end
    
    def jquery_toggle(*ids)
      jquery_loop_on_multiple_args 'toggle', ids
    end
    
    def jquery_visual_effect(name, id = nil, options = {})
      record @context.send(:jquery_visual_effect, name, id, options)
    end
        
    private
      def jquery_loop_on_multiple_args(method, ids)        
        record(ids.size > 1 ? 
          "$.each(#{javascript_object_for(ids)}, function(i,v){$(v).#{method}();})" : 
          "$(#{ids.first.to_json}).#{method}()")
      end      
  end
end
