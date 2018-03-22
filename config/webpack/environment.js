const { environment } = require('@rails/webpacker')
const erb =  require('./loaders/erb')
const vue =  require('./loaders/vue')

environment.loaders.append('vue', vue)
environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader',
  options: {
    attempts: 1
  }
})
environment.loaders.append('erb', erb)
module.exports = environment
