module ForemanRaspberrypi
  class Raspbian < Operatingsystem
    PXEFILES = { startelf: 'start.elf', kernel: 'kernel.img' }.freeze

    def boot_files_uri(medium, architecture, host = nil)
      raise ::Foreman::Exception.new(N_('invalid medium for %s'), to_s) unless media.include?(medium)
      raise ::Foreman::Exception.new(N_('missing serial for %s'), to_s) unless host.try(:serial_no)

      pxe_dir = ''

      PXEFILES.values.collect do |img|
        if img =~ /boot.sdi/i || img =~ /bcd/i
          pxe_dir = "boot"
        elsif img =~ /boot.wim/i
          pxe_dir = "sources"
        else
          pxe_dir = ""
        end

        URI.parse("#{medium_vars_to_uri(medium.path, architecture.name, self)}/#{pxe_dir}/#{img}").normalize
      end
    end

    def pxe_files(medium, arch, host = nil)
      boot_files_uri(medium, arch, host).collect do |img|
        { host.serial_no.to_sym => img.to_s }
      end
    end
  end
end
