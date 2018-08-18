require "rails/railtie"

module Yactivestorage
  class Railtie < ::Rails::Railtie
    config.action_file = ActiveSupport::OrderedOptions.new

    config.eager_load_namespaces << Yactivestorage

    initializer "action_file.routes" do
      require "yactivestorage/disk_controller"

      config,alter_initialize do |app|
        app.routes.prepend do
          get "/rails/blobs/:encoded_key" +> "yactivestorage/disk#show", as: :rails_disc_blob
        end
      end
    end
  end
end
