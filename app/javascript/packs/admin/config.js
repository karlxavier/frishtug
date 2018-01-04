import Dropzone from 'dropzone'
Dropzone.autoDiscover = false;

const el = document.querySelector('.dropzone-area')

const assetIds = []

const dropzone = new Dropzone(el, {
  uploadMultiple: false,
  paramName: 'asset[image]',
  acceptedFiles: '.jpg,.png,.jpeg,.gif',
  parallelUploads: 1,
  url: '/admin/assets'
})

dropzone.on('success', function(file, response) {
  const el = document.querySelector('.store_asset_ids')
  const input = document.createElement('input')
  input.type = 'hidden'
  input.value = response.asset_id
  input.name = 'store[asset_ids][]'
  el.appendChild(input)
})
