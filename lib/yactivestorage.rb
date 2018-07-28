require "active_record"
require "yactivestorage/railtie" if defined?(Rails)

module Yactivestorage
  extend ActiveSupport::Autoload

  autoload :Blob
  autoload :Site
end
