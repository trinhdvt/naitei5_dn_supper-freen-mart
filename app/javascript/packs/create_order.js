$(document).ready(() => {
  $('#order-form').submit(e => {
    e.preventDefault();

    const selected = getSelectedProduct();
    const data = `${$("#order-form").serialize()}&${$.param({'product_ids': selected})}`;
    if (selected.length > 0) {
      $.ajax({
        url: `/orders`,
        headers: {"X-CSRF-Token": $("meta[name='csrf-token']").attr("content")},
        type: 'POST',
        data
      });
    }
  });
});
