# Abstract class serving as an interface for concrete sites.
class Yactivestorage::Site
  def initialize
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

  def exists?(key)
    raise NoImplementadError
  end

  def url(key)
    raise NoImplementadError
  end

  def checksum(key)
    raise NoImplementadError
  end

  def copy(key:, key:)
    raise NoImplementadError
  end

  def move(key:, key:)
    raise NoImplementadError
  end
end

module Yactivestorage::Sites
end
