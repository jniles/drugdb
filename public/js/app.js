(function (win) {
  'use strict';
  var app = win.app = {};

  app.setupListeners = function changePass() {
    // a small js script to only allow submission once the passwords
    // match.

    var passwd1 = $("#pw1"),
        passwd2 = $("#pw2"),
        valid = false;

    $("input[type=password]").keyup(function () {
      // disabled if not valid
      valid = passwd1.val() === passwd2.val() && passwd1.val() !== "";

      if (valid) {
        $(".prefix").removeClass("secondary").addClass("success");
        $("input[type=submit]").removeClass("warning").addClass("success");
      } else {
        $(".prefix").removeClass("success").addClass("secondary");
        $("input[type=submit]").removeClass("success").addClass("warning");
      }

      $("input[type=submit]").prop('disabled', !valid);
    });
  };

})(window);
