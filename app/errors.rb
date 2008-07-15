module ActiveRecord
  class Errors
    begin
      @@default_error_messages.update( {
        :inclusion => "中文1",
        :exclusion => "中文2",
        :invalid => "中文3",
        :confirmation => "請再確認一次密碼",
        :accepted => "中文4",
        :empty => "不能是空的",
        :blank => "不能是空的",
        :too_long => "太長",
        :too_short => "太短",
        :wrong_length => "中文8",
        :taken => "帳號有人使用了",
        :not_a_number => "不是數字",
      })
    end
  end
end

module ActionView #nodoc
  module Helpers
    module ActiveRecordHelper

      def error_messages_for(object_name, options = {})
        options = options.symbolize_keys
        object = instance_variable_get("@#{object_name}")

        unless object.nil?
          unless object.errors.empty?
            content_tag("div",
            content_tag(
            options[:header_tag] || "h2",

            "一共有 #{pluralize(object.errors.count, "error")} 問題 "
            ) +
            content_tag("p", "請更正:") +
            content_tag("ul", object.errors.full_messages.collect { |msg| content_tag("li", msg) }),
            "id" => options[:id] || "errorExplanation", "class" => options[:class] || "errorExplanation"
            )
          end
        end
      end

    end
  end
end
