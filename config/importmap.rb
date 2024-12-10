# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
# pin "sweetalert2" # @11.12.2

# config/importmap.rb

# Importando as bibliotecas de CDN
pin "jquery", to: "https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"
pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"
pin "adminlte", to: "https://cdn.jsdelivr.net/npm/admin-lte@3.2.0/dist/js/adminlte.min.js"
pin "sweetalert2", to: "https://cdn.jsdelivr.net/npm/sweetalert2@11.4.25/dist/sweetalert2.all.min.js"
