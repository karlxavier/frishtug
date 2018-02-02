import swal from 'sweetalert2'
window.swal = swal


window.onbeforeunload = function() {
  localStorage.clear()
}