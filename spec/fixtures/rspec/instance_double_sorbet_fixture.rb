# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../../../../lib", __FILE__)

require_relative "./spec_helper"
require_relative "../shared/tax_calculator_sorbet"
# require_relative "tax_calculator_sorbet_spec"

describe AccountantSorbet do
  let!(:tax_calculator) {
    target = instance_double("TaxCalculatorSorbet")
    # allow(target).to receive(:tax_rate_for).and_return(10)
    # # FAILURE(typed): Return type is incorrect
    # allow(target).to receive(:for_income).and_return(42)
    # # FAILURE(contract): Return type doesn't match the passed arguments
    # allow(target).to receive(:for_income).with(-10).and_return(TaxCalculator::Result.new(0))
    target
  }
  let!(:accountant) { AccountantSorbet.new(tax_calculator: tax_calculator) }

  describe ".initialize checks handled by sorbet_rspec.rb" do
    it "correct param" do
      tc = TaxCalculatorSorbet.new
      expect { described_class.new(tax_calculator: tc) }.not_to raise_error
    end
    it "correct double" do
      tc = double("TaxCalculatorSorbet")
      expect { described_class.new(tax_calculator: tc) }.not_to raise_error
    end
    it "correct instance double" do
      tc = instance_double("TaxCalculatorSorbet")
      expect { described_class.new(tax_calculator: tc) }.not_to raise_error
    end
    it "correct instance double from parent class" do
      tc = instance_double("TaxCalculator")
      expect { described_class.new(tax_calculator: tc) }.not_to raise_error
    end
    it "unrelated double" do
      unrelated_double = instance_double("Array")
      expect do
        described_class.new(tax_calculator: unrelated_double)
      end.to raise_error(TypeError, /.*Expected type TaxCalculator, got type RSpec::Mocks::InstanceVerifyingDouble.*/)
    end
  end

  describe "#net_pay" do
    describe "without mocks" do
      let(:tax_calculator) { TaxCalculatorSorbet.new }
      it "raises ruby error because the method is intentionally written incorrectly" do
        expect { accountant.net_pay(10) }.to raise_error(TypeError, "TaxCalculator::Result can't be coerced into Integer")
      end
    end

    describe "with mocks" do
      let!(:tax_calculator) do
        target = TaxCalculatorSorbet.new
        allow(target).to receive(:for_income).and_return(return_result)
        target
      end
      describe "with incorrect return" do
        let(:return_result) { 333 }
        skip "raises ruby error because the method is intentionally written incorrectly" do
          expect { accountant.net_pay(10) }.not_to raise_error(SystemStackError) # TODO: fix it!!!
        end
      end
      describe "with correct return" do
        let!(:return_result) { TaxCalculator::Result.new(3, 33) }
        skip "raises ruby error because the method is intentionally written incorrectly" do
          expect { accountant.net_pay(10) }.not_to raise_error(SystemStackError) # TODO: fix it!!!
        end
      end
    end
  end

  # describe "#tax_pay_for" do
  #   describe "without mocks" do
  #     let(:tax_calculator) { TaxCalculatorSorbet.new }
  #     it "raises ruby error because the method is intentionally written incorrectly" do
  #       expect { accountant.net_pay(10) }.to raise_error(TypeError, "TaxCalculator::Result can't be coerced into Integer")
  #     end
  #   end

  #   describe "with mocks" do
  #     describe "with incorrect return" do
  #       let!(:tax_calculator) do
  #         target = TaxCalculatorSorbet.new
  #         allow(target).to receive(:for_income).and_return(333)
  #         target
  #       end
  #       skip "raises ruby error because the method is intentionally written incorrectly" do
  #         expect { accountant.net_pay(10) }.not_to raise_error(SystemStackError) # TODO: fix it!!!
  #       end
  #     end
  #     describe "with correct return" do
  #       let!(:tax_calculator) do
  #         target = TaxCalculatorSorbet.new
  #         allow(target).to receive(:for_income).and_return(TaxCalculator::Result.new(3, 33))
  #         target
  #       end
  #       skip "raises ruby error because the method is intentionally written incorrectly" do
  #         expect { accountant.net_pay(10) }.not_to raise_error(SystemStackError) # TODO: fix it!!!
  #       end
  #     end
  #   end
  # end

  # it "#tax_rate_for" do
  #   # FAILURE(verified): Result in TaxCalucalor.tax_rate_for(40) calls,
  #   # which doesn't match the parameters
  #   expect(subject.tax_rate_for(40)).to eq(10)
  # end

  # describe "#tax_for" do
  #   specify "negative amount" do
  #     expect(subject.tax_for(-10)).to eq(0)
  #   end
  # end
end
