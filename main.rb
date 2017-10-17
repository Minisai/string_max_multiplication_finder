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
    input_string.each_char.with_index do |character, index|
      parse_digit(character).tap do |digit|
        find_in_sub_string(input_string[index..-1]) if digit && digit != 0
      end
    end

    result
  end

  private

  def find_in_sub_string(sub_string)
    return result if sub_string.length < mult_size

    digits = []
    sub_string.each_char do |character|
      parse_digit(character).tap do |digit|
        if digit && digit != 0
          digits << digit

          if digits.size == mult_size
            multiply_digits(digits)
            return
          end
        else
          return
        end
      end
    end
  end

  def result
    max_multiplication == 0 ? nil : max_multiplication
  end

  def multiply_digits(digits)
    multiplication = digits.inject(:*)
    if multiplication > max_multiplication
      @max_multiplication = multiplication
    end
  end

  def parse_digit(character)
    Integer(character)
  rescue ArgumentError, TypeError
    nil
  end
end

# Benchmark test
# s = 'sdf03030252221234ывалодывлаоывлдао947984934-двыладлвыадлоыв939854094509069569046ьkjdhsdkfi09348493200234'
#
# finder = StringMaxMultiplicationFinder.new(s)
# p Benchmark.measure { 50_000.times { finder.find } }.real

describe 'StringMaxMultiplicationFinder' do
  context 'multiplication present' do
    test_strings = {
      'abc12345def' => 120,
      '03030252221234' => 40,
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
