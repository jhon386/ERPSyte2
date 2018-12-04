(function (window, undefined) {
  "use strict";

  $("document").ready(loadCurrYear); //docReady(loadCurrYear); //document.addEventListener("DOMContentLoaded", loadCurrYear);
  $("document").ready(loadUserData); //docReady(loadUserData); //document.addEventListener("DOMContentLoaded", loadUserData);
  $("document").ready(initPage); //docReady(initPage); //document.addEventListener("DOMContentLoaded", initPage);

  function loadCurrYear() {
    var cCurrYear = document.getElementById("ftCurrYear");
    if (cCurrYear)
      cCurrYear.innerHTML = new Date().getFullYear();
  }

  function loadUserData() {
    var cUserData = document.getElementById("ftUserData");
    if (cUserData) {
      cUserData.innerHTML = "0: n/a";
      if (userData) {
        cUserData.innerHTML = userData.UID + ": " + userData.name;
      }
    }
  }

  function initPage() {
    $("#tabs").tabs({ cookie: { expires: 1 } });
    $("#tabs").tabs("option", "active", 1);
    //$("#ApplyFilter").button();
  }

})(window);