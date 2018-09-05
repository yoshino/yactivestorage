class Yactivestorage::Site::MirrorSite < Yactivestorage::Site
  attr_reader :sites

  def initialize(sites:)
    @sites = sites
  end

  def upload(key, io)
    sites.collect do |site|
      site.upload key, io
      io.rewind
    end
  end

  def download(key)
    sites.detect { |site| site.exist?(key) }.download(key)
  end

  def url(key, **options)
    primary_site.url(key, **options)
  end

  def delete(key)
    perform_across_sites :delete, key
  end

  def exist?(key)
    perform_across_sites(:exist?, key).any?
  end


  def byte_size(key)
    primary_site.byte_size(key)
  end

  def checksum(key)
    primary_site.checksum(key)
  end

  private
    def primary_site
      sites.first
    end

    def perform_across_sites(method, *args)
      # FIXME: Convert to be threaded
      sites.collect do |site|
        site.public_send method, *args
      end
    end
end
