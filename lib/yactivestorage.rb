require "active_record"
require "yactivestorage/engine" if defined?(Rails)

module Yactivestorage
  extend ActiveSupport::Autoload

  autoload :Blob
  autoload :Service
end
