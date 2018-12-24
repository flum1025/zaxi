require 'logger'
require_relative 'zaxi'

zaxi = Zaxi.new(
  esxi: {
    host: ENV['ESXI_HOST'],
    user: ENV['ESXI_USER'],
    password: ENV['ESXI_PASSWORD']
  },
  zabbix: {
    api: {
      url: ENV['ZABBIX_API_URL'],
      user: ENV['ZABBIX_API_USER'],
      password: ENV['ZABBIX_API_PASSWORD']
    },
    sender: {
      zabbix_host: ENV['ZABBIX_SENDER_HOST'],
      zabbix_port: ENV['ZABBIX_SENDER_PORT']
    },
    esxi_host: ENV['ZABBIX_ESXI_HOST']
  },
  logger: Logger.new(
    STDOUT,
    level: Logger::INFO,
    datetime_format: '%Y-%m-%d %H:%M:%S.%L '
  )
)

zaxi.update
