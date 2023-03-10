# frozen_string_literal: true

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

      def typecheck!(method_call, raise_on_missing: false)
        method_name = method_call.method_name
        mocked_obj = method_call.mocked_instance
        is_singleton = method_call.receiver_class.singleton_class?
        is_a_class = mocked_obj.is_a? Class
        # unbound_mocked_method = if is_singleton || [:initialize, :new].include?(method_name)
        unbound_mocked_method = if is_singleton
          mocked_obj.instance_method(method_name)
        else
          mocked_obj.method(method_name).unbind
        end
        args = method_call.arguments

        unbound_original_method = if is_a_class
          mocked_obj.method(method_name)
        else
          method_call.receiver_class.instance_method(method_name)
        end
        original_method_sig = T::Private::Methods.signature_for_method(unbound_original_method)

        # TODO: do not raise on missing
        unless original_method_sig
          raise MissingSignature, "No signature found for #{method_call.method_desc}" if raise_on_missing
          return
        end

        # require 'pry'; binding.pry
        T::Private::Methods::CallValidation.validate_call(
          mocked_obj,
          unbound_mocked_method,
          original_method_sig,
          args,
          nil
        )
      end
    end
  end
end
