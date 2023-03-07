# frozen_string_literal: true

# gem "rbs", "~> 2.0"
# require "rbs"
# require "rbs/test"
require "pry"

require "set"
require "pathname"

require "mock_suey/ext/instance_class"


# module CustomCallValidation
#   # extend T::Private::Methods::CallValidation
#   include T::Private::Methods::CallValidation

#   def self.included(base)
#     base.instance_eval do
#       # extend T::Private::Methods::CallValidation
#       include T::Private::Methods::CallValidation
#     end
#   end

#   def self.validate_call_skip_block_type(instance, original_method, method_sig, args, blk)
#     # This method is called for every `sig`. It's critical to keep it fast and
#     # reduce number of allocations that happen here.

#     if method_sig.bind
#       message = method_sig.bind.error_message_for_obj(instance)
#       if message
#         CallValidation.report_error(
#           method_sig,
#           message,
#           'Bind',
#           nil,
#           method_sig.bind,
#           instance
#         )
#       end
#     end

#     # NOTE: We don't bother validating for missing or extra kwargs;
#     # the method call itself will take care of that.
#     method_sig.each_args_value_type(args) do |name, arg, type|
#       message = type.error_message_for_obj(arg)
#       if message
#         CallValidation.report_error(
#           method_sig,
#           message,
#           'Parameter',
#           name,
#           type,
#           arg,
#           caller_offset: 2
#         )
#       end
#     end

#     # The original method definition allows passing `nil` for the `&blk`
#     # argument, so we do not have to do any method_sig.block_type type checks
#     # of our own.

#     # The following line breaks are intentional to show nice pry message










#     # PRY note:
#     # this code is sig validation code.
#     # Please issue `finish` to step out of it

#     # return_value = T::Configuration::AT_LEAST_RUBY_2_7 ? original_method.bind_call(instance, *args, &blk) : original_method.bind(instance).call(*args, &blk)
#     return_value = 120

#     # The only type that is allowed to change the return value is `.void`.
#     # It ignores what you returned and changes it to be a private singleton.
#     if method_sig.return_type.is_a?(T::Private::Types::Void)
#       T::Private::Types::Void::VOID
#     else
#       message = method_sig.return_type.error_message_for_obj(return_value)
#       if message
#         CallValidation.report_error(
#           method_sig,
#           message,
#           'Return value',
#           nil,
#           method_sig.return_type,
#           return_value,
#         )
#       end
#       return_value
#     end
#   end
# end

module MockSuey
  module TypeChecks
    using Ext::InstanceClass

    class Sorbet
      def initialize(load_dirs: [])
        @load_dirs = Array(load_dirs)
      end

      def typecheck!(call_obj, raise_on_missing: false)
        method_name = call_obj.method_name # String

        self_class = call_obj.receiver_class
        instance_class = call_obj.receiver_class
        class_class = call_obj.receiver_class.singleton_class? ? call_obj.receiver_class : call_obj.receiver_class.singleton_class

        unbound_mocked_method = call_obj.mocked_instance.method(method_name).unbind
        original_method_sig = T::Private::Methods.signature_for_method(call_obj.receiver_class.instance_method(method_name))
        args = call_obj.arguments

        T::Private::Methods::CallValidation.validate_call(call_obj.mocked_instance, unbound_mocked_method, original_method_sig, args, nil)
      end
    end
  end
end
