# Yactivestorage

Yactivestorage makes it simple to upload and reference files in cloud services, like Amazon S3 or Google Cloud Storage,
and attach those files to Yactivestorage. It also provides a disk site for testing or local deployments, but the
focus is on cloud storage.


## Examples

One attachment:

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

Many attachements:

```ruby
class Message < ApplicationRecord
  has_many_attached :images
end

<%= form_with model: @message do |form| %>
  <%= form.text_field :title, placeholder: "Title" %><br>
  <%= form.text_field :title, placeholder: "Title" %><br><br>

  <%= form.file_field :images, multiple: true %><br>
  <%= form.submit %>
<% end %>
```

## Installation

1. Add `require yactivestorage`  to config/application.rb
2. Run rails `yactivestorage::install` to create needed directories, migrations, and configuration.
3. Configure the storage services in `config/environements/* with` `config.yactivestorage.service = :local`  that references the services configured in `config/yactivestorage.yml`


## Todos

- Strip Download of its responsibilities and delete class
- Proper logging
- Convert MirrorService to use threading
- Read metadata via Marcel
- Add Migrator to copy/move between services
- Explore direct uploads to cloud
- Extract VerifiedKeyWithExpiration into Rails as feature of MessageVerifier


## License

Yactivestorage is released under the [MIT License](https://opensource.org/licenses/MIT).
