require 'jq4r'
require 'jq4r_rjs_helper'
ActionView::Base.send(:include, ActionView::Helpers::JQueryHelper)
ActionView::Helpers::PrototypeHelper::JavaScriptGenerator::GeneratorMethods.send(:include, Jq4r::Jq4rRjsHelper)