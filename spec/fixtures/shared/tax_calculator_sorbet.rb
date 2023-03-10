# frozen_string_literal: true

require "sorbet-runtime"
require_relative "./tax_calculator"

class TaxCalculatorSorbet < TaxCalculator
  extend T::Sig

  sig { params(val: Integer).returns(Result) }
  def for_income(val)
    return if val < 0

    tax_rate = tax_rate_for(value: val)

    Result.new((tax_rate * val).to_i, tax_rate)
  end

  sig { params(val: Integer).returns(Integer) }
  def self.class_method_test(val)
    val
  end

  def self.class_method_test_no_sig(val)
    val
  end

  sig { params(val: Integer).returns(Integer) }
  def simple_test(val)
    val
  end

  def simple_test_no_sig(val)
    val
  end
end

class AccountantSorbet < Accountant
  extend T::Sig

  attr_reader :tax_calculator

  sig { params(tax_calculator: TaxCalculator).void }
  def initialize(tax_calculator: TaxCalculator.new)
    @tax_calculator = tax_calculator
  end

  sig { params(val: Integer).returns(Integer) }
  def net_pay(val)
    val - tax_calculator.for_income(val)
  end

  # def tax_for(val)
  #   tax_calculator.for_income(val).result
  # end

  # def tax_rate_for(value)
  #   tax_calculator.tax_rate_for(value)
  # end
end
