# Yactivestorage

...

## Example

class Person < ApplicationRecord
  has_one :avatar
end

class Avatar < ApplicationRecord
  belongs_to :person
  belongs_to :imagem class_name: 'Yactivestorage::Blob'

  has_file :image
end

avatar.image_url(expires_in: 5.minuites)

class Yactivestorage::DownloadsController < ApplicationController::Base
  def show
    head :ok, ActiveFile::Blob.locate(params[:id]).download_headers
  end
end

class AvatarsController < ApplicationController
  def create
    # @avatar = Avatar.create \
    #   image: Yactivestorage::Blob.save!(file_name: params.require(:name), content_type, request.content_type, data: request.body)
    @avatar = Avatar.create! image: Avatar.image.extract_from(request)
  end
end

## License

Google Sign-In for Rails is released under the [MIT License](https://opensource.org/licenses/MIT).
