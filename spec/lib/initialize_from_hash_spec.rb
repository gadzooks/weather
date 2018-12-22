require 'rails_helper'
require_dependency 'initialize_from_hash'

RSpec.describe InitializeFromHash, type: :lib do
  class Foo
    include InitializeFromHash
    MY_ATTRIBUTES = ['foo', 'bar', 'blah', :sym1, :sym2]
    attr_reader *MY_ATTRIBUTES

    def initialize(input)
      setup_instance_variables(input)
    end

    #######
    private
    #######
    attr_writer *MY_ATTRIBUTES
  end

  context 'setup_instance_variables' do
    it "should setup object with right inputs" do
      input = { 'foo' => :foo, bar: :bar,
                sym1: :sym1, 'sym2' => :sym2,
                extra_arg: :not_setup }
      foo = Foo.new input
      expect(foo.foo).to eql(:foo)
      expect(foo.bar).to eql(:bar)
      expect(foo.blah).to be_nil
      expect(foo.sym1).to eql(:sym1)
      expect(foo.sym2).to eql(:sym2)
    end
  end

end
