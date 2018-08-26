# Yactivestorage

...

## Example

```ruby
class User < ApplicationRecord
  has_one_attached :avatar
end

user.avarar.attach io: File.open("~/face.jpg"), filename: "avatar.jpg", content_type: "image/jpg"
user.avatar.exist? # => true

user.avarar.purge
user.avatar.exist? # => false

user.image.url(expires_in: 5.minutes) #=> /rails/blobs/<encoded-key>

def AvatarController < ApplicationController
  def update
    Current.user.avatar.attach(params.require(:avarar))
    redirect_to Current.user
  end
end
```

## License

Yactivestorage is released under the [MIT License](https://opensource.org/licenses/MIT).
