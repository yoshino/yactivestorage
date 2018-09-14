# Yactivestorage

Yactivestorage makes it simple to upload and reference files in cloud services, like Amazon S3 or Google Cloud Storage,
and attach those files to Yactivestorage. It also provides a disk site for testing or local deployments, but the
focus is on cloud storage.

## Compared to other storage solutions
 A key difference to how Active Storage works compared to other attachment solutions in Rails is through the use of built-in `Blob` and `Attachment` models (backed by Active Record). This means existing application models do not need to be modified with additional columns to associate with files. Active Storage uses GlobalID to provide polymorphic associations via the join model of `Attachment`, which then connects to the actual `Blob`.
 These `Blob` models are intended to be immutable in spirit. One file, one blob. You can associate the same blob with multiple application models as well. And if you want to do transformations of a given `Blob`, the idea is that you'll simply create a new one, rather than attempt to mutate the existing (though of course you can delete that later if you don't need it).

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
```

```erb
<%= form_with model: @message do |form| %>
  <%= form.text_field :title, placeholder: "Title" %><br>
  <%= form.text_field :title, placeholder: "Title" %><br><br>

  <%= form.file_field :images, multiple: true %><br>
  <%= form.submit %>
<% end %>
```

```ruby
class MessagesController < ApplicationController
  def create
    message = Message.create! params.require(:message).permit(:title, :content)
    message.images.attach(params[:message][:images])
    redirect_to message
  end
end
```

## Installation

1. Add `require yactivestorage`  to config/application.rb, after `require "rails/all"` line.
2. Run rails `yactivestorage::install` to create needed directories, migrations, and configuration.
3. Configure the storage services in `config/environements/* with` `config.yactivestorage.service = :local`  that references the services configured in `config/yactivestorage.yml`


## Todos

- Document all the classes
- Strip Download of its responsibilities and delete class
- Proper logging
- Convert MirrorService to use threading
- Read metadata via Marcel
- Add Migrator to copy/move between services
- Explore direct uploads to cloud
- Extract VerifiedKeyWithExpiration into Rails as feature of MessageVerifier


## License

Yactivestorage is released under the [MIT License](https://opensource.org/licenses/MIT).
