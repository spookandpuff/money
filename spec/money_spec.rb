require 'rspec'
require File.expand_path(File.dirname(__FILE__)) +  '/../lib/spook_and_puff/money'

describe SpookAndPuff::Money do
  # A shortcut for constructing a money instance.
  #
  # @param String value
  #
  # @return MaggieBeer::Money
  def money(value)
    SpookAndPuff::Money.new(value)
  end

  it "should create a zero value" do
    expect(SpookAndPuff::Money.zero).to eq(money("0"))
  end

  it "should format to currency string" do
    expect(money('345.8724').to_s).to eq('$345.87')
    expect(money('4543.6798').to_s).to eq('$4543.68')
  end

  it "should format currency string without prefix" do
    expect(money('345.8724').to_s(:prefix => false)).to eq('345.87')
    expect(money('4543.6798').to_s(:prefix => false)).to eq('4543.68')
  end

  it "should format currency string while optionally dropping zero cents" do
    expect(money('345.00').to_s(:drop_cents => true)).to eq('$345')
    expect(money('345.45').to_s(:drop_cents => true)).to eq('$345.45')
    expect(money('345.00').to_s(:prefix => false, :drop_cents => true)).to eq('345')
    expect(money('345.45').to_s(:prefix => false, :drop_cents => true)).to eq('345.45')
  end

  it "should make correct comparisons" do
    expect(money('45.68') == money('45.68')).to eq(true)
  end

  it "should handle multiplication" do
    expect(money('32.35') * 2).to eq(money('64.70'))
  end

  it "should handle division" do
    expect(money('335.05') / 2).to eq(money('167.525'))
    expect(money('300') / 3).to eq(money('100'))
    expect(money('32.50') / 8).to eq(money('4.0625'))
  end

  it "should handle subtraction" do
    expect(money('20.50') - money('15')).to eq(money('5.50'))
  end

  it 'should handle negation' do
    expect(-money('30')).to eq(money('-30'))
    expect(-money('-74.6')).to eq(money('74.6'))
  end

  it "should handle unary plus" do
    expect(+money('45')).to eq(money('45'))
    expect(+money('-45')).to eq(money('-45'))
  end

  it "should handle addition" do
    expect(money('36.324') + money('13.4')).to eq(money('49.724'))
    expect(money('36.324') + money('-13.4')).to eq(money('22.924'))
  end

  it "should return a percentage" do
    expect(money('100').percent(10)).to eq(money('10'))
  end

  it "should accept currency formatted strings" do
    expect(money('$12.89')).to eq(money('12.89'))
  end

  it "should initialize with another money instance" do
    expect(money(money('34.56'))).to eq(money('34.56'))
  end

  it "should calculate proportion as percentage" do
    expect(money('200').proportion(money('50'))).to eq(BigDecimal.new('25'))
  end

  it "should return the value in cents" do
    expect(money('10.20').cents).to eq(BigDecimal.new('1020'))
    expect(money('0.5').cents).to eq(BigDecimal.new('50'))
    expect(money('-20.34').cents).to eq(BigDecimal.new('-2034'))
    expect(money('0').cents).to eq(BigDecimal.new('0'))
  end

  it "should check for zero value" do
    expect(money('0').zero?).to eq(true)
    expect(money('-2').zero?).to eq(false)
    expect(money('2').zero?).to eq(false)
  end

  it "should check for non negative value" do
    expect(money('0').non_negative?).to eq(true)
    expect(money('10').non_negative?).to eq(true)
    expect(money('-1').non_negative?).to eq(false)
    expect(money('-234').non_negative?).to eq(false)
  end

  it "should check for negative value" do
    expect(money('-1').negative?).to eq(true)
    expect(money('-456').negative?).to eq(true)
    expect(money('0').negative?).to eq(false)
    expect(money('346').negative?).to eq(false)
  end

  it "should check for a positive value" do
    expect(money('3').positive?).to eq(true)
    expect(money('0').positive?).to eq(false)
    expect(money('-1').positive?).to eq(false)
  end
end
