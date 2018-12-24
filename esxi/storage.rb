module ESXi
  class Storage
    attr_reader :device

    def initialize(esxcli, device, logger:)
      @esxcli = esxcli
      @device = device
      @logger = logger
    end

    def smart
      @logger.info("ESXi: Get S.M.A.R.T devicename=#{@device}")
      @esxcli.storage.core.device.smart.get(devicename: @device)
    rescue RbVmomi::Fault => ex
      if ex.message == 'VimEsxCLICLIFault: EsxCLI.CLIFault.summary'
        @logger.error("ESXi: S.M.A.R.T. Status not supported devicename=#{@device}")
        return []
      end

      raise ex
    end
  end
end
