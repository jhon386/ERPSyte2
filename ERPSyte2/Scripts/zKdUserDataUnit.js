var userData = {
  UID: 0,
  login: "",
  name: "",
  sName: ""
};

(function () {
  "use strict";

  try {
    $.ajax({
      async: false,
      url: "../Services/WCFService.svc/ajax/getServiceUserData",
      type: "POST",
      datatype: "json",
      contentType: "application/json; charset=utf-8",
      success: function (data) {
        try {

          $.each(data, function (k, v) {
            if (k === "UID") {
              userData.UID = v;
            } else if (k === "Name") {
              userData.name = v;
            } else if (k === "sName") {
              userData.sName = v;
            } else if (k === "Login") {
              userData.login = v;
            }
          });

        } catch (e) {
          alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
        }
      },
      error: handleAjaxErrorFunction
    });
  } catch (e) {
    alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
  }
})()