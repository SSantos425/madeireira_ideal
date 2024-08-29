# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets')

# Add paths for AdminLTE assets
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'adminlte', 'dist', 'css')
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'adminlte', 'dist', 'js')
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'adminlte', 'plugins', 'bootstrap', 'js')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w[adminlte/dist/css/*.css adminlte/dist/js/*.js adminlte/plugins/bootstrap/js/*.js]
