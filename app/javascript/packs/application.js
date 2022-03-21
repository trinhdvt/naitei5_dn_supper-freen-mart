require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")
import "bootstrap"

global.toastr = require("toastr")

$(document).ready(function () {
  global.$.ajaxSetup({
    headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')}
  });
});
