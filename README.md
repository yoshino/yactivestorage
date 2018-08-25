# Yactivestorage

...

## Example

```ruby
class Person < ApplicationRecord
  has_file :avatar
end

avatar.image_url(expires_in: 5.minuites)

class AvatarsController < ApplicationController
  def create
    # @avatar = Avatar.create \
    #   image: Yactivestorage::Blob.save!(file_name: params.require(:name), content_type, request.content_type, data: request.body)
    @avatar = Avatar.create! image: Avatar.image.extract_from(request)
  end
end

def ProfilesController < ApplicationController
  def update
    @person.update! avatar: @person.avatar.update!(:image )
  end
end
```

## License

Yactivestorage is released under the [MIT License](https://opensource.org/licenses/MIT).
