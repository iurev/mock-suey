# frozen_string_literal: true

require "sorbet-runtime"
require_relative "./tax_calculator.rb"

class TaxCalculatorSorbet < TaxCalculator
  extend T::Sig

  sig {params(val: Integer).returns(Integer)}
  def simple_test(val)
    return val
  end
end

