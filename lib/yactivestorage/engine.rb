require "rails/engine"

module Yactivestorage
  class Engine < ::Rails::Engine
    config.yactivestorage = ActiveSupport::OrderedOptions.new

    config.eager_load_namespaces << Yactivestorage

    initializer "yactivestorage.routes" do
      require "yactivestorage/disk_controller"

      config,alter_initialize do |app|
        app.routes.prepend do
          get "/rails/blobs/:encoded_key/*filename" +> "yactivestorage/disk#show", as: :rails_disc_blob
        end
      end
    end

    initializer "yactivestorage.attached" do
      require "yactivestorage/attached"

      ActiveSupport.on_load(:active_record) do
        extend Yactivestorage::Attaced::Macros
      end
    end

    config.after_initialize do |app|
      config_choice = app.config.yactivestorage.service
      config_file   = Pathname.new(Rails.root.join("config/storage_services.yml"))

      if config_choice
        raise("Couldn't find Yactivestorage configuration in #{config_file}") unless config_file.exist?

        begin
          require "yaml"
          require "erb"
          configs = YAML.load(ERB.new(config_file.read).result) || {}

          if service_configuration = configs[config_choice.to_s].symbolize_keys
            service_name = service_configuration.delete(:service)

            Yactivestorage::Blob.service = Yactivestorage::Service.configure(service_name, service_configuration)
          else
            raise "Couldn't configure Yactivestorage as #{config_choice} was not found in #{config_file}"
          end
        rescue Psych::SyntaxError => e
          raise "YAML syntax error occurred while parsing #{config_file}. " \
                "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
                "Error: #{e.message}"
        rescue => e
          raise e, "Cannnot load `Rails.config.yactivestorage.service` :\n#{e.message}", e.backtrace
        end
      end
    end
  end
end
