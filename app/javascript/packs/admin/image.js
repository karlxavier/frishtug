import Dropzone from 'dropzone'
Dropzone.autoDiscover = false;

const el = document.querySelector('.dropzone-area')
const browseBtn = el.querySelector('.add-file-btn')

const dropzone = new Dropzone(el, {
  previewsContainer: el.querySelector('.preview-image'),
  clickable: true,
  addRemoveLinks: true,
  uploadMultiple: false,
  paramName: 'asset[image]',
  acceptedFiles: '.jpg,.png,.jpeg,.gif',
  parallelUploads: 1,
  url: '#',
  init: function() {
    const self = this
    browseBtn.addEventListener('click', function() {
      self.hiddenFileInput.click()
    })
  }
})

dropzone.on('addedfile', function(file) {
  browseBtn.classList.add('d-none')
})

dropzone.on('queuecomplete', function() {
  browseBtn.classList.remove('d-none')
})

dropzone.on('success', function(file, response) {
  this.removeFile(file)
  Rails.ajax({
    url: '/admin/assets',
    type: 'GET',
    dataType: 'script'
  })
})
