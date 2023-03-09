# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'
require_relative "./tax_calculator"

class TaxCalculatorSorbet < TaxCalculator
  extend T::Sig

  sig { params(val: Integer).returns(Integer) }
  def simple_test(val)
    val
  end

  def simple_test_no_sig(val)
    val
  end
end

# TaxCalculatorSorbet.new.simple_test("124")
# Hash.new.key?("x")
# Hash.new.key2?("x")
