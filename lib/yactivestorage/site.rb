# Abstract class serving as an interface for concrete sites.
class Yactivestorage::Site
  def self.configure(site, **options)
    begin
      require "yactivestorage/site/#{site.to_s.downcase}_site"
      Yactivestorage::Site.const_get(:"#{site}Site").new(**options)
    rescue LoadError
      puts "Could'nt configure unkown site: #{site}"
    end
  end

  def upload(key, data)
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

  def checksum(key)
    raise NoImplementadError
  end

  def copy(from:, to:)
    raise NoImplementadError
  end

  def bytesize(key)
    raise NoImplementadError
  end
end
