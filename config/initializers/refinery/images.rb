# encoding: utf-8
Refinery::Images.configure do |config|
  # Configures the maximum allowed upload size (in bytes) for an image
  # config.max_image_size = 5242880

  # Configure how many images per page should be displayed when a dialog is presented that contains images
  config.pages_per_dialog = 40

  # Configure how many images per page should be displayed when a dialog is presented that
  # contains images and image resize options
  config.pages_per_dialog_that_have_size_options = 32

  # Configure how many images per page should be displayed in the list of images in the admin area
  config.pages_per_admin_index = 40

  # Configure image sizes
  config.user_image_sizes = {:small=>"250x200>", :medium=>"800x600>", :large=>"1200x800>", :portfolio=>"1800x1350>"}

  # Configure white-listed mime types for validation
  # config.whitelisted_mime_types = ["image/jpeg", "image/png", "image/gif", "image/tiff"]

  # Configure image view options
  # config.image_views = [:grid, :list]

  # Configure default image view
  # config.preferred_image_view = :grid

  # Configure S3 (you can also use ENV for this)
  # The s3_backend setting by default defers to the core setting for this but can be set just for images.
  # config.s3_backend = Refinery::Core.s3_backend
  # config.s3_bucket_name = ENV['S3_BUCKET']
  # config.s3_access_key_id = ENV['S3_KEY']
  # config.s3_secret_access_key = ENV['S3_SECRET']
  # config.s3_region = ENV['S3_REGION']

  # Configure Dragonfly
  # This is where in the middleware stack to insert the Dragonfly middleware
  # config.dragonfly_insert_before = "ActionDispatch::Callbacks"
  config.dragonfly_secret = "2ca824ed6ffc56b49f3b0186eff96636904cb6d8bd3e635e"
  # config.dragonfly_url_format = "/system/images/:job/:basename.:ext"
  config.dragonfly_url_host = "http://static.firebellydesign.com"
  # config.datastore_root_path = "/Users/nate/Sites/fb3/public/system/refinery/images"

  # Configure Dragonfly custom storage backend
  # The custom_backend setting by default defers to the core setting for this but can be set just for images.
  # config.custom_backend_class = nil
  # config.custom_backend_opts = {}

end
