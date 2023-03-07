# frozen_string_literal: true

# gem "rbs", "~> 2.0"
# require "rbs"
# require "rbs/test"
require "pry"

require "set"
require "pathname"

require "mock_suey/ext/instance_class"

module MockSuey
  module TypeChecks
    using Ext::InstanceClass

    class Sorbet
      def initialize(load_dirs: [])
        @load_dirs = Array(load_dirs)
      end

      # call_obj: MethodCall
      def typecheck!(call_obj, raise_on_missing: false)
        method_name = call_obj.method_name # String

        self_class = call_obj.receiver_class
        instance_class = call_obj.receiver_class
        class_class = call_obj.receiver_class.singleton_class? ? call_obj.receiver_class : call_obj.receiver_class.singleton_class

        original_method = instance_class.instance_method method_name
        method_sig = T::Private::Methods.signature_for_method(original_method)
        args = call_obj.arguments

        T::Private::Methods::CallValidation.validate_call(call_obj.mocked_instance, original_method, method_sig, args, nil)
      end
    end
  end
end
