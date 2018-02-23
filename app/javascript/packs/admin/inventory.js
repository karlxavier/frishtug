const el = document.querySelector('.filter__inventory')
const btn = document.querySelector("#filter-date-btn");
const dates = []

const removeActiveClass = () => {
  const els = document.querySelectorAll(".calendar-links")
  els.forEach(el => {
    if (!dates.includes(el.dataset.date)) {
      el.classList.remove("active")
    }
  })
}

const clearDates = () => {
  if (dates.length >= 2) {
    dates.splice(0, dates.length)
  }
}

const calendarHandler = event => {
  if (event.target.dataset.date) {
    clearDates()
    dates.push(event.target.dataset.date)
    event.target.classList.add("active")
    removeActiveClass()
  }
}

const applyFilter = (event) => {
  event.preventDefault()
  const url = `${event.target.href}?start_date=${dates[0]}&end_date=${dates[1]}`
  window.location = url
}

if (el) {
  el.addEventListener('click', calendarHandler)
  btn.addEventListener('click', applyFilter)
}