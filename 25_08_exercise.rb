# frozen_string_literal: true

# Create module to extend module
module Exercise
  require 'test/unit/assertions'
  extend Test::Unit::Assertions

  def self.order_generate(array)
    if array.first < array.last
      'yes, ascending'
    elsif array.first > array.last
      'yes, descending'
    else
      'no'
    end
  end

  def self.array_element_check(array, order)
    array.each_cons(2) do |a, b|
      next unless (order == 'yes, ascending' && a >= b) ||
                  (order == 'yes, descending' && a <= b)

      order = 'no'
      break
    end

    order
  end

  def self.check_order(*args)
    raise ArgumentError, 'Wrong array' unless args.size == 1 &&
                                              args[0].is_a?(Array) &&
                                              args[0].size >= 1 &&
                                              args[0].all? { |x| x.is_a?(Integer) }

    order = order_generate(args[0])

    array_element_check(args[0], order)
  rescue ArgumentError => e
    e.message
  end
end

Exercise.assert_equal(Exercise.check_order([1, 2]), 'yes, ascending')
Exercise.assert_equal(Exercise.check_order([15, 7, 3, -8]), 'yes, descending')
Exercise.assert_equal(Exercise.check_order([4, 2, 30]), 'no')
Exercise.assert_equal(Exercise.check_order([1, 1, 3]), 'no')
Exercise.assert_equal(Exercise.check_order([]), 'Wrong array')
Exercise.assert_equal(Exercise.check_order(['abc', 1, 3]), 'Wrong array')
Exercise.assert_equal(Exercise.check_order([1, [1], 3]), 'Wrong array')
Exercise.assert_equal(Exercise.check_order(123), 'Wrong array')
Exercise.assert_equal(Exercise.check_order('abc'), 'Wrong array')
Exercise.assert_equal(Exercise.check_order, 'Wrong array')
