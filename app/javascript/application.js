// // Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

// import "@hotwired/turbo-rails"
// import "controllers"
// import "./adminlte/plugins/jquery/jquery.min.js"
// import "./adminlte/plugins/bootstrap/js/bootstrap.bundle.min.js"
// //import "./adminlte/plugins/sweetalert2/sweetalert2.all.min.js"
// //import "./adminlte/plugins/toastr/toastr.min.js"
// import Swal from 'sweetalert2';
// window.Swal = Swal;
// import "./adminlte/dist/js/adminlte.min.js"


// app/javascript/application.js

import "@hotwired/turbo-rails"
import "controllers"

// Importando os pacotes via Importmap
import "jquery"
import "bootstrap"
import "adminlte"
import "sweetalert2"

// Inicializando o SweetAlert2 globalmente
window.Swal = Swal;
