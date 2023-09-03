# frozen_string_literal: true

# Create module to extend module
module Exercise
  require 'test/unit/assertions'
  extend Test::Unit::Assertions

  POSITIONS = {
    'tonggiamdoc' => 0,
    'giamdoc' => 1,
    'truongphong' => 2,
    'nhanvienvp' => 3,
    'nhanviensale' => 4
  }.freeze

  def self.sort_positions(staffs)
    staffs.map do |staff|
      staff.merge({ positions: staff[:positions]
        .sort_by { |pos| POSITIONS[pos] } })
    end
  end

  def self.sort_staffs(staffs)
    staffs.sort_by do |staff|
      staff[:positions].minmax_by { |pos| POSITIONS[pos] }
    end
  end

  def self.check_staffs?(staffs)
    !staffs.empty? && staffs.is_a?(Array)
  end

  def self.check_staff?(staffs)
    staffs.all? do |staff|
      !staff[:id].to_s.empty? &&
        !staff[:positions].empty? &&
        staff[:positions].is_a?(Array) &&
        staff[:positions].all? { |pos| POSITIONS.include?(pos) }
    end
  end

  def self.sort_staffs_by_positions(staffs)
    raise ArgumentError, 'Wrong staffs' unless check_staffs?(staffs) &&
                                               check_staff?(staffs)

    sort_staffs(sort_positions(staffs))
  rescue ArgumentError => e
    e.message
  end
end

Exercise.assert_equal(
  Exercise.sort_staffs_by_positions([
                                      { id: 1, positions: %w[nhanviensale truongphong] },
                                      { id: 2, positions: %w[tonggiamdoc nhanviensale truongphong] }
                                    ]), [
                                      { id: 2, positions: %w[tonggiamdoc truongphong nhanviensale] },
                                      { id: 1, positions: %w[truongphong nhanviensale] }
                                    ]
)

Exercise.assert_equal(
  Exercise.sort_staffs_by_positions([
                                      { id: 1, positions: %w[nhanvien truongphong] },
                                      { id: 2, positions: %w[tonggiamdoc nhanviensale truongphong] }
                                    ]), 'Wrong staffs'
)

Exercise.assert_equal(
  Exercise.sort_staffs_by_positions([
                                      { id: 1, positions: [] },
                                      { id: 2, positions: %w[tonggiamdoc nhanviensale truongphong] }
                                    ]), 'Wrong staffs'
)

Exercise.assert_equal(
  Exercise.sort_staffs_by_positions([
                                      { id: 1, positions: 'abc' },
                                      { id: 2, positions: %w[tonggiamdoc nhanviensale truongphong] }
                                    ]), 'Wrong staffs'
)

Exercise.assert_equal(
  Exercise.sort_staffs_by_positions([
                                      { id: '', positions: %w[truongphong] },
                                      { id: 2, positions: %w[tonggiamdoc nhanviensale truongphong] }
                                    ]), 'Wrong staffs'
)

Exercise.assert_equal(Exercise.sort_staffs_by_positions([]), 'Wrong staffs')
Exercise.assert_equal(Exercise.sort_staffs_by_positions('abc'), 'Wrong staffs')
