# frozen_string_literal: true

require "test_helper"

class TimeDistanceTest < Minitest::Test
  def test_version_number
    refute_nil ::TimeDistance::VERSION
  end

  def test_common_case
    t1 = Tod::TimeOfDay.parse("10:00")
    t2 = Tod::TimeOfDay.parse("11:00")
    assert_equal TimeDistance::TimeDistance.measure(t1, t2), 3600
  end

  def test_commutative
    t1 = Tod::TimeOfDay.parse("10:00")
    t2 = Tod::TimeOfDay.parse("11:00")
    assert_equal \
      TimeDistance::TimeDistance.measure(t1, t2),
      TimeDistance::TimeDistance.measure(t2, t1),
      "Is commutative"
  end

  def test_across_day_boundary
    t1 = Tod::TimeOfDay.parse("23:00")
    t2 = Tod::TimeOfDay.parse("01:00")
    assert_equal TimeDistance::TimeDistance.measure(t1, t2), 3600 * 2
  end

  def test_approximation
    events = {
      fasting: Tod::TimeOfDay.parse("07:00"),
      lunch: Tod::TimeOfDay.parse("13:00"),
      dinner: Tod::TimeOfDay.parse("19:00"),
      sleep: Tod::TimeOfDay.parse("23:59")
    }
    tod = Tod::TimeOfDay.parse("18:00")
    assert_equal :dinner, TimeDistance::TimeDistance.approximate(tod: tod, events_hash: events)
    tod = Tod::TimeOfDay.parse("03:00")
    assert_equal(:sleep, TimeDistance::TimeDistance.approximate(tod: tod, events_hash: events))
  end
end
