# Abstract class serving as an interface for concrete services.

# The available services are:
#
# * +Disk+, to manage attachments saved directly on the hard drive.
# * +GCS+, to manage attachments through Google Cloud Storage.
# * +S3+, to manage attachments through Amazon S3.
# * +Mirror+, to be able to use several services to manage attachments.
#
# Inside a Rails application, you can set-up your services through the
# generated <tt>config/storage_services.yml</tt> file and reference one
# of the aforementioned constant under the +service+ key. For example:
#
#   local:
#     service: Disk
#     root: <%= Rails.root.join("storage") %>
#
# You can checkout the service's constructor to know which keys are required.
#
# Then, in your application's configuration, you can specify the service to
# use like this:
#
#   config.active_storage.service = :local
#
# If you are using Active Storage outside of a Ruby on Rails application, you
# can configure the service to use like this:
#
#   ActiveStorage::Blob.service = ActiveStorage::Service.configure(
#     :Disk,
#     root: Pathname("/foo/bar/storage")
#   )
class Yactivestorage::Service
  class Yactivestorage::IntegrityError < StandardError; end

  def self.configure(service, **options)
    begin
      require "yactivestorage/service/#{service.to_s.downcase}_service"
      Yactivestorage::Service.const_get(:"#{service}Service").new(**options)
    rescue LoadError => e
      puts "Could'nt configure unkown service: #{service} (#{e.message})"
    end
  end

  def upload(key, data, checksum: nil)
    raise NoImplementadError
  end

  def download(key)
    raise NoImplementadError
  end

  def delete(key)
    raise NoImplementadError
  end

  def exist?(key)
    raise NoImplementadError
  end

  def url(key, expires_in: nil, disposition:, filename:)
    raise NoImplementadError
  end

  def copy(from:, to:)
    raise NoImplementadError
  end
end
