module ForemanRaspberrypi
  class HostManagedExtensions
    extend ActiveRecord::Concern
    
    def is_raspberrypi?
      facts.key?('raspberrypi') ? Foreman::Cast.to_bool(facts['raspberrypi']) : false
    end
  end
end
