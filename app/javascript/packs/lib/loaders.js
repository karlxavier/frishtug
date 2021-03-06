const init = (loaderText) => {
  let content = "Loading..."
  if (loaderText) {
    content = String(loaderText)
  }
  const body = document.querySelector("body");
  const overlay = document.createElement('div')
  const loader = document.createElement('div')
  const span = document.createElement('span')
  const text = document.createTextNode(content)
  loader.className = 'pulse_loader'
  overlay.className = 'overlay'
  span.className = 'pulse_loader_text'
  overlay.appendChild(loader)
  span.appendChild(text);
  overlay.appendChild(span)
  body.appendChild(overlay)
}

const stop = () => {
  const overlay = document.querySelector('.overlay')
  overlay.remove()
}

const replace_text = (text) => {
  const el = document.querySelector('.pulse_loader_text')
  el.innerHTML = text
}

module.exports = {
  init: init,
  stop: stop,
  replace_text: replace_text
}