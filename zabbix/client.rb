require 'zabbixapi'
require 'zabbix_sender'
require 'openssl'
require_relative 'item'

module Zabbix
  class Client
    ZABBIX_ITEM_TRAPPER = 2
    ZABBIX_APPLICATION_NAME = 'storage.smart'.freeze
    ITEM_DEFAULT_VALUE = {
      delay: 60 * 60,
      type: ZABBIX_ITEM_TRAPPER,
      trapper_hosts: '',
      history: '90d',
      trends: '365d'
    }.freeze

    def initialize(api:, sender:, esxi_host:, logger:)
      @logger = logger
      @zabbix = ZabbixApi.connect(api)
      @sender = ZabbixSender.new(sender)
      @esxi_host = esxi_host
      @host_id = host_id(esxi_host)
      @application_id = @zabbix.applications.get_or_create(
        name: ZABBIX_APPLICATION_NAME, hostid: @host_id
      )
      @logger.info(
        "Zabbix: initialize host_id=#{@host_id} application_id=#{@application_id}"
      )
    end

    def create_item_if_not_exists(name:, key:, type:)
      @logger.info("Zabbix: Use item name=#{name} key=#{key} type=#{type}")
      @zabbix.items.get_or_create(ITEM_DEFAULT_VALUE.merge(
                                    name: name,
                                    key_: key,
                                    hostid: @host_id,
                                    value_type: type,
                                    applications: [@application_id]
                                  ))

      Item.new(@sender, @esxi_host, key, logger: @logger)
    end

    private

    def host_id(host)
      host_id = @zabbix.hosts.get_id(host: host)
      raise ArgumentError if host_id.nil?

      host_id
    end
  end
end
