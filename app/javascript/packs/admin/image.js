import Dropzone from 'dropzone'

const el = document.querySelector('.dropzone-area')

const dropzone = new Dropzone(el, {
  uploadMultiple: false,
  paramName: 'asset[image]',
  acceptedFiles: '.jpg,.png,.jpeg,.gif',
  parallelUploads: 6,
  url: '#'
})

dropzone.on('success', function(file, response) {
  this.removeFile(file)
  Rails.ajax({
    url: '/admin/assets',
    type: 'GET',
    dataType: 'script'
  })
})
