document.addEventListener('DOMContentLoaded', ()=>{
  (function(win) {

    const onlyCheckOne = ({ el }) => {
      const dietCategoryItems = document.querySelectorAll('.diet-category-items')
      dietCategoryItems.forEach( checkbox => {
        if (checkbox !== el) {
          checkbox.checked = false
        }
      })
    }

    const unCheckAddOns = ({ el }) => {
      el.querySelectorAll('input[type="checkbox"]').forEach( checkbox => {
        checkbox.checked = false
      })
    }

    const hideAddOns = ({ el }) => {
      const toHide = document.querySelector('.autohide_by_category')
      if (el.checked) {
        toHide.classList.add('d-none')
      } else {
        toHide.classList.remove('d-none') 
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
  }(window))
})