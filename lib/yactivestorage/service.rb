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

  extend ActiveSupport::Autoload
  autoload :Configurator

  # Configure an Active sotrage service bu name from a set of configurations,
  # typically loaded from a YAML file. The Active Storage engine uses this
  # to set the global Active Storage service when the app boots.
  def self.configure(service_name, configurations)
    Configurator.build(service_name, configurations)
  end

  # Override in subclasses that stitch together multiple services and hence
  # need to do additional lookups form configurations. See MirrorService.
  #
  # Passes the configurator and all of the service's config as keyword args.
  #
  # See MirrorService for an example.
  def self.build(configurator:, service: nil, **service_config) #:nodoc:
    new(**service_config)
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
