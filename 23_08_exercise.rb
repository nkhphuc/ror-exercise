# frozen_string_literal: true

# Create module to extend module
module Exercise
  require 'test/unit/assertions'
  require_relative '22_08_exercise'
  extend Test::Unit::Assertions
  extend Exercise

  DNA = [%w[A T], %w[C G]].freeze

  # In case cannot extend Exercise, uncomment below code.

  # def self.check_string_array(string_array)
  #   return false unless string_array.is_a?(Array) &&
  #                       string_array.size == 2 &&
  #                       string_array.all? do |item|
  #                         item.is_a?(String) &&
  #                         !item.to_s.empty?
  #                       end

  #   array0_downcase = string_array[0].downcase
  #   string_array[1].downcase.chars.uniq.all? do |char|
  #     array0_downcase.include?(char)
  #   end
  # end

  def self.return_opposite(character)
    DNA.select { |array| array.include?(character) }.flatten
       .reject { |element| element == character }.join
  end

  # Currently accept lowcase string
  def self.return_dna(*args)
    raise ArgumentError, 'Wrong DNA' unless args.size == 1 &&
                                            check_string_array([].push(DNA
                                              .flatten.join, args[0]))

    args[0].upcase.chars.map { |char| return_opposite(char) }.join
  rescue ArgumentError => e
    e.message
  end
end

Exercise.assert_equal(Exercise.return_dna('AAAA'), 'TTTT')
Exercise.assert_equal(Exercise.return_dna('ATTGC'), 'TAACG')
Exercise.assert_equal(Exercise.return_dna('GTAT'), 'CATA')
Exercise.assert_equal(Exercise.return_dna('AAGG'), 'TTCC', 'String AAGG is')
Exercise.assert_equal(Exercise.return_dna('CGCG'), 'GCGC', 'String CGCG is')
Exercise.assert_equal(Exercise.return_dna('ATTGC'), 'TAACG', 'String ATTGC is')
Exercise.assert_equal(Exercise.return_dna(
                        'GTATCGATCGATCGATCGATTATATTTTCGACGAGATTTAAATATATATATATACGAGAGAATACAGATAGACAGATTA'
                      ),
                      'CATAGCTAGCTAGCTAGCTAATATAAAAGCTGCTCTAAATTTATATATATATATGCTCTCTTATGTCTATCTGTCTAAT')
# Currently accept lowcase string
Exercise.assert_equal(Exercise.return_dna('aaaa'), 'TTTT')
Exercise.assert_equal(Exercise.return_dna('abcd'), 'Wrong DNA')
Exercise.assert_equal(Exercise.return_dna('EFGH'), 'Wrong DNA')
Exercise.assert_equal(Exercise.return_dna('JUST a string'), 'Wrong DNA')
Exercise.assert_equal(Exercise.return_dna(''), 'Wrong DNA')
Exercise.assert_equal(Exercise.return_dna(1234), 'Wrong DNA')
Exercise.assert_equal(Exercise.return_dna([]), 'Wrong DNA')
Exercise.assert_equal(Exercise.return_dna, 'Wrong DNA')
