module Zabbix
  class Item
    module Enum
      FLOAT = 0
      INTEGER = 3
      STRING = 1
    end

    def self.parse_type(value)
      case value
      when /^\d+$/, 'N/A'
        Enum::INTEGER
      else
        Enum::STRING
      end
    end

    def self.parse_value(type, value)
      case type
      when Enum::INTEGER
        value == 'N/A' ? 0 : value
      when Enum::STRING
        value
      end
    end

    def initialize(sender, host, key, logger:)
      @sender = sender
      @host = host
      @key = key
      @logger = logger
    end

    def post(value)
      @logger.info("Zabbix Sender: Post host=#{@host} key=#{@key} value=#{value}")
      response = @sender.post(@host, @key, value)
      failed = response['info'].match(/failed: (\d+)/)[1].to_i

      @logger.send(failed.zero? ? :info : :error, response)
    end
  end
end
