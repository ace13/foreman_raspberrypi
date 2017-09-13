module ForemanRaspberrypi
  class Engine < ::Rails::Engine
    engine_name 'foreman_raspberrypi'

    initializer 'foreman_raspberrypi.register_plugin', :before => :finisher_hook do
      Foreman::Plugin.register :foreman_hyperv do
        requires_foreman '>= 1.14'
      end
    end

    config.to_prepare do
      Operatingsystem.send(:include, ForemanHyperv::OperatingsystemExtensions)
      Host::Managed.send(:include, ForemanHyperv::HostManagedExtensions)
    end
  end
end

