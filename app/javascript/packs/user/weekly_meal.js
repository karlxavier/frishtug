const sidebar = document.querySelector('#main-sidebar')
const mainContainer = document.querySelector('#main-container')
const mealSidebarCtrl = document.querySelector('.sidebar-controls')
const mealFormWrapper = document.querySelector('#meal-form__wrapper')
const mealSideBar = document.querySelector('#sidebar')
const mealFormContainer = document.querySelector('#meal-form__container')
sidebar.parentNode.removeChild(sidebar)
mealSidebarCtrl.classList.add('d-none')
mainContainer.className = 'col-12 col-md-12 col-lg-12'

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
}

const showSideBar = () => {
  mealSideBar.style.display = 'block'
  mealSidebarCtrl.classList.add('d-none')
  mealFormContainer.className = 'col-9 col-md-9 col-lg-9'
  changeCardClass('md')
  localStorage.setItem('sidebar_state', 'shown')
}

mealFormWrapper.addEventListener('click', (e)=> {
  if (e.target.classList.contains('hide-sidebar')) {
    hideSidebar()
  }

  if (e.target.classList.contains('show-sidebar')) {
    showSideBar()
  }
})

(function(){
  const mainContainer = document.querySelector('#root-container')
  mainContainer.classList.remove('pt-4')
  mainContainer.classList.remove('container')
  mainContainer.classList.add('container-fluid')
  if (localStorage.getItem('sidebar_state') === 'shown') {
    showSideBar();
  } else {
    hideSidebar()
  }
}())
