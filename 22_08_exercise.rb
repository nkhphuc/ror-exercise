# frozen_string_literal: true

# Create module to extend module
module Exercise
  require 'test/unit/assertions'
  extend Test::Unit::Assertions

  def self.check_string_array(string_array)
    return false unless string_array.is_a?(Array) &&
                        string_array.size == 2 &&
                        string_array.all? do |item|
                          item.is_a?(String) &&
                          !item.to_s.empty?
                        end

    array0_downcase = string_array[0].downcase
    string_array[1].downcase.chars.uniq.all? do |char|
      array0_downcase.include?(char)
    end
  end
end

Exercise.assert_equal(Exercise.check_string_array(%w[trances nectar]), true)
Exercise.assert_equal(Exercise.check_string_array(['THE EYES', 'they see']), true)
Exercise.assert_equal(Exercise.check_string_array(%w[assert staring]), false)
Exercise.assert_equal(Exercise.check_string_array(%w[arches later]), false)
Exercise.assert_equal(Exercise.check_string_array(%w[dale caller]), false)
Exercise.assert_equal(Exercise.check_string_array(%w[parses parsecs]), false)
Exercise.assert_equal(Exercise.check_string_array(%w[replays adam]), false)
Exercise.assert_equal(Exercise.check_string_array(%w[mastering streaming]), true)
Exercise.assert_equal(Exercise.check_string_array(%w[drapes compadres]), false)
Exercise.assert_equal(Exercise.check_string_array(%w[deltas slated]), true)
Exercise.assert_equal(Exercise.check_string_array(%w[abc abc abc]), false)
Exercise.assert_equal(Exercise.check_string_array(['abc']), false)
Exercise.assert_equal(Exercise.check_string_array(['abc', '']), false)
Exercise.assert_equal(Exercise.check_string_array(['', 'abc']), false)
Exercise.assert_equal(Exercise.check_string_array(['', '']), false)
Exercise.assert_equal(Exercise.check_string_array(['12', 1122]), false)
Exercise.assert_equal(Exercise.check_string_array([12, '1122']), false)
Exercise.assert_equal(Exercise.check_string_array([12, 1122]), false)
Exercise.assert_equal(Exercise.check_string_array('ab'), false)
Exercise.assert_equal(Exercise.check_string_array(12), false)
