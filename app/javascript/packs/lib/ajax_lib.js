// e.g
// post({
//   url: the url for post,
//   data: data to be send,
//   success: handle successful response,
//   error: handle error
// })

const post = (obj) => {
  const request = new XMLHttpRequest()
  const token = document.querySelector('meta[name="csrf-token"]').content

  request.open('POST', obj.url, true)
  request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8')
  request.setRequestHeader('X-CSRF-TOKEN', token)

  request.onload = function() {
    if (request.status >= 200 && request.status < 400) {
      const response = request.responseText;
      obj.success(response)
    } else {
      const response = request.responseText;
      obj.error(response)
    }
  };

  request.send(obj.data)
}

const get = (obj) => {
  const request = new XMLHttpRequest()
  request.open('GET', obj.url, true)

  request.onload = function() {
    if (request.status >= 200 && request.status < 400) {
      const response = request.responseText
      obj.success(response)
    } else {
      const response = request.responseText
      obj.error(response)
    }
  };

  request.onerror = function() {
    console.error('There was a connection error of some sort')
  };

  request.send(obj.data)
}

module.exports = {
  post: post,
  get: get
}