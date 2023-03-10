# frozen_string_literal: true

shared_examples "accountant" do
  subject {
    T::Configuration.call_validation_error_handler = lambda do |signature, opts|
      # https://github.com/rspec/rspec-mocks/blob/v3.12.3/lib/rspec/mocks/test_double.rb
      doubled_class_name = opts[:value].instance_variable_get :"@name"
      doubled_class = Kernel.const_get(doubled_class_name)
      are_related = doubled_class <= opts[:type].raw_type
      is_mocked = opts[:value].is_a? RSpec::Mocks::Double

      return if is_mocked && are_related
      T::Configuration.call_validation_error_handler_default(signature, opts)
    end
    AccountantSorbet.new(tax_calculator: tax_calculator)
  }

  it "#net_pay" do
    expect(subject.net_pay(89)).to eq 47
  end

  it "#tax_rate_for" do
    # FAILURE(verified): Result in TaxCalucalor.tax_rate_for(40) calls,
    # which doesn't match the parameters
    expect(subject.tax_rate_for(40)).to eq(10)
  end

  describe "#tax_for" do
    specify "negative amount" do
      expect(subject.tax_for(-10)).to eq(0)
    end
  end
end
