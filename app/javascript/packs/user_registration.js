(function(win){

  const order = {
    start_date: null,
    schedule: 'monday_to_friday',
    day_1: {
      date: null,
      meal_ids: [],
      meals: [],
      count: 0,
      tax: 0,
      day: "monday"
    },
    day_2: {
      date: null,
      meal_ids: [],
      meals: [],
      count: 0,
      tax: 0,
      day: "tuesday"
    },
    day_3: {
      date: null,
      meal_ids: [],
      meals: [],
      count: 0,
      tax: 0,
      day: "wednesday"
    },
    day_4: {
      date: null,
      meal_ids: [],
      meals: [],
      count: 0,
      tax: 0,
      day: "thursday"
    },
    day_5: {
      date: null,
      meal_ids: [],
      meals: [],
      count: 0,
      tax: 0,
      day: "friday"
    },
    total_count: 0,
    total_tax: 0,
    total_price: 0,
    total_price_currency: function() {
      return this.total_price.toLocaleString('en-US', {
        style: 'currency',
        currency: 'USD'
      })
    },
    total_tax_currency: function() {
      return this.total_tax.toLocaleString('en-US', {
        style: 'currency',
        currency: 'USD'
      })
    }
  }

  const scheduleTypeLabels = document.querySelectorAll('div.schedule-types label')
  const scheduleSelecter = () => {
    const labels = document.querySelectorAll('div.days-schedule label')
    if (labels) {
      labels.forEach( label => {
        const radio = label.querySelector('input[type="radio"]')

        const setOrderDays = () => {
          const days = label.dataset.scheduleDays.split(',')
          if (days) {
            days.forEach( (day, index) => {
              order[`day_${index + 1}`].date = day
            })
          }
        }

        if(label.classList.contains('active')) {
          order.start_date = radio.value
          setOrderDays()
        }

        radio.addEventListener('click', (e) => {
          const activeLabel = document.querySelector('div.days-schedule label.active')
          if (activeLabel) { activeLabel.classList.remove('active') }
          label.classList.add('active')
          order.start_date = radio.value
          setOrderDays()
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
        order.schedule = radio.value
        $.ajax({
          url: `/user_registrations/schedule.js?type=${order.schedule}`,
          type: 'GET',
          dataType: 'script',
          success: function() {
            scheduleSelecter()
            if (order.schedule === "sunday_to_thursday") {
              const sundayToThursday = ["sunday", "monday", "tuesday", "wednesday", "thursday"]
              setTabsSchedule(sundayToThursday)
            } else {
              const mondayToFriday = ["monday", "tuesday", "wednesday", "thursday", "friday"]
              setTabsSchedule(mondayToFriday)
            }
          }
        })
      })
    })
  }

  const setTabsSchedule = (schedules) => {
    const mealSelectionTabs = document.querySelector('#meal-selection-tab')
    if (mealSelectionTabs) {
      const tabs = mealSelectionTabs.querySelectorAll('li.nav-item')
      schedules.forEach( (schedule, index) => {
        const a = tabs[index].querySelector('a')
        const targetTab = document.querySelector(`#${a.getAttribute('aria-controls')}`)
        a.innerHTML = schedule.toUpperCase()
        targetTab.setAttribute('data-meal-schedule', schedule)
        order[`day_${index + 1}`].day = schedule
      })
    }
  }

  const cvcInputControl = () => {
    const cvcInput = document.querySelector('input.cvc-input-control')
    if (cvcInput) {
      cvcInput.addEventListener('input', () => {
        if (cvcInput.value.length > 4) { cvcInput.value = cvcInput.value.slice(0, 4) }
      })
    }
  }

  const paymentMethods = () => {
    const container = document.querySelector('div.payment-method-options')
    const radios = container.querySelectorAll('input[type="radio"]')
    radios.forEach( radio => {
      radio.addEventListener('click', () => {
        $.ajax({
          url: `/user_registrations/payment_method.js?type=${radio.value}`,
          type: 'GET',
          dataType: 'script',
          success: function() {
            if (radio.value === 'credit_card') {
              cvcInputControl()
              addBillingInfo()
            }
          }
        })
      })
    })
  }

  const addBillingInfo = () => {
    const billingCheckbox = document.querySelector('input#registration_form_different_billing')
    if (billingCheckbox) {
      billingCheckbox.addEventListener('click', () => {
        const billingContainer = document.querySelector('div.different-billing')
        if (billingContainer) {
          billingContainer.classList.toggle('d-none')
        }
      })
    }
  }

  const addMeals = (day, name, id, price, image) => {
    const hasName = (array) => {
      return array.name === name
    }
    const isPresent = order[day].meals.filter(hasName)
    if (isPresent.length <= 0) {
      order[day].meals.push({
        name: name,
        id: id,
        price: parseFloat(price),
        image: image,
        count: 1
      })
    } else {
      order[day].meals.forEach(meal => {
        if (meal.name === name) {
          meal.price += parseFloat(price)
          meal.count += 1
        }
      })
    }
  }

  const removeMeals = (day, name, id, price, image) => {
    const hasName = (array) => {
      return array.name === name
    }

    const removeMeal = (array) => {
      return array.name !== name
    }

    const meal = order[day].meals.filter(hasName)
    if (meal[0].count === 1) {
      order[day].meals = order[day].meals.filter(removeMeal)
    } else {
      order[day].meals.forEach(meal => {
        if (meal.name === name) {
          meal.price -= parseFloat(price)
          meal.count -= 1
        }
      })
    }
  }

  const mealSelectorInit = () => {
    const plusBtns = document.querySelectorAll('.meal-ctrl-btns-plus')
    const minusBtns = document.querySelectorAll('.meal-ctrl-btns-minus')
    plusBtns.forEach( btn => {
      btn.addEventListener('click', () => {
        const counter = btn.closest('div.col').querySelector('span.meal-counter')
        const card = btn.closest('div.card')
        const mealId = card.dataset.mealId
        const mealName = card.dataset.mealName
        const mealPrice = card.dataset.mealPrice
        const mealImage = card.querySelector('img').src
        const day = card.closest('div.tab-pane').id.split('-').join('_')
        order[day].meal_ids.push(mealId)
        addMeals(day, mealName, mealId, mealPrice, mealImage)
        order.total_count += 1
        order.total_price += parseFloat(mealPrice)
        order[day].element = counter
        counter.innerHTML = parseInt(counter.innerHTML) + 1
        renderOrders()
      })
    })

    minusBtns.forEach( btn => {
      btn.addEventListener('click', () => {
        const counter = btn.closest('div.col').querySelector('span.meal-counter')
        const previousValue = parseInt(counter.innerHTML)
        if (previousValue !== 0) {
          const card = btn.closest('div.card')
          const mealId = card.dataset.mealId.toString()
          const mealName = card.dataset.mealName
          const mealPrice = card.dataset.mealPrice.toString()
          const mealImage = card.querySelector('img').src
          const day = card.closest('div.tab-pane').id.split('-').join('_')
          const index = order[day].meal_ids.indexOf(mealId)
          order[day].meal_ids.splice(index, 1)
          removeMeals(day, mealName, mealId, mealPrice, mealImage)
          order.total_count -= 1
          order.total_price -= parseFloat(mealPrice)
          counter.innerHTML = previousValue - 1
          renderOrders()
        }
      })
    })
  }

  const mealCounterObserver = () => {
    const mealCounters = document.querySelectorAll('span.meal-counter')
    if (!mealCounters) { return false }

    mealCounters.forEach( mealCounter => {
      const targetToChange = mealCounter.closest('div.col').querySelector('.meal-ctrl-btns-minus')
      const obsrv = new MutationObserver((mutations) => {
        const parsedVal = parseInt(mealCounter.innerHTML)
        if (parsedVal !== 0) {
          targetToChange.classList.remove('disabled')
        } else {
          targetToChange.classList.add('disabled')
        }
      })

      const config = { childList: true }

      obsrv.observe(mealCounter, config)
    })
  }

  const renderOrders = () => {
    const days = [1,2,3,4,5].map( n => { return `day_${n}` })
    const template = document.querySelector('#order-template').innerHTML
    const listTemplate = document.querySelector('#order-list-template').innerHTML
    const target = document.querySelector('.order-list')
    target.innerHTML = ''

    const printText = (text) => {
      return document.createTextNode(text)
    }

    days.forEach(day => {
      const el = document.createElement('div')
      const order_day = order[day]
      el.innerHTML = template

      if (order_day.meal_ids.length === 0) {
        return false
      }

      el.querySelector('.order-title').appendChild(printText(order_day.day.toUpperCase()))
      order_day.meals.forEach( (meal, index) => {
        const div = document.createElement('div')
        div.innerHTML = listTemplate
        div.querySelector('.meal-name').appendChild(printText(meal.name))
        div.querySelector('.meal-price').appendChild(printText(toCurrency(meal.price)))
        div.querySelector('.meal-count').appendChild(printText(meal.count))

        div.querySelector('.add-meal').addEventListener('click', () => {
          const target = document.querySelector(`#${day.split('_').join('-')}`)
          const card = target.querySelector('.card[data-meal-name="' + meal.name + '"]')
          const counter = card.querySelector(order[day].element)
          order[day].meal_ids.push(meal.id)
          order[day].meals[index].count += 1
          order[day].meals[index].price += parseFloat(card.getAttribute('data-meal-price'))
          counter.innerHTML = order[day].meals[index].count
          renderOrders()
        })

        div.querySelector('.remove-meal').addEventListener('click', () => {
          const target = document.querySelector(`#${day.split('_').join('-')}`)
          const card = target.querySelector('.card[data-meal-name="' + meal.name + '"]')
          const counter = card.querySelector('span.meal-counter')
          mealIndex = order[day].meal_ids.indexOf(order[day].meals[index].id)
          order[day].meal_ids.splice(mealIndex, 1)
          if(meal.count > 1) {
            order[day].meals[index].count -= 1
            order[day].meals[index].price -= parseFloat(card.getAttribute('data-meal-price'))
            counter.innerHTML = order[day].meals[index].count
          } else {
            order[day].meals.splice(index, 1)
            counter.innerHTML = 0
          }
          renderOrders()
        })

        const tr = div.querySelector('tr')
        el.querySelector('tbody').appendChild(tr)
      })

      const totalPrice = order_day.meals.reduce( (sum, n) => { return sum + parseFloat(n.price) }, 0)
      el.querySelector('.meal-total').appendChild(printText(toCurrency(totalPrice)))
      target.appendChild(el)
    })
  }

  const toCurrency = (number) => {
    return parseFloat(number).toLocaleString('en-US', {
      style: 'currency',
      currency: 'USD'
    })
  }

  scheduleSelecter()
  cvcInputControl()
  paymentMethods()
  addBillingInfo()
  mealSelectorInit()
  mealCounterObserver()
  window.order = order
  window.renderOrders = renderOrders
}(window))