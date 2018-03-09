import swal from 'sweetalert2';
import pulse_loader from "./lib/loaders";

window.pulse_loader = pulse_loader;
window.swal = swal;


window.onbeforeunload = function() {
  localStorage.clear()
}