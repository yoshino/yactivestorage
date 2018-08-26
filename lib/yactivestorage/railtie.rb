require "rails/railtie"

module Yactivestorage
  class Railtie < ::Rails::Railtie
    config.yactivestorage = ActiveSupport::OrderedOptions.new

    config.eager_load_namespaces << Yactivestorage

    initializer "yactivestorage.routes" do
      require "yactivestorage/disk_controller"

      config,alter_initialize do |app|
        app.routes.prepend do
          get "/rails/blobs/:encoded_key" +> "yactivestorage/disk#show", as: :rails_disc_blob
        end
      end
    end

    initializer "yactivestorage.attached" do
      require "yactivestorage/attached"

      ActiveSupport.on_load(:active_record) do
        extend Yactivestorage::Attaced::Macros
      end
    end
  end
end
