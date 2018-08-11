const five_minutes = 1000 * 60 * 5;

toastr.options = {
  "closeButton": true,
  "debug": false,
  "newestOnTop": true,
  "progressBar": true,
  "positionClass": "toast-top-right",
  "preventDuplicates": true,
  "onclick": null,
  "showDuration": "300",
  "hideDuration": "1000",
  "timeOut": "20000",
  "extendedTimeOut": "1000",
  "showEasing": "swing",
  "hideEasing": "linear",
  "showMethod": "fadeIn",
  "hideMethod": "fadeOut"
}

const stockNotification = () => {
  Rails.ajax({
    url: '/admin/stock_notifications',
    type: 'GET',
    success: function (payload) {
      if (payload.success) {
        toastr["warning"](`Stock quantity is below 5 for items ${payload.response.map(a=> a.name).join(', ')}`, 'Stocks Warning');
      }
    }
  })
}

window.stockNotification = stockNotification;