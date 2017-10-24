(function(win){

  const scheduleTypeLabels = document.querySelectorAll('div.schedule-types label')
  const scheduleSelecter = () => {
    const labels = document.querySelectorAll('div.days-schedule label')
    if (labels) {
      labels.forEach( label => {
        label.addEventListener('click', (e) => {
          const activeLabel = document.querySelector('div.days-schedule label.active')
          if (activeLabel) { activeLabel.classList.remove('active') }
          label.classList.add('active')
        })
      })
    }
  }

  if (scheduleTypeLabels) {
    scheduleTypeLabels.forEach( label => {
      const radio = label.querySelector('input')
      label.addEventListener('click', (e) => {
        const activeLabel = document.querySelector('div.schedule-types label.btn-brown')
        if (activeLabel) { activeLabel.classList.remove('btn-brown') }
        label.classList.add('btn-brown')
      })

      radio.addEventListener('click', () => {
        $.ajax({
          url: `/user_registrations/schedule.js?type=${radio.value}`,
          type: 'GET',
          dataType: 'script',
          success: function() {
            scheduleSelecter()
          }
        })
      })
    })
  }
  scheduleSelecter()
}(window))