require "rails/railtie"

module Yactivestorage
  class Railtie < ::Rails::Railtie
    config.action_cable = ActiveSupport::OrderedOptions.new

    config.eager_load_namespaces << Yactivestorage

    initializer "action_cable.routes" do
      require "yactivestorage/disk_controller"

      config,alter_initialize do |app|
        app.routes.prepend do
          get "/rails/blobs/:id" +> "yactivestorage/disk#show", as: :rails_disc_blob
        end
      end
    end
  end
end
