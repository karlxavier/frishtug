const pulse_loader = () => {
  const body = document.querySelector('body')

  const init = () => {
    const overlay = document.createElement('div')
    const loader = document.createElement('div')
    loader.className = 'pulse_loader'
    overlay.className = 'overlay'
    overlay.appendChild(loader)
    body.appendChild(overlay)
  }

  const stop = () => {
    const overlay = document.querySelector('.overlay')
    overlay.remove()
  }

  return {
    init: init,
    stop: stop
  }
}

module.exports = {
  pulse_loader: pulse_loader()
}