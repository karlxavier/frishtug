import swal from 'sweetalert2'
(function(win){

  const order = {
    plan: null,
    plan_price: null,
    shipping_fee: 0,
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

  if (!scheduleTypeLabels) {
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

  const setTabsSchedule = (schedule) => {
    order.schedule = schedule
    const mondayToFriday = ["monday", "tuesday", "wednesday", "thursday", "friday"]
    const sundayToThursday = ["sunday", "monday", "tuesday", "wednesday", "thursday"]
    const mealSelectionTabs = document.querySelector('.nav-tabs-wrapper')
    if (mealSelectionTabs) {
      const tabs = mealSelectionTabs.querySelectorAll('li.tab')
      let schedules = mondayToFriday

      if (schedule === 'sunday_to_thursday') {
        schedules = sundayToThursday
      }

      schedules.forEach( (schedule, index) => {
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
        const day = card.closest('div.tab_pane').id.split('-').join('_')
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
          const day = card.closest('div.tab_pane').id.split('-').join('_')
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

  const days = [1,2,3,4,5].map( n => { return `day_${n}` })
  const renderOrders = () => {
    const template = document.querySelector('#order-template').innerHTML
    const listTemplate = document.querySelector('#order-list-template').innerHTML
    const target = document.querySelector('.order-list')
    target.innerHTML = ''

    days.forEach(day => {
      const el = document.createElement('div')
      const order_day = order[day]
      el.className = 'mb-3'
      el.innerHTML = template

      if (order_day.meal_ids.length === 0) {
        return false
      }

      appendTo(el, order_day.day.toUpperCase(), '.order-title')
      order_day.meals.forEach( (meal, index) => {
        const div = document.createElement('div')
        div.innerHTML = listTemplate
        appendTo(div, meal.name, '.meal-name')
        appendTo(div, toCurrency(meal.price), '.meal-price')
        appendTo(div, meal.count, '.meal-count')

        div.querySelector('.add-meal').addEventListener('click', () => {
          const target = document.querySelector(`#${day.split('_').join('-')}`)
          const card = target.querySelector('.card[data-meal-name="' + meal.name + '"]')
          const counter = card.querySelector(order[day].element)
          order[day].meal_ids.push(meal.id)
          order[day].meals[index].count += 1
          order[day].meals[index].price += parseFloat(card.getAttribute('data-meal-price'))
          innerHtmlOf(counter, order[day].meals[index].count)
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
            innerHtmlOf(counter, order[day].meals[index].count)
          } else {
            order[day].meals.splice(index, 1)
            innerHtmlOf(counter, 0)
          }
          renderOrders()
        })

        const tr = div.querySelector('tr')
        appendTo(el, tr, 'tbody')
      })

      const totalPrice = sumOf(getByDayPrices(order_day.meals))
      appendTo(el, toCurrency(totalPrice), '.meal-total')
      appendTo(target, el)
      enableSaveMealPlanBtn(order_day.meals)
    })
  }

  const createTextNode = (text) => {
    return document.createTextNode(text)
  }

  const appendTo = (el, textOrElement, classOrId) => {
    if (classOrId) {
      el = el.querySelector(classOrId)
    }

    if (typeof textOrElement === 'string'
        || typeof textOrElement === 'number') {
      textOrElement = createTextNode(textOrElement)
      el.appendChild(textOrElement)
    } else if (typeof textOrElement === 'object') {
      el.appendChild(textOrElement)
    }
  }

  const innerHtmlOf = (el, text, classOrId) => {
    if (classOrId) {
      el = el.querySelector(classOrId)
    }

    el.innerHTML = text
  }

  const getByDayPrices = (orders) => {
    return orders.map( n => {
      return n.price
    })
  }

  const sumOf = (prices) => {
    return prices.reduce( (sum, n) => {
      return sum + parseFloat(n)
    }, 0)
  }

  const enableSaveMealPlanBtn = (meals) => {
    const btn = document.querySelector('.btn--save-meal-plan')
    const total = sumOf(getByDayPrices(meals))
    if (total >= 10) {
      btn.classList.remove('disabled')
      populateReviewPage()
    } else {
      btn.classList.remove('disabled')
      btn.classList.add('disabled')
    }
  }

  const toCurrency = (number) => {
    return parseFloat(number).toLocaleString('en-US', {
      style: 'currency',
      currency: 'USD'
    })
  }


  const populateReviewPage = () => {
    const page = document.querySelector('#review_order')
    const schedules = order.schedule === 'sunday_to_thursday'
                    ? 'Sunday - Thursday' : 'Monday - Friday'
    const shipping = order.shipping_fee === 0 ? "Free" : toCurrency(order.shipping_fee)
    innerHtmlOf(page, order.plan, '.choosen_plan')
    innerHtmlOf(page, order.plan_price, '.price')
    innerHtmlOf(page, shipping, '.shipping')
    innerHtmlOf(page, schedules, '.delivery_schedule')
    innerHtmlOf(page, order.day_1.date, '.first_delivery_date')
  }

  const planSelectorInit = () => {
    const labels = document.querySelectorAll('.plan--btns')
    labels.forEach( label => {
      const radio = label.querySelector('input')
      radio.addEventListener('click', () => {
        const card = label.closest('.card')
        order.plan_price = toCurrency(card.dataset.planPrice)
        order.plan = card.dataset.planName
        order.shipping_fee = parseFloat(card.dataset.planShippingFee)
      })
    })
  }

  const completeAction = (token, brand) => {
    const form = document.querySelector('form#sign_up_form')
    const formData = new FormData(form)
    const ordersData = []

    days.forEach( day => {
      const order_by_day = order[day]
      formData.append('registration_form[orders][][order_date]', order_by_day.date)
      formData.append('registration_form[orders][][menu_ids][]', order_by_day.meal_ids)
    })

    formData.append('registration_form[stripe_token]', token)
    formData.append('registration_form[card_brand]', brand)
    var AUTH_TOKEN = $('meta[name=csrf-token]').attr('content')
    $.ajax({
      url: form.action,
      type: 'POST',
      headers: {
        'X_CSRF_TOKEN': AUTH_TOKEN
      },
      data: formData,
      processData: false,
      contentType: false,
      success: (data) => {
        eval(data)
      }
    })
  }

  planSelectorInit()
  scheduleSelecter()
  cvcInputControl()
  //paymentMethods()
  //addBillingInfo()
  mealSelectorInit()
  mealCounterObserver()
  window.setTabsSchedule = setTabsSchedule
  window.completeAction = completeAction
  window.order = order
}(window))
