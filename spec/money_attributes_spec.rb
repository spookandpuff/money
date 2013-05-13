require 'rspec'
require File.expand_path(File.dirname(__FILE__)) +  '/../lib/spook_and_puff/money'
require File.expand_path(File.dirname(__FILE__)) +  '/../lib/spook_and_puff/money_attributes'

describe SpookAndPuff::MoneyAttributes do
  # A mocked out model because I really can't be bothered having ActiveRecord
  # as a development dependency.
  class TestModel 
    extend SpookAndPuff::MoneyAttributes
    attr_money :foo, :bar
    attr_reader :attributes

    def initialize(attrs = {})
      @attributes = {}
      attrs.each {|k, v| send(:"#{k}=", v)}
    end

    def [](attr)
      @attributes[attr]
    end

    def []=(attr, value)
      @attributes[attr] = value
    end
  end

  # A shortcut for constructing a money instance.
  #
  # @param String value
  #
  # @return MaggieBeer::Money
  def money(value)
    SpookAndPuff::Money.new(value)
  end

  before(:each) do
    @model = TestModel.new(:foo => BigDecimal.new('23.40'))
  end

  it 'should coerce a String into Money' do
    @model.bar = '12.34'
    expect(@model.bar).to eq(money('12.34'))
  end

  it 'should coerce a BigDecimal into Money' do
    @model.bar = BigDecimal.new('43.98')
    expect(@model.bar).to eq(money('43.98'))
  end

  it 'should assign an existing money instance' do
    @model.bar = money('5467.89')
    expect(@model.bar).to eq(money('5467.89'))
  end

  it 'should coerce a value from the attributes hash' do
    expect(@model.foo).to eq(money('23.40'))
  end

  it 'should allow attributes to be nil' do
    expect(@model.bar).to eq(nil)
  end

  it 'should allow attributes to be set to nil' do
    @model.foo = nil
    expect(@model.foo).to eq(nil)
  end

  it 'should only initialize model with BigDecimal values' do
    expect {
      TestModel.new(:foo => 43.22)
    }.to raise_error(TypeError)
  end

  it 'should update existing values' do
    expect(@model.foo).to eq(money('23.40'))
    @model.foo = '30.11'
    expect(@model.foo).to eq(money('30.11'))
  end

  it 'should set the underlying attribute to a BigDecimal' do
    @model.bar = '120.43'
    expect(@model[:bar]).to eq(BigDecimal.new('120.43'))
  end
end