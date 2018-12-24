require 'facets/string/snakecase'

class SmartItem
  SMART_ITEM_KEYS = %i[Threshold Value Worst].freeze
  KEY_PREFIX = 'storage.smart'.freeze

  attr_reader :name, :key, :value

  def self.parse(device, smarts)
    smarts.map do |smart|
      SMART_ITEM_KEYS.map do |key|
        new(
          "#{smart.Parameter} #{key} (#{device})",
          "#{KEY_PREFIX}[#{device},#{smart.Parameter.snakecase},#{key.to_s.downcase}]",
          smart.send(key)
        )
      end
    end
  end

  def initialize(name, key, value)
    @name = name
    @key = key
    @value = value
  end
end
