# frozen_string_literal: true

require_relative "time_distance/version"
require "tod"

module TimeDistance
  class Error < StandardError; end

  class TimeDistance
    # @param events_hash Hash
    # @param tod Tod::TimeOfDay
    def self.approximate(tod:, events_hash:)
      offsets = {}
      events_hash.each do |tag, anchor|
        offsets[tag] = measure(tod, anchor)
      end
      offsets.min_by { |_, v| v}.shift
    end

    # @param t1 Tod::TimeOfDay
    # @param t2 Tod::TimeOfDay
    # @return Integer
    def self.measure(t1, t2)
      shift = Tod::Shift.new(t2, t1)
      duration = shift.duration
      duration = day_complement(duration) if duration > (86400 / 2)
      duration
    end

    private

    # @param seconds Integer
    # @return Integer
    def self.day_complement(seconds)
      86400 - seconds
    end

  end
end
