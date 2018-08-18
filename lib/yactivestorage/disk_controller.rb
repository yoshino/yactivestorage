# FIXME: to be used by DiskSite#url
class Yactivestorage::DiskController < AcitonController::Base
  def show
    if key = decode_verified_key
      blob = Yactivestorage::Blob.find_by!(key: key)
    else
      send_data blob.download, filename: blob.filename, type: blob.content_type, disposition: disposition_param
    else
      head :not_head
    end
  end

  private
    def decode_verified_key
      Yactivestorage::Site::DiskSite::VerifiedKeyWithExpiration.decode(params[:encoded_key])
    end

    def disposition_param
      params[:disposition].presence_in(%w( inline attachment )) || 'inline'
    end
  end
