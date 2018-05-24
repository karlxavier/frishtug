const mainContainer = document.querySelector('#main-container')
const mealSidebarCtrl = document.querySelector('.sidebar-controls')
const mealFormWrapper = document.querySelector('#meal-form__wrapper')
const mealSideBar = document.querySelector('#sidebar')
const mealFormContainer = document.querySelector('#meal-form__container')
const addOns = document.querySelectorAll('.menu_add_ons')
const scrollTopbtn = document.querySelector(".go_to_top")

mealSidebarCtrl.classList.add('d-none')
mainContainer.className = 'col-12 col-md-12 col-lg-12'

const showScrollTopBtn = () => {
  if (document.body.scrollTop > 100 || document.documentElement.scrollTop > 100) {
    scrollTopbtn.style.display = 'block'
    if (mealSideBar.style.display === "block") {
      scrollTopbtn.style.right = "35rem"
    } else {
      scrollTopbtn.style.right = "1rem"
    }
  } else {
    scrollTopbtn.style.display = 'none'
  }
}

scrollTopbtn.addEventListener('click', function() {
  $("html, body").animate({ scrollTop: 0 }, 600);
})

window.onscroll = showScrollTopBtn

const changeCardClass = (size) => {
  const els = document.querySelectorAll('.card')
  els.forEach( el => {
    if (size === 'lg') {
      el.classList.add('col-lg-2')
    } else {
      el.classList.remove('col-lg-2')
    }
  })
}

const hideSidebar = () => {
  mealSideBar.style.display = 'none'
  mealSidebarCtrl.classList.remove('d-none')
  mealFormContainer.className = 'col-12 col-md-12 col-lg-12'
  changeCardClass('lg')
  localStorage.setItem('sidebar_state', 'hidden')
  scrollTopbtn.style.right = "1rem";
}

const showSideBar = () => {
  mealSideBar.style.display = 'block'
  mealSidebarCtrl.classList.add('d-none')
  mealFormContainer.className = 'col-8 col-md-8 col-lg-8'
  changeCardClass('md')
  localStorage.setItem('sidebar_state', 'shown')
  scrollTopbtn.style.right = "30rem";
}

mealFormWrapper.addEventListener('click', (e)=> {
  if (e.target.classList.contains('hide-sidebar')) {
    hideSidebar()
  }

  if (e.target.classList.contains('show-sidebar')) {
    showSideBar()
  }
})

const addOnsHandler = (e) => {
  const date = e.target.dataset.date
  const menuId = e.target.dataset.menuId
  const storeUrl = `/user/orders/store?date=${date}&menu_id=${menuId}&add_on_id=${e.target.value}`
  const removeUrl = `/user/orders/remove?date=${date}&menu_id=${menuId}&add_on_id=${e.target.value}`
  const url = e.target.checked ? storeUrl : removeUrl
  Rails.ajax({
    url: url,
    type: 'GET',
  })
}

const modalHandler = (event) => {
  const menu_id = event.target.dataset.menuId
  const showDescription = event.target.dataset.showDescription
  if (menu_id && showDescription) {
    Rails.ajax({
      url: `/user/nutritional_data?menu_id=${menu_id}`,
      type: 'GET'
    })
  }
}


(function(){
  const mainContainer = document.querySelector('#root-container');
  const menuEntries = document.querySelector("#menu-entries");
  mainContainer.classList.remove('pt-4');
  mainContainer.classList.remove('container');
  mainContainer.classList.add('container-fluid');
  if (localStorage.getItem('sidebar_state') === 'shown') {
    showSideBar();
  } else {
    hideSidebar();
  }
  Array.from(addOns).forEach( addOn => {
    addOn.addEventListener('click', addOnsHandler);
  })

  menuEntries.addEventListener('click', modalHandler);
}())
