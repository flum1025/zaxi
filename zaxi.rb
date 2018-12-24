require_relative 'esxi/client'
require_relative 'zabbix/client'
require_relative 'smart_item'

class Zaxi
  def initialize(esxi:, zabbix:, logger:)
    @logger = logger
    @esxi = ESXi::Client.new(esxi.merge(logger: logger))
    @zabbix = Zabbix::Client.new(zabbix.merge(logger: logger))
  end

  def update
    storages = @esxi.storages

    storages.each do |storage|
      smarts = SmartItem.parse(storage.device, storage.smart)
      smarts.each do |smart|
        _, value, = smart
        type = Zabbix::Item.parse_type(value.value)

        smart.each do |item|
          zabbix_item = @zabbix.create_item_if_not_exists(
            name: item.name,
            key: item.key,
            type: type
          )
          zabbix_item.post(Zabbix::Item.parse_value(type, item.value))
        end
      end
    end
  end
end
