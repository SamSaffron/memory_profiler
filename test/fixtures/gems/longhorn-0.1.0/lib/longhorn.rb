# frozen_string_literal: true

require 'erb'

module Longhorn
  def self.run
    result = []
    ["allocated", "retained"]
      .product(["memory", "objects"])
      .product(["gem", "file", "location", "class"])
      .each do |(type, metric), name|
        result << ERB.new("<%= type %> <%= metric %> by <%= name %>").result(binding)
      end
    result
  end
end
