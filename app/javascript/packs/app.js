import swal from 'sweetalert2'
window.swal = swal


window.onbeforeunload = function() {
  localStorage.removeItem('allowed_zip_codes');
  localStorage.removeItem('full_name')
}