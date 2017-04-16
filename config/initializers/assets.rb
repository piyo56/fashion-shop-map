# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# precomiling css
css_files = [
  "inquiry/inquiry.scss",
  "shops/map.scss",
  "static_pages/about.scss",
  "static_pages/home.scss",
  "choices.scss",
]
Rails.application.config.assets.precompile += css_files

# precomiling js
Rails.application.config.assets.precompile += %w( html5shiv.js )
Rails.application.config.assets.precompile += %w( choices.js )
Rails.application.config.assets.precompile += %w( infobox_packed.js )
Rails.application.config.assets.precompile += %w( markerclusterer.min.js )
Rails.application.config.assets.precompile += %w( share_buttons.js )
Rails.application.config.assets.precompile += %w( oms.min.js )
