class Yactivestorage::Service::Configurator #:nodoc:
  attr_reader :configurations

  def self.build(service_name, configurations)
    new(configurations).build(service_name)
  end

  def initialize(configurations)
    @configurations = configurations.deep_symbolize_keys # 再帰的にhash化する
  end

  def build(service_name)
    config = config_for(service_name.to_sym)
    resolve(config.fetch(:service)).build(**config, configurator: self)
  end

   private
    def config_for(name)
      configurations.fetch name do
        raise "Missing configuration for the #{name.inspect} Active Storage service."
      end
    end

    def resolve(class_name)
      require "yactivestorage/service/#{class_name.to_s.downcase}_service"
      Yactivestorage::Service.const_get(:"#{class_name}Service")
    end
end