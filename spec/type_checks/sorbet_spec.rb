# frozen_string_literal: true

require "mock_suey/type_checks/sorbet"
require_relative "../fixtures/shared/tax_calculator_sorbet"

describe MockSuey::TypeChecks::Sorbet do
  subject(:checker) { described_class.new }

  context "with signatures" do
    let(:target) { instance_double("TaxCalculatorSorbet") }

    subject(:checker) do
      described_class.new
    end

    describe "build-in types" do
      it "hash" do
        target = {}

        allow(target).to receive(:key?).and_return(true)
        expect(target.key?("x")).to eq(true)

        mcall = MockSuey::MethodCall.new(
          receiver_class: Hash,
          method_name: :key?,
          arguments: ["x"],
          return_value: true,
          mocked_instance: target
        )

        expect do
          checker.typecheck!(mcall, raise_on_missing: true)
        end.not_to raise_error
      end
      # let(:target) { 1 }

      # it do
      #   allow(target).to receive(:to_s).and_return("custom_response")

      #   mcall = MockSuey::MethodCall.new(
      #     receiver_class: target.class,
      #     method_name: :to_s,
      #     arguments: [],
      #     return_value: "custom_response",
      #     mocked_instance: target
      #   )

      #   expect do
      #     checker.typecheck!(mcall)
      #   end.not_to raise_error
      # end
    end

    describe "type check without signatures" do
      def create_mcall(target)
        mcall = MockSuey::MethodCall.new(
          receiver_class: TaxCalculatorSorbet,
          method_name: :simple_test_no_sig,
          arguments: [120],
          return_value: 120,
          mocked_instance: target
        )
      end

      it "when raise_on_missing false" do
        allow(target).to receive(:simple_test_no_sig).and_return(120)
        mcall = create_mcall(target)

        expect do
          checker.typecheck!(mcall)
        end.not_to raise_error
      end

      it "when raise_on_missing true" do
        allow(target).to receive(:simple_test_no_sig).and_return(120)
        mcall = create_mcall(target)

        expect do
          checker.typecheck!(mcall, raise_on_missing: true)
        end.to raise_error(MockSuey::TypeChecks::MissingSignature)
      end
    end

    describe "type check argument type" do
      it "when correct" do
        allow(target).to receive(:simple_test).and_return(120)

        mcall = MockSuey::MethodCall.new(
          receiver_class: TaxCalculatorSorbet,
          method_name: :simple_test,
          arguments: [120],
          return_value: 120,
          mocked_instance: target
        )

        expect do
          checker.typecheck!(mcall)
        end.not_to raise_error
      end

      it "when incorrect" do
        allow(target).to receive(:simple_test).and_return(120)

        mcall = MockSuey::MethodCall.new(
          receiver_class: TaxCalculatorSorbet,
          method_name: :simple_test,
          arguments: ["120"],
          return_value: 120,
          mocked_instance: target
        )

        expect do
          checker.typecheck!(mcall)
        end.to raise_error(TypeError, /Parameter.*val.*Expected.*Integer.*got.*String.*/)
      end
    end

    describe "type check return type" do
      it "when correct" do
        allow(target).to receive(:simple_test).and_return(120)

        mcall = MockSuey::MethodCall.new(
          receiver_class: TaxCalculatorSorbet,
          method_name: :simple_test,
          arguments: [120],
          return_value: 120,
          mocked_instance: target
        )

        expect do
          checker.typecheck!(mcall)
        end.not_to raise_error
      end

      it "when incorrect" do
        allow(target).to receive(:simple_test).and_return("incorrect")

        mcall = MockSuey::MethodCall.new(
          receiver_class: TaxCalculatorSorbet,
          method_name: :simple_test,
          arguments: [120],
          return_value: 120,
          mocked_instance: target
        )

        expect do
          checker.typecheck!(mcall)
        end.to raise_error(TypeError, /.*Return value.*Expected.*Integer.*got.*String.*/)
      end
    end
  end
end
