module ForemanRaspberrypi
  class Operatingsystem
    include ActiveRecord::Concern

    RPI_FIRMWARE_URI = 'https://cdn.rawgit.com/raspberrypi/firmware/77d8fdd2/boot'.freeze
    RPI_FIRMWARE_BLOBS = [
      'bcm2708-rpi-0-w.dtb',
      'bcm2708-rpi-b-plus.dtb',
      'bcm2708-rpi-b.dtb',
      'bcm2708-rpi-cm.dtb',
      'bcm2709-rpi-2-b.dtb',
      'bcm2710-rpi-3-b.dtb',
      'bcm2710-rpi-cm3.dtb',

      'bootcode.bin',
      'fixup.dat',
      'start.elf'
    ].freeze

    included do
      alias_method_chain :pxe_files, :raspberrypi
    end

    def pxe_files_with_raspberrypi(medium, arch, host = nil)
      if host && host.facts.key?('raspberrypi')
        sn = host.facts['boardserialnumber']
        boot_files_uri(medium, arch, host).merge(
          RPI_FIRMWARE_BLOBS.map { |b| "#{RPI_FIRMWARE_URI}/#{b}" }
        ).collect do |img|
          { sn.to_sym => img.to_s}
        end
      else
        pxe_files_without_raspberrypi
      end
    end
  end
end
