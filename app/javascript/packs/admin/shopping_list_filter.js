const el = document.querySelector('.filter_container')
const dateHolder = { date: '' }

const removeActiveClass = () => {
  const els = document.querySelectorAll('.calendar-links')
  els.forEach( el => {
    if (el.dataset.date !== dateHolder.date) {
      el.classList.remove('active')
    }
  })
}

const calendarHandler = (event) => {
  if(event.target.dataset.date) {
    const target = document.querySelector(event.target.dataset.target)
    dateHolder.date = event.target.dataset.date
    event.target.classList.add('active')
    target.href = `/admin/shoppings_lists?date=${dateHolder.date}`
    console.log(dateHolder)
    removeActiveClass()
  }
}

if (el) {
  el.addEventListener('click', calendarHandler)
}
