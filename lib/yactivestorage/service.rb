# Abstract class serving as an interface for concrete services.
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
