// e.g
// post({
//   url: the url for post,
//   data: data to be send,
//   success: handle successful response,
//   error: handle error
// })
const putJson = (obj) => {
  return new Promise((resolve, reject) => {
    const request = new XMLHttpRequest()
    const token = document.querySelector('meta[name="csrf-token"]').content

    request.open('PUT', obj.url, true)
    //request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8')
    request.setRequestHeader('Content-Type', 'application/json')
    request.setRequestHeader('X-CSRF-TOKEN', token)

    request.onload = function() {
      if (request.status >= 200 && request.status < 400) {
        const response = request.responseText;
        if (obj.hasOwnProperty('success')) {
          obj.success(response)
        }
        resolve(response)
      } else {
        const response = request.responseText;
        if (obj.hasOwnProperty('error')) {
          obj.error(response)
        }
        reject(response)
      }
    };

    request.send( JSON.stringify(obj.data) )
  })
}

const postJson = (obj) => {
  return new Promise((resolve, reject) => {
    const request = new XMLHttpRequest()
    const token = document.querySelector('meta[name="csrf-token"]').content

    request.open('POST', obj.url, true)
    //request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8')
    request.setRequestHeader('Content-Type', 'application/json')
    request.setRequestHeader('X-CSRF-TOKEN', token)

    request.onload = function() {
      if (request.status >= 200 && request.status < 400) {
        const response = request.responseText;
        if (obj.hasOwnProperty('success')) {
          obj.success(response)
        }
        resolve(response)
      } else {
        const response = request.responseText;
        if (obj.hasOwnProperty('error')) {
          obj.error(response)
        }
        reject(response)
      }
    };

    request.send( JSON.stringify(obj.data) )
  })
}

const get = (obj) => {
  return new Promise((resolve, reject) => {
    const request = new XMLHttpRequest()
    request.open('GET', obj.url, true)

    request.onload = function() {
      if (request.status >= 200 && request.status < 400) {
        const response = request.responseText
        obj.success(response)
        resolve(response)
      } else {
        const response = request.responseText
        obj.error(response)
        reject(response)
      }
    };

    request.onerror = function() {
      console.error('There was a connection error of some sort')
      reject('There was a connection error of some sort')
    };

    request.send()
  })
}

const postForm = (obj) => {
  return new Promise((resolve, reject) => {
    const request = new XMLHttpRequest()
    const token = document.querySelector('meta[name="csrf-token"]').content

    request.open('POST', obj.url, true)
    request.setRequestHeader('X-CSRF-TOKEN', token)

    request.onload = function() {
      if (request.status >= 200 && request.status < 400) {
        const response = request.responseText;
        resolve(response)
        if (obj.hasOwnProperty('success')) {
          obj.success(response)
        }
      } else {
        const response = request.responseText;
        reject(response)
        if (obj.hasOwnProperty('error')) {
          obj.error(response)
        }
      }
    };

    request.send(obj.data)
  })
}

const serializeForm = (element, additionalParams) => {
  let inputs = [element]
  let params = []

  if (typeof element === 'object' && element.nodeName === 'FORM') {
    inputs = Array.from(element.elements)
  }

  inputs.forEach( input => {
    if (!input.name) {
      return
    }

    if (input.nodeName === 'SELECT') {
      return Array.from(input.options).forEach(option => {
        if (option.selected) {
          return params.push({
            name: input.name,
            value: option.value
          })
        }
      })
    } else if (input.checked || ['radio', 'checkbox', 'submit'].indexOf(input.type) === -1) {
      return params.push({
        name: input.name,
        value: input.value
      })
    }
  })

  if (additionalParams) {
    params.push(additionalParams)
  }

  return params.map( param => {
    if (param.name !== null) {
      return (encodeURIComponent(param.name)) + '=' + (encodeURIComponent(param.value))
    } else {
      return param
    }
  }).join('&')
}
module.exports = {
  postJson: postJson,
  get: get,
  postForm: postForm,
  putJson: putJson,
  serializeForm: serializeForm
}