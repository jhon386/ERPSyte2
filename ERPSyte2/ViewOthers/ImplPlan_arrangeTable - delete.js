(function (window, undefined) {
  "use strict";

  $("document").ready(doAfterLoaded);

  function doAfterLoaded() {
    let wth_Type = $("#th_Type").width();
    $("#th_Type").width(32);
    $("#wth_Type").val(wth_Type);

    //alert('doAfterLoaded=' + wth_Type);
  }
})(window)