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
            getUserData();
        }
    }

    function initPage() {
        $("#tabs").tabs({ cookie: { expires: 1 } });
        $("#tabs").tabs("option", "active", 1);
        //$("#ApplyFilter").button();
    }

    function getUserData() {
        try {
            $.ajax({
                url: "../Services/WCFService.svc/ajax/getServiceUserData",
                type: "POST",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: returnData,
                error: returnError
            });
        } catch (e) {
            alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
        }
    }

    function returnData(data) {
        try {

            var cUserData = document.getElementById("ftUserData");
            var cUserDataLogin = document.getElementById("ftUserDataLogin");
            var cUserDataUID = document.getElementById("ftUserDataUID");
            var cUserDataName = document.getElementById("ftUserDataName");
            var cUserDatasName = document.getElementById("ftUserDatasName");

            if (cUserData && cUserDataLogin && cUserDataUID && cUserDataName && cUserDatasName) {
                var vUID = "", vName = "", vsName = "", vLogin = 0;

                $.each(data, function (k, v) {
                    if (k === "UID") {
                        vUID = v;
                    } else if (k === "Name") {
                        vName = v;
                    } else if (k === "sName") {
                        vsName = v;
                    } else if (k === "Login") {
                        vLogin = v;
                    }
                });

                cUserData.innerHTML = vUID + ": " + vName;
                cUserDataLogin.value = vLogin;
                cUserDataUID.value = vUID;
                cUserDataName.value = vName;
                cUserDatasName.value = vsName;
            }

        } catch (e) {
            alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
        }
    }

    function returnError(jqXHR, textStatus, errorThrown) {
        var responseText, errDate = new Date(), errType, errCode, errMessage,
            errSource = "", errParameters = "", errHelpLink = "", textError = "Ошибка\n\n";

        if (jqXHR != null && jqXHR.responseText != "") {
            try {
                responseText = JSON.parse(jqXHR.responseText);
                errDate = new Date(parseInt(responseText.Date.substr(6)));
                errType = responseText.Type;
                errCode = responseText.Code;
                errMessage = responseText.Message;
                errSource = responseText.Source;
                errParameters = responseText.Parameters;
                errHelpLink = responseText.HelpLink;
            } catch (e) {
                alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
            }
        }

        textError += "Дата: " + zKdDateTimeFormat(errDate) + "\n";
        textError += "Тип: " + errType + "\n";
        textError += "Код: " + errCode + "\n";
        textError += "Сообщение: " + errMessage + "\n";
        textError += "Источник: " + errSource + "\n";
        textError += "Параметры: [" + errParameters + "]\n";
        textError += "Ссылка: " + errHelpLink + "\n\n";

        textError += "readyState: " + jqXHR.readyState + "\n";
        textError += "status: " + jqXHR.status + "\n";
        textError += "statusText: " + jqXHR.statusText + "\n";
        textError += "responseXML: " + jqXHR.responseXML + "\n";
        textError += "textStatus: " + textStatus + "\n";
        textError += "errorThrown: " + errorThrown + "\n\n";

        alert(textError);
    }

})(window);