# frozen_string_literal: true

require 'set'

module Longhorn
  def self.run
    result = Set.new
    ["allocated", "retained"]
      .product(["memory", "objects"])
      .product(["gem", "file", "location", "class"])
      .each do |(type, metric), name|
        result << "#{type} #{metric} by #{name}"
      end
    result
  end
end
