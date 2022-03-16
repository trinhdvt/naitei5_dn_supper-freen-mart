const qtt_input = $('#input-qtt');
const max_qtt = parseInt($('#product_max_qtt').val()) || 0;

function change_quantity(update_fn) {
    const value = parseInt(qtt_input.val());
    const new_qtt = update_fn(value);
    qtt_input.val(new_qtt);
}

const decrease_quantity = value => isNaN(value) ? 1 : Math.max(1, value - 1);
const increase_quantity = value => isNaN(value) ? 1 : Math.min(max_qtt, value + 1);
const verify_quantity = value => isNaN(value) ? 1 : Math.max(1, Math.min(max_qtt, value));

$('#btn-qtt_decr').on('click', change_quantity.bind(null, decrease_quantity));
$('#btn-qtt_incr').on('click', change_quantity.bind(null, increase_quantity));
qtt_input.on('blur', change_quantity.bind(null, verify_quantity));
