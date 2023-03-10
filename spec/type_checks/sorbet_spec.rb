# frozen_string_literal: true

require "mock_suey/type_checks/sorbet"
require_relative "../fixtures/shared/tax_calculator_sorbet"


# TODO: make it shorter using shared_examples or method
# TODO: add singleton classes checks
describe MockSuey::TypeChecks::Sorbet do
  subject(:checker) { described_class.new }

  context "with signatures" do
    let(:target) { instance_double("TaxCalculatorSorbet") }

    subject(:checker) do
      described_class.new
    end

    describe "type check without signatures" do
      skip "type-checks core classes" do
        # 'sorbet-runtime' does not include signatures for stdlib classes yet
        mcall = MockSuey::MethodCall.new(
          receiver_class: Array,
          method_name: :take,
          arguments: ["first"],
          mocked_instance: Array.new
        )

        expect do
          checker.typecheck!(mcall)
        end.to raise_error(TypeError, /Expected.*Integer.*got.*String.*/)
      end

      def create_mcall(target)
        mcall = MockSuey::MethodCall.new(
          receiver_class: TaxCalculatorSorbet,
          method_name: :simple_test_no_sig,
          arguments: [120],
          mocked_instance: target
        )
      end

      it "when raise_on_missing false" do
        allow(target).to receive(:simple_test_no_sig).and_return(333)
        mcall = create_mcall(target)

        expect do
          checker.typecheck!(mcall)
        end.not_to raise_error
      end

      it "when raise_on_missing true" do
        allow(target).to receive(:simple_test_no_sig).and_return(333)
        mcall = create_mcall(target)

        expect do
          checker.typecheck!(mcall, raise_on_missing: true)
        end.to raise_error(MockSuey::TypeChecks::MissingSignature)
      end
    end

    describe "type check argument type" do
      describe "for mocked instance methods" do
        it "when correct" do
          allow(target).to receive(:simple_test).and_return(333)

          mcall = MockSuey::MethodCall.new(
            receiver_class: TaxCalculatorSorbet,
            method_name: :simple_test,
            arguments: [120],
            mocked_instance: target
          )

          expect do
            checker.typecheck!(mcall)
          end.not_to raise_error
        end

        it "when incorrect" do
          allow(target).to receive(:simple_test).and_return(333)

          mcall = MockSuey::MethodCall.new(
            receiver_class: TaxCalculatorSorbet,
            method_name: :simple_test,
            arguments: ["120"],
            mocked_instance: target
          )

          expect do
            checker.typecheck!(mcall)
          end.to raise_error(TypeError, /Parameter.*val.*Expected.*Integer.*got.*String.*/)
        end
      end

      describe "for mocked class methods" do
        describe "initialize" do
          let(:target) { instance_double("AccountantSorbet") }

          it "called correctly" do
            allow(target).to receive(:initialize)

            mcall = MockSuey::MethodCall.new(
              receiver_class: AccountantSorbet,
              method_name: :initialize,
              arguments: [{tax_calculator: TaxCalculator.new}],
              mocked_instance: target
            )

            expect { checker.typecheck!(mcall) }.not_to raise_error
          end

          it "called incorrectly" do
            allow(target).to receive(:initialize)

            mcall = MockSuey::MethodCall.new(
              receiver_class: AccountantSorbet,
              method_name: :initialize,
              arguments: [{tax_calculator: "incorrect"}],
              mocked_instance: target
            )

            expect do
              checker.typecheck!(mcall)
            end.to raise_error(TypeError, /.*Parameter.*tax_calculator.*Expected.*TaxCalculator.*got.*String.*/)
          end
        end

        it "when correct" do
          allow(TaxCalculatorSorbet).to receive(:class_method_test).and_return(333)

          mcall = MockSuey::MethodCall.new(
            receiver_class: TaxCalculatorSorbet,
            method_name: :class_method_test,
            arguments: [120],
            mocked_instance: TaxCalculatorSorbet
          )

          expect { checker.typecheck!(mcall) }.not_to raise_error
        end

        it "when incorrect" do
          allow(TaxCalculatorSorbet).to receive(:class_method_test).and_return(333)

          mcall = MockSuey::MethodCall.new(
            receiver_class: TaxCalculatorSorbet,
            method_name: :class_method_test,
            arguments: ["120"],
            mocked_instance: TaxCalculatorSorbet
          )

          expect do
            checker.typecheck!(mcall)
          end.to raise_error(TypeError, /Parameter.*val.*Expected.*Integer.*got.*String.*/)
        end
      end
    end

    describe "type check return type" do
      describe "for mocked instance methods" do
        it "when simple type is correct" do
          allow(target).to receive(:simple_test).and_return(333)

          mcall = MockSuey::MethodCall.new(
            receiver_class: TaxCalculatorSorbet,
            method_name: :simple_test,
            arguments: [120],
            mocked_instance: target
          )

          expect(checker.typecheck!(mcall)).to eq(333)
          expect do
            checker.typecheck!(mcall)
          end.not_to raise_error
        end

        it "when simple type is incorrect" do
          allow(target).to receive(:simple_test).and_return("incorrect")

          mcall = MockSuey::MethodCall.new(
            receiver_class: TaxCalculatorSorbet,
            method_name: :simple_test,
            arguments: [120],
            mocked_instance: target
          )

          expect do
            checker.typecheck!(mcall)
          end.to raise_error(TypeError, /.*Return value.*Expected.*Integer.*got.*String.*/)
        end

        it "when custom class is incorrect" do
          allow(target).to receive(:for_income).and_return("incorrect")

          mcall = MockSuey::MethodCall.new(
            receiver_class: TaxCalculatorSorbet,
            method_name: :for_income,
            arguments: [120],
            mocked_instance: target
          )

          expect do
            checker.typecheck!(mcall)
          end.to raise_error(TypeError, /.*Return value.*Expected.*TaxCalculator::Result.*got.*String.*/)
        end

        it "when custom class is correct" do
          allow(target).to receive(:for_income).and_return(TaxCalculator::Result.new)

          mcall = MockSuey::MethodCall.new(
            receiver_class: TaxCalculatorSorbet,
            method_name: :for_income,
            arguments: [120],
            mocked_instance: target
          )

          expect { checker.typecheck!(mcall) }.not_to raise_error
        end
      end

      describe "for mocked class methods" do
        it "when correct" do
          allow(TaxCalculatorSorbet).to receive(:class_method_test).and_return(333)

          mcall = MockSuey::MethodCall.new(
            receiver_class: TaxCalculatorSorbet,
            method_name: :class_method_test,
            arguments: [120],
            mocked_instance: TaxCalculatorSorbet
          )

          expect(checker.typecheck!(mcall)).to eq(333)
          expect do
            checker.typecheck!(mcall)
          end.not_to raise_error
        end

        it "when incorrect" do
          allow(TaxCalculatorSorbet).to receive(:class_method_test).and_return("incorrect")

          mcall = MockSuey::MethodCall.new(
            receiver_class: TaxCalculatorSorbet,
            method_name: :class_method_test,
            arguments: [120],
            mocked_instance: TaxCalculatorSorbet
          )

          expect do
            checker.typecheck!(mcall)
          end.to raise_error(TypeError, /.*Return value.*Expected.*Integer.*got.*String.*/)
        end
      end
    end
  end
end
