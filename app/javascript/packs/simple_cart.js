// jshint ignore: start

let shoppingCart          = []
let currentActiveCart
const listeners           = []
const counterListeners    = {}

const getCounterName = (el) => {
  const item = parseValue(el.dataset.value)
  const type = el.dataset.controlType
  return `${type}__${item.id}`
}

const subscribeCounterListener = (el) => {
  const counterName = getCounterName(el)
  if (!counterListeners.hasOwnProperty(counterName)) {
    counterListeners[counterName] = el.dataset.controlTarget
    return
  }
}

const registerShoppingCartListener = (obj) => {
  listeners.push(obj)
}

const updateListeners = () => {
  listeners.forEach( listener => {
    listener.cart = shoppingCart
  })
}

const setCurrentActiveCart = (option) => {
  if (option === 'single') {
    currentActiveCart = shoppingCart
  } else  {
    currentActiveCart = shoppingCart[0][option]
  }
}

const setUpShoppingCartForFiveDays = () => {
  shoppingCart = []
  const cartObject = {
    day_1: [],
    day_2: [],
    day_3: [],
    day_4: [],
    day_5: []
  }

  shoppingCart.push(cartObject)
}

const setUpShoppingCartSingle = () => {
  shoppingCart = []
}

const findItemFromShoppingCart = (item) => {
  const findItem = (itemInCart) => {
    return itemInCart.id === item.id
  }

  return currentActiveCart.findIndex(findItem)
}

const parseValue = (value) => JSON.parse(value)

const toFloat = (value) => parseFloat(value)

const hasAddOnsArray = (cart) => {
  if (cart.hasOwnProperty('add_ons')) {
    return true
  } else {
    cart.add_ons = []
    return true
  }
}

const findAddOnFromShoppingCartAddOns = (cart, addOn) => {
  const findAddOn = (addOnInCart) => {
    return addOnInCart.id === addOn.id
  }

  return cart.add_ons.findIndex(findAddOn)
}

const pushAddOn = (cart, addOn, el) => {
  const hasAddOn = findAddOnFromShoppingCartAddOns(cart, addOn)
  if (hasAddOn <= -1) {
    cart.add_ons.push(addOn)
  }

  if (el.checked === false) {
    cart.add_ons = cart.add_ons.filter( add_on => add_on.id !== addOn.id )
  }
}

const toggleAddOns = (el) => {
  const addOn = parseValue(el.dataset.value)
  const targetMenu = el.dataset.addOnFor
  const item = { id: parseInt(targetMenu) }
  const itemInCartIndex = findItemFromShoppingCart(item)

  if (itemInCartIndex >= 0) {
    const cart = currentActiveCart[itemInCartIndex]
    pushAddOn(cart, addOn, el)
  }
}

const addToShoppingCart = (el) => {
  const item = parseValue(el.dataset.value)
  item.price = toFloat(item.price)

  const itemInCartIndex = findItemFromShoppingCart(item)
  let quantity = 0

  if (itemInCartIndex >= 0) {
    const cart = currentActiveCart[itemInCartIndex]
    const total_cart_quantity = parseInt(localStorage.getItem(item.id)) + 1
    checkInventory(item.id, total_cart_quantity, function(response) {
      if (response.status === 'success') {
        cart.price += item.price
        cart.quantity += item.quantity
        localStorage.setItem(item.id, total_cart_quantity)
        enableRemoveFromCart(getCounterName(el))
        updateCounterHandler(getCounterName(el), cart.quantity)
        updateListeners()
      } else {
        outOfStockHandler(response)
      }
    })
  } else {
    let quantity_to_send = item.quantity
    const hasItemStored = localStorage.getItem(item.id)
    if (hasItemStored) {
      quantity_to_send = parseInt(hasItemStored) + 1
    }

    checkInventory(item.id, quantity_to_send, function(response) {
      if(response.status === 'success') {
        currentActiveCart.push(item)
        enableRemoveFromCart(getCounterName(el))
        updateCounterHandler(getCounterName(el), item.quantity)
        updateListeners()
        localStorage.setItem(item.id, item.quantity)
      } else {
        outOfStockHandler(response)
      }
    })
  }
}

const removeFromShoppingCart = (el) => {
  const item = parseValue(el.dataset.value)
  item.price = toFloat(item.price)

  const itemInCartIndex = findItemFromShoppingCart(item)
  let quantity = 0

  if (itemInCartIndex >= 0) {
    const cart = currentActiveCart[itemInCartIndex]
    cart.price -= item.price
    cart.quantity -= item.quantity
    quantity = cart.quantity
    localStorage.setItem(item.id, cart.quantity)
  }

  if (quantity === 0) {
    currentActiveCart.splice(itemInCartIndex, 1)
    localStorage.removeItem(item.id)
    disableRemoveFromCart(getCounterName(el))
  }
  updateCounterHandler(getCounterName(el), quantity)
  updateListeners()
}

const shoppingCartHandler = (el) => {
  if (el.dataset.controlType) {
    setCurrentActiveCart(el.dataset.controlType)
    subscribeCounterListener(el)
  }

  if (el.dataset.control === 'remove') {
    removeFromShoppingCart(el)
  }

  if (el.dataset.control === 'add') {
      addToShoppingCart(el)
  }

  if (el.dataset.type === 'add_ons') {
    toggleAddOns(el)
  }
}

const enableOrDisableAddOns = (counter_name, quantity) => {
  const addOns = document.querySelector(`${counter_name}__add_ons`)
  if (addOns && quantity > 0) {
    addOns.classList.remove('d-none')
    return
  } else {
    addOns.classList.add('d-none')
    return
  }
}

const updateCounterHandler = (counterName, quantity) => {
  const counter = document.querySelector(counterListeners[counterName])
  counter.innerHTML = quantity
  enableOrDisableAddOns(counterListeners[counterName], quantity)
}

const getRemoveBtn = (counterName) => {
  const el = document.querySelector(counterListeners[counterName])
  const controlContainer = el.closest('.cart-controls')
  return controlContainer.querySelector('.cart-controls__remove')
}

const enableRemoveFromCart = (counterName) => {
  const removeBtn = getRemoveBtn(counterName)
  removeBtn.classList.remove('disabled')
}

const disableRemoveFromCart = (counterName) => {
  const removeBtn = getRemoveBtn(counterName)
  removeBtn.classList.add('disabled')
}

const saveToSessionStore = (name, itemTosave) => {
  sessionStorage.setItem(name, item)
}


const eventDelegator = (e) => {
  shoppingCartHandler(e.target)
}

const initialize = () => {
  const el = document.querySelector('.menu-item__container')
  const elFiveDays = document.querySelector('.menu-items__container_for_five_days')
  const cartSummary = document.querySelector('.menu-items__cart_summary')

  if (el) {
    setUpShoppingCartSingle()
    el.addEventListener('click', eventDelegator)
  }

  if (elFiveDays) {
    setUpShoppingCartForFiveDays()
    elFiveDays.addEventListener('click', eventDelegator)
  }
}

const checkInventory = (id, quantity, callback) => {
  Rails.ajax({
    url: `/inventories?menu_id=${id}&quantity=${quantity}`,
    type: 'GET',
    success: callback,
    error: callback
  })
}

const outOfStockHandler = (response) => {
  swal(response.status, response.message, response.status)
}

module.exports = {
  shoppingCart: shoppingCart,
  shoppingCartInit: initialize,
  registerShoppingCartListener: registerShoppingCartListener,
  addToShoppingCart: shoppingCartHandler,
  removeFromShoppingCart: shoppingCartHandler
}
