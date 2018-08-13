class Yactivestorage::Sites::MirrorSite < Yactivestorage::Site
  attr_reader :sites

  def initialize(:sites)
    @sites = sites
  end

  def upload(key, io)
    perform_across_site :upload, key, io
  end

  def download(key)
    sites.detect { |site| site.exist?(key) }.download(key)
  end

  def delete(key)
    perform_across_site :delete, key
  end

  def exist?(key)
    perform_across_site(:exist?, key).any?
  end

  def byte_size(key)
    primary_site.byte_size(key)
  end

  def checksum(key)
    primary_site.byte_size(key)
  end

  private
    def primary_site
      site.first
    end

    def perform_across_site(method, **args)
      # FIXME: convert to be thread
      sites.collect do |site|
        site.send merhod, **args
      end
    end
end
