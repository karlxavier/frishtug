import swal from 'sweetalert2'
(function(win){

  const order = {
    plan: null,
    plan_price: null,
    shipping_fee: 0,
    start_date: null,
    schedule: 'monday_to_friday',
    order_type: 'multiple',
    single_order: {
      date: null,
      meal_ids: [],
      meals: [],
      count: 0,
      tax: 0,
    },
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
  
  const mealSelectorHandler = (event) => {
    const el = event.target
    const counter = el.closest('div.col').querySelector('span.meal-counter')
    const previousValue = parseInt(counter.innerHTML)
    const card = el.closest('div.card')
    const mealId = card.dataset.mealId
    const mealName = card.dataset.mealName
    const mealPrice = card.dataset.mealPrice
    const mealImage = card.querySelector('img').src
    const param = el.dataset.fmodel

    if (el.classList.contains('meal-ctrl-btns-plus')) {
      order[param].meal_ids.push(mealId)
      addMeals(
        param, 
        mealName, 
        mealId, 
        mealPrice, 
        mealImage)
      order.total_count += 1
      order.total_price += parseFloat(mealPrice)
      order[param].element = counter
      counter.innerHTML = parseInt(counter.innerHTML) + 1
    } else {
      if (previousValue !== 0) {
        const index = order[param].meal_ids.indexOf(mealId.toString())
        order[param].meal_ids.splice(index, 1)
        removeMeals(
          param, 
          mealName, 
          mealId.toString(), 
          mealPrice.toString(), 
          mealImage
        )
        order.total_count -= 1
        order.total_price -= parseFloat(mealPrice.toString())
        counter.innerHTML = previousValue - 1
      }
    }
    renderOrders()
  }

  const mealSelectorInit = () => {
    const plusBtns = document.querySelectorAll('.meal-ctrl-btns-plus')
    const minusBtns = document.querySelectorAll('.meal-ctrl-btns-minus')

    plusBtns.forEach( btn => {
      btn.addEventListener('click', mealSelectorHandler)
    })

    minusBtns.forEach( btn => {
      btn.addEventListener('click', mealSelectorHandler)
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
  const orderClickHandler = (target, meal, attr, index, type) => {
    return (event) => {
      const card = target.querySelector('.card[data-meal-name="' + meal.name + '"]')
      const counter = card.querySelector('span.meal-counter')
      if (type === 'add') {
        order[attr].meal_ids.push(meal.id)
        order[attr].meals[index].count += 1
        order[attr].meals[index].price += parseFloat(card.getAttribute('data-meal-price'))
        innerHtmlOf(counter, order[attr].meals[index].count)
      } else {
        const mealIndex = order[attr].meal_ids.indexOf(meal.id)
        order[attr].meal_ids.splice(mealIndex, 1)
        if(meal.count > 1) {
          order[attr].meals[index].count -= 1
          order[attr].meals[index].price -= parseFloat(card.getAttribute('data-meal-price'))
          innerHtmlOf(counter, order[attr].meals[index].count)
        } else {
          order[attr].meals.splice(index, 1)
          innerHtmlOf(counter, 0)
        }
      }
      renderOrders()
    }
  }
  
  const renderOrders = () => {
    const template = document.querySelector('#order-template').innerHTML
    const listTemplate = document.querySelector('#order-list-template').innerHTML
    const target = document.querySelector('.order-list')
    target.innerHTML = ''

    if (order.order_type === 'multiple') {
      days.forEach(day => {
        const el = document.createElement('div')
        const order_day = order[day]
        el.className = 'mb-3'
        el.innerHTML = template

        if (order_day.meal_ids.length === 0) {
          return false
        }
        const daysArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        const d = new Date(order_day.date)
        appendTo(el, daysArray[d.getDay()], '.order-title')
        order_day.meals.forEach( (meal, index) => {
          const div = document.createElement('div')
          div.innerHTML = listTemplate
          appendTo(div, meal.name, '.meal-name')
          appendTo(div, toCurrency(meal.price), '.meal-price')
          appendTo(div, meal.count, '.meal-count')

          const target = document.querySelector(`#${day.split('_').join('-')}`)
          div.querySelector('.add-meal')
             .addEventListener('click', orderClickHandler(target, meal, day, index, 'add'))

          div.querySelector('.remove-meal')
             .addEventListener('click', orderClickHandler(target, meal, day, index, 'remove'))

          const tr = div.querySelector('tr')
          appendTo(el, tr, 'tbody')
        })

        const totalPrice = sumOf(getByDayPrices(order_day.meals))
        appendTo(el, toCurrency(totalPrice), '.meal-total')
        appendTo(target, el)
        enableSaveMealPlanBtn()
      })
    } else {
      const el = document.createElement('div')
        const single_order = order.single_order
        el.className = 'mb-3'
        el.innerHTML = template

        if (single_order.meal_ids.length === 0) {
          return false
        }
        single_order.meals.forEach( (meal, index) => {
          const div = document.createElement('div')
          div.innerHTML = listTemplate
          appendTo(div, meal.name, '.meal-name')
          appendTo(div, toCurrency(meal.price), '.meal-price')
          appendTo(div, meal.count, '.meal-count')

          const target = document.querySelector(`#single_order`)
          div.querySelector('.add-meal')
             .addEventListener('click', orderClickHandler(target, meal, 'single_order', index, 'add'))

          div.querySelector('.remove-meal')
             .addEventListener('click', orderClickHandler(target, meal, 'single_order', index, 'remove'))

          const tr = div.querySelector('tr')
          appendTo(el, tr, 'tbody')
        })

        const totalPrice = sumOf(getByDayPrices(single_order.meals))
        appendTo(el, toCurrency(totalPrice), '.meal-total')
        appendTo(target, el)
        enableSaveMealPlanBtn()
    }
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

  const enableSaveMealPlanBtn = () => {
    const btn = document.querySelector('.btn--save-meal-plan')
    let shouldEnable = false

    if (order.order_type !== 'single') {
      const minimum = parseFloat(extract_number(order.plan_price)[0]) / 20
      const totals = []

      const isAllOverOrEqaulMinimun = (item, index, array) => {
        return item >= minimum
      }

      days.forEach(day => {
        const total = sumOf(getByDayPrices(order[day].meals))
        totals.push(total)
      })

      if (totals.every(isAllOverOrEqaulMinimun)){
        shouldEnable = true
      }
    } else {
      shouldEnable = true
    }

    if (shouldEnable) {
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
    let total, amount, plan_price
    const page = document.querySelector('#review_order')
    const schedules = order.schedule === 'sunday_to_thursday'
                    ? 'Sunday - Thursday' : 'Monday - Friday'
    const shipping = order.shipping_fee === 0 ? "Free" : toCurrency(order.shipping_fee)

    innerHtmlOf(page, order.plan, '.choosen_plan')
    innerHtmlOf(page, shipping, '.shipping')

    const populateSched = ({price, text, total, first_delivery}) => {
      innerHtmlOf(page, price, '.price')
      innerHtmlOf(page, text, '.meals__text')
      innerHtmlOf(page, total, '.total_price_summary')
      innerHtmlOf(page, first_delivery, '.first_delivery_date')
    }

    if (order.order_type === 'single') {
      amount = sumOf(getByDayPrices(order.single_order.meals))
      plan_price = parseInt(extract_number(order.plan_price)[0])
      if (plan_price > amount) { amount = plan_price }
      total = amount
      if (order.shipping_fee !== 0) { total = total + parseInt(order.shipping_fee) }
      populateSched({ 
        sched: 'Single Order', 
        price: toCurrency(amount), 
        text: 'Single Order', 
        total: toCurrency(total),
        first_delivery: order.single_order.date
      })
    } else {
      plan_price = parseInt(extract_number(order.plan_price)[0])
      if (order.shipping_fee !== 0) { total = plan_price + parseInt(order.shipping_fee) }
      populateSched({ 
        sched: schedules, 
        price: order.plan_price, 
        text: '5 Meals per week', 
        total: order.plan_price,
        first_delivery: order.day_1.date
      })
    }
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

    if (order.order_type === 'multiple') {
      days.forEach( day => {
        const order_by_day = order[day]
        formData.append('registration_form[orders][][order_date]', order_by_day.date)
        formData.append('registration_form[orders][][menu_ids][]', order_by_day.meal_ids)
      })
    } else {
      formData.append('registration_form[orders][][order_date]', order.single_order.date)
      formData.append('registration_form[orders][][menu_ids][]', order.single_order.meal_ids)
    }
    

    formData.append('registration_form[stripe_token]', token)
    formData.append('registration_form[card_brand]', brand)
    var AUTH_TOKEN = $('meta[name=csrf-token]').attr('content')
    Rails.ajax({
      url: form.action,
      type: 'POST',
      data: formData,
      // processData: false,
      // contentType: false,
      success: (data) => {
        eval(data)
      }
    })
  }

  const extract_number = (alphanumeric) => {
    return alphanumeric.match(/\d+/g)
  }

  planSelectorInit()
  window.completeAction = completeAction
  window.order = order
  window.mealSelectorInit = mealSelectorInit
  window.mealCounterObserver = mealCounterObserver
  window.renderOrders = renderOrders
}(window))
