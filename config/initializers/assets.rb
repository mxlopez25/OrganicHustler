# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.precompile += %w( bootstrap.css )
Rails.application.config.assets.precompile += %w( jquery.min.js )
Rails.application.config.assets.precompile += %w( admin.js )
Rails.application.config.assets.precompile += %w( admin_layout.css )
Rails.application.config.assets.precompile += %w( dropzone.js )
Rails.application.config.assets.precompile += %w( dropzone.css )
Rails.application.config.assets.precompile += %w( bootstrap-tagsinput.js )
Rails.application.config.assets.precompile += %w( bootstrap-tagsinput.css )
Rails.application.config.assets.precompile += %w( style-fc.css )
Rails.application.config.assets.precompile += %w( dragable.min.js )
Rails.application.config.assets.precompile += %w( jquery.jcarousel.js )
Rails.application.config.assets.precompile += %w( magnific-popup/magnific-popup.css )
Rails.application.config.assets.precompile += %w( creative/creative.css )
Rails.application.config.assets.precompile += %w( bootstrap.js )
Rails.application.config.assets.precompile += %w( creative/creative.min.css )

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
