const el = document.querySelector('.filter_container')
const meals = document.querySelector('#filter-meal-btn')

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
    target.href = `/admin/dashboard?date=${dateHolder.date}`
    removeActiveClass()
  }
}

const updateUrlParameters = (uri, key, value) => {
  // remove the hash part before operating on the uri
  var i = uri.indexOf('#');
  var hash = i === -1 ? ''  : uri.substr(i)
      uri = i === -1 ? uri : uri.substr(0, i)

  const re = new RegExp(`([?&])${key}=.*?(&|$)`, "i")
  const separator = uri.indexOf('?') !== -1 ? "&" : "?"

  if (uri.match(re)) {
    uri = uri.replace(re, `$1${key}=${value}$2`)
  } else {
    uri = `${uri}${separator}${key}=${value}`
  }

  return `${uri}${hash}`
}

const mealHandler = (event) => {
  event.preventDefault()
  const inputs = document.querySelectorAll('[name=menus]')
  const mealIds = []
  Array.from(inputs).forEach( input => {
    const isCheckBox = input.nodeName === 'INPUT' && input.type === 'checkbox'
    if(isCheckBox && input.checked) {
      mealIds.push(input.value)
    }
  })

  if (mealIds.length > 0) {
    const url = window.location.href
    window.location = updateUrlParameters(url, 'meal', mealIds.join(','))
  }
}

if (el) {
  el.addEventListener('click', calendarHandler)
  meals.addEventListener('click', mealHandler)
}
