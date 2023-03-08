# typed: true
# frozen_string_literal: true

class TaxCalculatorSorbet < TaxCalculator
  sig { params(val: Integer).returns(Integer) }
  def simple_test(val); end
end
