const form = document.querySelector("#invitation_mailer_form");
const submit_btn = form.querySelector(".send_invitation_btn");

submit_btn.addEventListener('click', (e) => {
  e.preventDefault()
  Rails.ajax({
    url: "/user/invitations",
    type: "POST",
    data: new FormData(form),
    success: function(response) {
      swal("success", response.message, "success");
    }
  });
})