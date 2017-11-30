const sidebar = document.querySelector('#main-sidebar');
const mainContainer = document.querySelector('#main-container');
const mealSidebarCtrl = document.querySelector('.sidebar-controls');
const mealFormWrapper = document.querySelector('#meal-form__wrapper');
const mealSideBar = document.querySelector('#sidebar');
const mealFormContainer = document.querySelector('#meal-form__container');
sidebar.style.display = 'none';
mealSidebarCtrl.classList.add('d-none');
mainContainer.className = 'col-12 col-md-12 col-lg-12';
mealFormWrapper.addEventListener('click', (e)=> {
  if (e.target.classList.contains('hide-sidebar')) {
    mealSideBar.style.display = 'none';
    mealSidebarCtrl.classList.remove('d-none');
    mealFormContainer.className = 'col-12 col-md-12 col-lg-12';
  }

  if (e.target.classList.contains('show-sidebar')) {
    mealSideBar.style.display = 'block';
    mealSidebarCtrl.classList.add('d-none');
    mealFormContainer.className = 'col-9 col-md-9 col-lg-9';
  }
})