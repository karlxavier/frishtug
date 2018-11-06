const fetchItems = () => {
  Rails.ajax({
    url: '/api/v1/items',
    type: 'GET',
    success: function(response) {
      sessionStorage.setItem('items', JSON.stringify(response.data))
    }
  });
}

fetchItems();
