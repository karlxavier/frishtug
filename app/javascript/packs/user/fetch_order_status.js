let poll_id = null
let pollBtn = document.querySelector('.start-polling')
let stopBtn = document.querySelector('.stop-polling')

pollScanovator = () => {
  Rails.ajax({
    url: '/user/scanovators.js?order_id=<%= @current_order&.id %>',
    type: 'GET',
  });
};


startPolling = () => {
  if (poll_id !== null) { 
    stopPolling()
  }
  poll_id = setInterval(pollScanovator, 10000)
}

stopPolling = () => {
  clearInterval(poll_id)
  poll_id = null
}


if (pollBtn) { pollBtn.addEventListener('click', startPolling) }
if (stopBtn) { stopBtn.addEventListener('click', stopPolling) }