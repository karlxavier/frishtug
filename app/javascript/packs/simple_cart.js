let shoppingCart = []
let currentActiveCart
const listeners = []
const counterListeners = {}

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
    return
  }

  currentActiveCart = shoppingCart[0][option]
}

const setUpShoppingCartForFiveDays = () => {
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

const addToShoppingCart = (el) => {
  const item = parseValue(el.dataset.value)
  item.price = toFloat(item.price)

  const itemInCartIndex = findItemFromShoppingCart(item)
  let quantity = 0

  if (itemInCartIndex >= 0) {
    const cart = currentActiveCart[itemInCartIndex]
    cart.price += item.price
    cart.quantity += item.quantity
    quantity = cart.quantity
  } else {currentActiveCart.push(item)
    quantity = item.quantity
  }
  enableRemoveFromCart(getCounterName(el))
  updateCounterHandler(getCounterName(el), quantity)
  updateListeners()
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
  }

  if (quantity === 0) {
    currentActiveCart.splice(itemInCartIndex, 1)
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
}

const updateCounterHandler = (counterName, quantity) => {
  const counter = document.querySelector(counterListeners[counterName])
  counter.innerHTML = quantity
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

module.exports = {
  shoppingCart: shoppingCart,
  shoppingCartInit: initialize,
  registerShoppingCartListener: registerShoppingCartListener,
  addToShoppingCart: addToShoppingCart,
  removeFromShoppingCart: removeFromShoppingCart
}
