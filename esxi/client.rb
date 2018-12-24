require 'rbvmomi'
require_relative 'storage'

module ESXi
  class Client
    def initialize(host:, user:, password:, insecure: true, logger:)
      @logger = logger
      vim = RbVmomi::VIM.connect(
        host: host,
        user: user,
        password: password,
        insecure: insecure
      )
      @host = vim.root.childEntity[0].hostFolder.childEntity[0].host[0]
      @logger.info("ESXi: Found host #{@host.summary.config.name}")
    end

    def storages
      esxcli = @host.esxcli
      devices = esxcli.storage.core.device.list.map(&:Device)
      @logger.info("ESXi: Found devices [#{devices.join(',')}]")
      devices.map { |device| Storage.new(esxcli, device, logger: @logger) }
    end
  end
end
