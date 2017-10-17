require 'rspec'
require 'pry'
require 'benchmark'

class StringMaxMultiplicationFinder
  attr_reader :input_string, :mult_size, :max_multiplication

  def initialize(input_string, mult_size=4)
    @input_string = input_string
    @mult_size = mult_size
    @max_multiplication = 0
  end

  def find
    digits = []

    input_string.each_char.with_index do |character, index|
      if digit_character?(character)
        digit = Integer(character)
        next if digit == 0
        digits << digit

        input_string[index+1..-1].each_char do |character|
          if digit_character?(character)
            break if digit == 0
            digit = Integer(character)
            digits << digit

            if digits.length == mult_size
              multiply_digits(digits)
              digits = []
              break
            end
          else
            digits = []
            break
          end
        end
      end
    end

    max_multiplication == 0 ? nil : max_multiplication
  end

  private

  def multiply_digits(digits)
    multiplication = digits.inject(:*)
    if multiplication > max_multiplication
      @max_multiplication = multiplication
    end
  end

  #checking of Integer via exception handling is quite slow:
  def digit_character?(character)
    Integer(character).is_a?(Integer)
  rescue ArgumentError, TypeError
    false
  end
end

s = 'sdf03030252221234ывалодывлаоывлдао947984934-двыладлвыадлоыв939854094509069569046ьkjdhsdkfi09348493200234'

finder = StringMaxMultiplicationFinder.new(s)
p Benchmark.measure { 50_000.times { finder.find } }.real

describe 'String max multiplier' do
  context 'multiplication present' do
    test_strings = {
      'abc12345def' => 120,
      'sdf03030252221234' => 40,
      'sdf03030252221234ывалодывлаоывлдао947984934-двыладлвыадлоыв939854094509069569046ьkjdhsdkfi09348493200234' => 2592
    }

    test_strings.each do |test_string, expected_result|
      it "calculates correct result for #{test_string}" do
        expect(StringMaxMultiplicationFinder.new(test_string).find).to eq expected_result
      end
    end
  end

  context 'multiplication absent' do
    let(:test_string) { 'a1b2c3d4e' }

    it 'returns nil' do
      expect(StringMaxMultiplicationFinder.new(test_string).find).to eq nil
    end
  end
end
