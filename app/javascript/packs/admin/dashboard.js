const el = document.querySelector('.filter_container')
const mealsApplyBtnFilter = document.querySelector('#filter-meal-btn')
const locationsApplyBtnFilter = document.querySelector('#filter-location-btn')
const viewMoreBtn = document.querySelector('.view__more')
let pageCounter = 2

const dateHolder = { date: '' }

const renderMore = (event) => {
  event.preventDefault()
  Rails.ajax({
    url: `/admin/dashboard.js?page=${pageCounter}`,
    type: 'GET'
  })
  pageCounter++
}

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

const locationHandler = (event) => {
  event.preventDefault()
  const inputs = document.querySelectorAll('[name=cities]')
  const cities = []

  Array.from(inputs).forEach( input => {
    const isCheckBox = input.nodeName === 'INPUT' && input.type === 'checkbox'
    if (isCheckBox && input.checked) {
      cities.push(input.value)
    }
  })

  if (cities.length > 0) {
    const url = window.location.href
    window.location = updateUrlParameters(url, 'location', cities.join(','))
  }
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
  mealsApplyBtnFilter.addEventListener('click', mealHandler)
  locationsApplyBtnFilter.addEventListener('click', locationHandler)
  viewMoreBtn.addEventListener('click', renderMore)
}
