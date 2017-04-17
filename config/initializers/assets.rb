# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# precomiling css
prefix = "./app/assets/stylesheets/"
css_files = Dir.glob("#{prefix}**/*.scss")
               .map { |file| file.split(prefix).last }
Rails.application.config.assets.precompile += css_files

# precomiling js
prefix = "./app/assets/javascripts/"
js_files = Dir.glob("#{prefix}**/*.js")
              .map { |file| file.split(prefix).last }
Rails.application.config.assets.precompile += js_files
