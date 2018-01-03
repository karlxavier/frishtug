import Dropzone from 'dropzone'

document.addEventListener('DOMContentLoaded', ()=>{
  (function(win) {

    const initDropzone = () => {
      const publishBtn = document.querySelector('.publish-btn')
      const draftBtn = document.querySelector('.draft-btn')
      const dropzone = new Dropzone(document.querySelector('.dropzone-area'), {
        uploadMultiple: false,
        paramName: 'asset[image]',
        acceptedFiles: '.jpg,.png,.jpeg,.gif',
        parallelUploads: 6,
        maxFiles: 1,
        url: '/admin/assets'
      })

      const disableBtns = () => {
        publishBtn.classList.add('disabled')
        draftBtn.classList.add('disabled')
      }

      const enableBtns = () => {
        publishBtn.classList.remove('disabled')
        draftBtn.classList.remove('disabled')
      }

      dropzone.on('addedfile', function(file) {
        disableBtns()
      })

      dropzone.on('success', function(file, response) {
        const target = document.querySelector('input.asset_id')
        target.value = response.asset_id
        enableBtns()
      })
    }

    const addInverseClass = ({el, type}) => {
      const labelIcon = el.closest('.icon-label')
      if (type === 'add') {
        labelIcon.classList.add('inverse')
      }

      if (type === 'remove') {
        labelIcon.classList.remove('inverse')
      }
    }

    const onlyCheckOne = ({ el }) => {
      const dietCategoryItems = document.querySelectorAll('.diet-category-items')
      dietCategoryItems.forEach( checkbox => {
        // if (checkbox !== el) {
        //   checkbox.checked = false
        //   addInverseClass({el: checkbox, type: 'remove'})
        // }

        if (el.checked === true) {
          addInverseClass({el: el, type: 'add'})
        } else {
          addInverseClass({el: el, type: 'remove'})
        }
      })
    }

    const unCheckAddOns = ({ el }) => {
      el.querySelectorAll('input[type="checkbox"]').forEach( checkbox => {
        checkbox.checked = false
      })
    }

    const areAllUnChecked = () => {
      const el = document.querySelector('.category-collection-checkboxes')
      const inputs = el.querySelectorAll('input[type="checkbox"]')
      return Array.from(inputs).every( input => input.checked === false)
    }

    const hideAddOns = ({ el }) => {
      const toHide = document.querySelector('.autohide_by_category')
      if (areAllUnChecked()) {
        toHide.classList.remove('d-none')
      } else {
        toHide.classList.add('d-none')
      }
      unCheckAddOns({ el: toHide })
    }

    const init = () => {
      const container = document.querySelector('.category-collection-checkboxes')

      container.addEventListener('click', (e) => {
        if (e.target.type !== 'checkbox') { return }
          onlyCheckOne({ el: e.target })
          hideAddOns({ el: e.target })
      })
    }

    win.diet_category_init = init
    win.init_dropzone = initDropzone
  }(window))
})
