require "active_support/core_ext/module/delegation"

class Yactivestorage::Service::MirrorService < Yactivestorage::Service
  attr_reader :services

  delegate :download, :exist?, :url, :byte_size, :checksum, to: :primary_service

  def initialize(services:)
    @services = services
  end

  def upload(key, io, checksum: nil)
    services.collect do |service|
      service.upload key, io, checksum: checksum
      io.rewind
    end
  end

  def delete(key)
    perform_across_services :delete, key
  end

  private
    def primary_service
      services.first
    end

    def perform_across_services(method, *args)
      # FIXME: Convert to be threaded
      services.collect do |service|
        service.public_send method, *args
      end
    end
end
