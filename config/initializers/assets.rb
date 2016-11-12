# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# precomiling css
Rails.application.config.assets.precompile += %w( index.scss )
Rails.application.config.assets.precompile += %w( choices.scss )
Rails.application.config.assets.precompile += %w( shops.scss )
Rails.application.config.assets.precompile += %w( inquiry.scss )
Rails.application.config.assets.precompile += %w( about.scss )

# precomiling js
Rails.application.config.assets.precompile += %w( choices.js )
Rails.application.config.assets.precompile += %w( share_buttons.js )
Rails.application.config.assets.precompile += %w( infobox_packed.js )
Rails.application.config.assets.precompile += %w( markerclusterer.min.js )
Rails.application.config.assets.precompile += %w( html5shiv.js )
