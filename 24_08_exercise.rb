# frozen_string_literal: true

# Create module to extend module
module Excercise
  require 'test/unit/assertions'
  extend Test::Unit::Assertions

  def self.random_number(number)
    number.times.map { rand(1..99) }
  end

  def self.random_sign(number)
    (number - 1).times.map { ['+', '-'].sample }
  end

  def self.to_results(number1, number2)
    results = []

    while results.size < number1
      numbers = random_number(number2)
      signs = random_sign(number2)

      result = numbers.zip(signs).flatten.compact.join

      results << result if instance_eval(result).between?(1, 100) &&
                           !results.include?(result)
    end

    results
  end

  def self.number_to_string(*args)
    raise ArgumentError, 'Wrong args' unless args.size == 2 &&
                                             args.all? { |arg| arg.is_a?(Integer) } &&
                                             args[0].positive? &&
                                             [2, 3].include?(args[1])

    to_results(args[0], args[1])
  rescue ArgumentError => e
    e.message
  end
end

Excercise.assert_equal(Excercise.number_to_string(5, 2).size, 5)
Excercise.assert_equal(Excercise.number_to_string(5, 3).uniq.size, 5)
Excercise.assert_equal(Excercise.number_to_string(4, 2).all? do |res|
  res.split(/[+-]/).size == 2
end, true)
Excercise.assert_equal(Excercise.number_to_string(3, 3).all? do |res|
  instance_eval(res).between?(1, 100)
end, true)
Excercise.assert_equal(Excercise.number_to_string(-1, 2), 'Wrong args')
Excercise.assert_equal(Excercise.number_to_string(2, 1), 'Wrong args')
Excercise.assert_equal(Excercise.number_to_string(2, 4), 'Wrong args')
Excercise.assert_equal(Excercise.number_to_string(2), 'Wrong args')
Excercise.assert_equal(Excercise.number_to_string, 'Wrong args')
