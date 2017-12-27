( global => {
  const aTagsForDisabling = document.querySelectorAll('a[data-disable-with]')

  const getTarget = (el) => {
    if (el.tagName !== 'A') {
      return el.closest('a')
    } else {
      return el
    }
  }

  const changeContent = (el) => {
    const temp = el.innerHTML
    el.innerHTML = el.dataset.disableWith
    el.dataset.disableWith = temp
  }

  const disableBtnHandler = (event) => {
    event.preventDefault();
    let target = getTarget(event.target)

    if (target) {
      changeContent(target)
    }

    if (target.dataset.remote) {
      Rails.ajax({
        url: target.href,
        type: 'GET',
        success: () => {
          changeContent(target)
        }
      })
    }
  }

  if (aTagsForDisabling) {
    aTagsForDisabling.forEach( a => {
      a.addEventListener('click', disableBtnHandler)
    })
  }
})(window)
