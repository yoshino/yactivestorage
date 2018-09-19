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
      if config_choice = app.config.yactivestorage.service
        config_file   = Pathname.new(Rails.root.join("config/storage_services.yml"))
        raise("Couldn't find Yactivestorage configuration in #{config_file}") unless config_file.exist?

        require "yaml"
        require "erb"

        configs =
          begin
            YAML.load(ERB.new(config_file.read).result) || {}
          rescue Psych::SyntaxError => e
            raise "YAML syntax error occurred while parsing #{config_file}. " \
                  "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
                  "Error: #{e.message}"
          end

        Yactivestorage::Blob.service =
          begin
            Yactivestorage::Service.configure config_choice, configs
          rescue => e
            raise e, "Cannnot load `Rails.config.yactivestorage.service` :\n#{e.message}", e.backtrace
          end
      end
    end
  end
end
