const form = document.querySelector("#invitation_mailer_form");
const submit_btn = form.querySelector(".send_invitation_btn");

submit_btn.addEventListener('click', (e) => {
  e.preventDefault()
  Rails.ajax({
    url: "/user/invitations",
    type: "POST",
    data: new FormData(form),
    success: function(response) {
      swal({
        type: "success",
        title: "Invitation",
        text: response.message,
        confirmButtonText: "Ok",
        confirmButtonColor: "#582D11",
        confirmButtonClass: "btn btn-brown text-uppercase",
        buttonsStyling: false
      });
    }
  });
})