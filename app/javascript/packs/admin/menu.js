document.addEventListener('DOMContentLoaded', ()=>{
  (function(win) {
    const init = () => {
      let dietCategoryItem = document.querySelectorAll('.diet-category-items')

      if (dietCategoryItem) {
        Array.from(dietCategoryItem).forEach( (item) => {
          item.addEventListener('click', () => {
            let toHide = document.querySelector('.autohide_by_category')
            if (toHide) { toHide.style.display = 'none' }
          })
        })
      } else {
        console.warn('Error')
      }
    }
    win.diet_category_init = init
  }(window))
})