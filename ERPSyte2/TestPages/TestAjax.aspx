<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TestAjax.aspx.cs" Inherits="ERPSyte2.TestAjax" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>test ajax</title>
    <script type="text/javascript" src="../Scripts/jquery-1.6.4.min.js"></script>
    <script type="text/javascript" src="../Scripts/json2.js"></script>
    <script type="text/javascript" src="../Scripts/jquery.blockUI.min.js"></script>
    <script type="text/javascript">
        function doAlert() {
            //alert("#");
            var fail_this_check = true;
            if (fail_this_check)
                return false;
            else
                return true;
        }
    </script>
    <script type="text/javascript">

        function sendText() {
            var s = document.getElementById("tText").value;
            if (s == "")
                s = "n/a";

            //alert("You send text: " + s);
            $.ajax({
                url: "http://localhost:18299/ErpWcfService.svc/GetData?",
                type: "GET",
                data: '{"value":"' + s + '"}',
                contentType: "application/javascript",
                jsonpCallback: "MyCallBack",
                datatype: "jsonp",
                success: function (data) {
                    //document.getElementById("rText").value = data.d;
                    //document.getElementById("rMathResult").value = data.d;
                    alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }
        function MyCallBack(data) {
            alert('success : ' + data);
        }

        function sendNumber() {
            var n1 = document.getElementById("tNumber1").value;
            var n2 = document.getElementById("tNumber2").value;
            if (isNaN(n1) || (n1 == ""))
                n1 = 0;
            if (isNaN(n2) || (n2 == ""))
                n2 = 0;
            jQuery.support.cors = true;
            $.ajax({
                type: "POST",
                url: "http://SL-DB-SRV.elektron.spb.su/ErpAppService/ErpAppService.svc/Add",
                data: '{ "n1":"' + n1 + '", "n2":"' + n2 + '" }',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rNumber").value = data.d;
                    document.getElementById("rMathResult").value = data.d;
                    //alert("success: " + data.d);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
            //alert("You send numbers: n1=" + n1 + ", n2=" + n2);
        }

        function sendDoubleJSON() {
            var n1 = document.getElementById("tDouble1").value;
            var n2 = document.getElementById("tDouble2").value;
            if (isNaN(n1) || (n1 == ""))
                n1 = 0;
            if (isNaN(n2) || (n2 == ""))
                n2 = 0;
            jQuery.support.cors = true;
            $.ajax({
                type: "POST",
                url: "http://SL-DB-SRV.elektron.spb.su/ErpAppService/ErpAppService.svc/DoMathJson",
                data: '{ "n1":"' + n1 + '", "n2":"' + n2 + '" }',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var s = data.d.toString();
                    s = s + "\nsum=" + data.d.sum;
                    s = s + "\ndifference=" + data.d.difference;
                    s = s + "\nproduct=" + data.d.product;
                    s = s + "\nquotient=" + data.d.quotient;
                    document.getElementById("rMathResult").value = s;
                    //alert("success: " + data.d);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
            //alert("You send numbers: n1=" + n1 + ", n2=" + n2);
        }

        function sendDoubleXML() {
            var n1 = document.getElementById("tDouble1").value;
            var n2 = document.getElementById("tDouble2").value;
            if (isNaN(n1) || (n1 == ""))
                n1 = 0;
            if (isNaN(n2) || (n2 == ""))
                n2 = 0;
            jQuery.support.cors = true;
            $.ajax({
                type: "POST",
                url: "http://SL-DB-SRV.elektron.spb.su/ErpAppService/ErpAppService.svc/DoMathXml",
                data: '{ "n1":"' + n1 + '", "n2":"' + n2 + '" }',
                datatype: "xml",
                contentType: "text/xml; charset=utf-8",
                success: function (data) {
                    //$(data).find("GetDataResponse").each(function () {
                    //    alert($(this).find("GetDataResult").text());
                    //});
                    //var s = "\ndata=" + data;
                    //s = s + "\ndata.toString()=" + data.toString();
                    //s = s + "\ndata.d=" + data.d;
                    //s = s + "\ndata.d.toString()=" + data.d.toString();
                    //s = s + "\ndata.sum=" + data.sum;
                    //s = s + "\ndata.d.sum=" + data.d.sum;
                    //document.getElementById("rMathResult").value = s;
                    alert("success: " + data.d);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
            //alert("You send numbers: n1=" + n1 + ", n2=" + n2);
        }

        function callHelloWorldExt() {
            $.ajax({
                url: "Services/WCFAjaxService.svc/HelloWorld",
                type: "POST",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    //document.getElementById("rText").value = data.d;
                    //document.getElementById("rMathResult").value = data.d;
                    alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function callSDSHelloWorld() {
            $.ajax({
                url: "http://sl-db-srv.elektron.spb.su/ErpAppService/ErpAppService.svc/HelloWorld",
                type: "POST",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    //document.getElementById("rText").value = data.d;
                    //document.getElementById("rMathResult").value = data.d;
                    alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

    </script>
    <script type="text/javascript">
        //var spinnerImg = new Image();
        //<c:url value="/images/spinner.GIF" var="spinnerImage" />
        //spinnerImg.src = "${spinnerImage}";
        //spinnerImg.src = "../Image/49.gif";

        function loadpage() {
            $.ajax({ url: 'wait.jsp', cache: false });
        }

        function doAction() {

            //message: '<h1><img src="../Image/49.gif" /> Just a moment...</h1>',
            //css: {
            //    top: ($(window).height() - 500) / 2 + 'px',
            //    left: ($(window).width() - 500) / 2 + 'px',
            //    width: '500'
                //$(document).ready(function () {
            //    $('#demo5').click(function () {
                    $.blockUI();

                    //loadpage();

                    setTimeout($.unblockUI, 3000);
            //    });
            //});
            //setTimeout(function() {
            //    alert('Привет');
            //}, 2000);

            return true;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table>
                <tr>
                    <td>with return
                        <input type="checkbox" onclick="return doAlert()" />
                    </td>
                    <td>without return
                        <input type="checkbox" onclick="doAlert()" />
                    </td>
                </tr>
                <tr>
                    <td>with return <a href="http://www.google.com" onclick="return (confirm('Follow this link?'))">Google</a>
                    </td>
                    <td>without return <a href="http://www.google.com" onclick="confirm('Follow this link?')">Google</a>
                    </td>
                </tr>
                <tr>
                    <td>with return <a href='#' onclick='alert(3.1415926); return false;'>Click here with return!</a>
                    </td>
                    <td>without return <a href='#' onclick='alert(3.1415926);'>Click here without return!</a>
                    </td>
                </tr>
            </table>
            <div>
                <h1>AJAX</h1>
                Other domain
                &nbsp;&nbsp;
                <input type="button" value="sl-db-srv Hello World" onclick="return callSDSHelloWorld();" disabled="disabled" />
                &nbsp;&nbsp;
                <input type="button" value="Hello World other domain" onclick="return callHelloWorldExt();" disabled="disabled" />
                <br />

                Text&nbsp;
                <input type="text" id="tText" value="9" />
                &nbsp;
                <input type="button" id="bText" value="send Text" onclick="sendText1();" disabled="disabled" />
                <br />

                Number1&nbsp;
                <input type="text" id="tNumber1" value="1.6" />
                &nbsp;
                Number2&nbsp;
                <input type="text" id="tNumber2" value="3.2" />
                &nbsp;
                <input type="button" id="bNumber" value="send Number" onclick="sendNumber();" disabled="disabled" />
                <br />

                <%--                Double1&nbsp;
                <input type="text" id="tDouble1" value="5.4" />
                &nbsp;
                Double2&nbsp;
                <input type="text" id="tDouble2" value="7.8" />
                &nbsp;
                <input type="button" id="btnDoMathJson" value="Perform calculation (return JSON)" onclick="sendDoubleJSON();" />
                &nbsp;
                <input type="button" id="btnDoMathXml" value="Perform calculation (return XML)" onclick="sendDoubleXML();" />
                <br />
                <br />--%>

                <br />
                <input type="button" id="bAction" value="b Action" onclick="return doAction();" />
                <br />

                <h3>Results</h3>
                result Text&nbsp;
                <input type="text" id="rText" value="" />
                <br />

                result Number&nbsp;
                <input type="text" id="rNumber" value="" />
                <br />

                result Memo&nbsp;
                <textarea id="rMathResult" cols="80" rows="15"></textarea>
                <br />
            </div>
            <table>
                <tr>
                    <td>
                        <h4>json</h4>
                    </td>
                    <td>
                        <h4>xml</h4>
                    </td>
                    <td>
                        <h4>ajax</h4>
                    </td>
                    <td>
                        <h4 style="color: red;">soap not working!</h4>
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="button" value="json_ string HelloWorld!" onclick="return json_HelloWorld();" />
                    </td>
                    <td>
                        <input type="button" value="xml_ string HelloWorld!" onclick="return xml_HelloWorld();" />
                    </td>
                    <td>
                        <input type="button" value="ajax_ string HelloWorld!" onclick="return ajax_HelloWorld();" />
                    </td>
                    <td>
                        <input type="button" value="soap_ string HelloWorld!" onclick="return soap_HelloWorld();" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="button" value="json_ string Hello" onclick="return json_Hello();" />
                    </td>
                    <td>
                        <input type="button" value="xml_ string Hello" onclick="return xml_Hello();" />
                    </td>
                    <td>
                        <input type="button" value="ajax_ string Hello" onclick="return ajax_Hello();" />
                    </td>
                    <td>
                        <input type="button" value="soap_ string Hello" onclick="return soap_Hello();" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="button" value="json_ double Add" onclick="return json_Add();" />
                    </td>
                    <td>
                        <input type="button" value="xml_ double Add" onclick="return xml_Add();" />
                    </td>
                    <td>
                        <input type="button" value="ajax_ double Add" onclick="return ajax_Add();" />
                    </td>
                    <td>
                        <input type="button" value="soap_ double Add" onclick="return soap_Add();" disabled="disabled" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="button" value="json_ Message ComposeMessage" onclick="return json_ComposeMessage();" />
                    </td>
                    <td>
                        <input type="button" value="xml_ Message ComposeMessage" onclick="return xml_ComposeMessage();" />
                    </td>
                    <td>
                        <input type="button" value="ajax_ Message ComposeMessage" onclick="return ajax_ComposeMessage();" />
                    </td>
                    <td>
                        <input type="button" value="soap_ Message ComposeMessage" onclick="return soap_ComposeMessage();" disabled="disabled" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="button" value="json_ void SayHello" onclick="return json_SayHello();" />
                    </td>
                    <td>
                        <input type="button" value="xml_ void SayHello" onclick="return xml_SayHello();" />
                    </td>
                    <td>
                        <input type="button" value="ajax_ void SayHello" onclick="return ajax_SayHello();" />
                    </td>
                    <td>
                        <input type="button" value="soap_ void SayHello" onclick="return soap_SayHello();" disabled="disabled" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="button" value="json_ void SayHelloBy" onclick="return json_SayHelloBy();" />
                    </td>
                    <td>
                        <input type="button" value="xml_ void SayHelloBy" onclick="return xml_SayHelloBy();" />
                    </td>
                    <td>
                        <input type="button" value="ajax_ void SayHelloBy" onclick="return ajax_SayHelloBy();" />
                    </td>
                    <td>
                        <input type="button" value="soap_ void SayHelloBy" onclick="return soap_SayHelloBy();" disabled="disabled" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="button" value="json_ Stream GetValue" onclick="return json_GetValue();" />
                    </td>
                    <td>
                        <input type="button" value="xml_ Stream GetValue" onclick="return xml_GetValue();" />
                    </td>
                    <td>
                        <input type="button" value="ajax_ Stream GetValue" onclick="return ajax_GetValue();" />
                    </td>
                    <td>
                        <input type="button" value="soap_ Stream GetValue" onclick="return soap_GetValue();" disabled="disabled" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="button" value="json_ void DoWork" onclick="return json_DoWork();" />
                    </td>
                    <td>
                        <input type="button" value="xml_ void DoWork" onclick="return xml_DoWork();" />
                    </td>
                    <td>
                        <input type="button" value="ajax_ void DoWork" onclick="return ajax_DoWork();" />
                    </td>
                    <td>
                        <input type="button" value="soap_ void DoWork" onclick="return soap_DoWork();" disabled="disabled" />
                    </td>
                </tr>
            </table>
        </div>
    </form>
    <script type="text/javascript">
        function json_HelloWorld() {
            $.ajax({
                url: "../Services/WCFService.svc/json/HelloWorld",
                type: "POST",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.HelloWorldResult;
                    document.getElementById("rMathResult").value = data.HelloWorldResult;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function json_Hello() {
            var s = document.getElementById("tText").value;
            if (s == "")
                s = "n/a";

            $.ajax({
                url: "../Services/WCFService.svc/json/Hello",
                type: "POST",
                data: '{"name":"' + s + '"}',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.HelloResult;
                    document.getElementById("rMathResult").value = data.HelloResult;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function json_Add() {
            var n1 = document.getElementById("tNumber1").value;
            var n2 = document.getElementById("tNumber2").value;
            if (isNaN(n1) || (n1 == ""))
                n1 = 0;
            if (isNaN(n2) || (n2 == ""))
                n2 = 0;

            $.ajax({
                url: "../Services/WCFService.svc/json/Add",
                type: "POST",
                data: '{"n1":"' + n1 + '", "n2":"' + n2 + '" }',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.AddResult;
                    document.getElementById("rMathResult").value = data.AddResult;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function json_ComposeMessage() {
            var header = document.getElementById("tText").value;
            if (header == "")
                header = "n/a";
            var body = "this is the body";

            $.ajax({
                url: "../Services/WCFService.svc/json/ComposeMessage",
                type: "POST",
                data: '{"header":"' + header + '", "body":"' + body + '" }',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.ComposeMessageResult;
                    document.getElementById("rMathResult").value = data.ComposeMessageResult;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function json_SayHello() {
            $.ajax({
                url: "../Services/WCFService.svc/json/SayHello",
                type: "POST",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.SMMessage;
                    document.getElementById("rMathResult").value = data.SMMessage;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function json_SayHelloBy() {
            var s = document.getElementById("tText").value;
            if (s == "")
                s = "n/a";

            $.ajax({
                url: "../Services/WCFService.svc/json/SayHelloBy",
                type: "POST",
                data: '{"name":"' + s + '"}',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.SMMessage;
                    document.getElementById("rMathResult").value = data.SMMessage;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function json_GetValue() {
            $.ajax({
                url: "../Services/WCFService.svc/json/GetValue",
                type: "GET",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.GetValueResult;
                    document.getElementById("rMathResult").value = data.GetValueResult;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function json_DoWork() {
            $.ajax({
                url: "../Services/WCFService.svc/json/DoWork",
                type: "POST",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data;
                    document.getElementById("rMathResult").value = data;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

    </script> <%--json--%>
    <script type="text/javascript">
        function xml_HelloWorld() {
            $.ajax({
                url: "../Services/WCFService.svc/xml/HelloWorld",
                type: "POST",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.HelloWorldResult;
                    document.getElementById("rMathResult").value = data.HelloWorldResult;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function xml_Hello() {
            var s = document.getElementById("tText").value;
            if (s == "")
                s = "n/a";

            $.ajax({
                url: "../Services/WCFService.svc/xml/Hello",
                type: "POST",
                data: '{"name":"' + s + '"}',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.HelloResult;
                    document.getElementById("rMathResult").value = data.HelloResult;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function xml_Add() {
            var n1 = document.getElementById("tNumber1").value;
            var n2 = document.getElementById("tNumber2").value;
            if (isNaN(n1) || (n1 == ""))
                n1 = 0;
            if (isNaN(n2) || (n2 == ""))
                n2 = 0;

            $.ajax({
                url: "../Services/WCFService.svc/xml/Add",
                type: "POST",
                data: '{"n1":"' + n1 + '", "n2":"' + n2 + '" }',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.AddResult;
                    document.getElementById("rMathResult").value = data.AddResult;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function xml_ComposeMessage() {
            var header = document.getElementById("tText").value;
            if (header == "")
                header = "n/a";
            var body = "this is the body";

            $.ajax({
                url: "../Services/WCFService.svc/xml/ComposeMessage",
                type: "POST",
                data: '{"header":"' + header + '", "body":"' + body + '" }',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.ComposeMessageResult;
                    document.getElementById("rMathResult").value = data.ComposeMessageResult;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function xml_SayHello() {
            $.ajax({
                url: "../Services/WCFService.svc/xml/SayHello",
                type: "POST",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.SMMessage;
                    document.getElementById("rMathResult").value = data.SMMessage;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function xml_SayHelloBy() {
            var s = document.getElementById("tText").value;
            if (s == "")
                s = "n/a";

            $.ajax({
                url: "../Services/WCFService.svc/xml/SayHelloBy",
                type: "POST",
                data: '{"name":"' + s + '"}',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.SMMessage;
                    document.getElementById("rMathResult").value = data.SMMessage;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function xml_GetValue() {
            $.ajax({
                url: "../Services/WCFService.svc/xml/GetValue",
                type: "GET",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.GetValueResult;
                    document.getElementById("rMathResult").value = data.GetValueResult;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function xml_DoWork() {
            $.ajax({
                url: "../Services/WCFService.svc/xml/DoWork",
                type: "POST",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data;
                    document.getElementById("rMathResult").value = data;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

    </script> <%--xml--%>
    <script type="text/javascript">
        function ajax_HelloWorld() {
            $.ajax({
                url: "../Services/WCFService.svc/ajax/HelloWorld",
                type: "POST",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                beforeSend: function () { $.blockUI(); },
                complete: function () { $.unblockUI(); },
                success: function (data) {
                    document.getElementById("rText").value = data.d;
                    document.getElementById("rMathResult").value = data.d;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function ajax_Hello() {
            var s = document.getElementById("tText").value;
            if (s == "")
                s = "n/a";

            $.ajax({
                url: "../Services/WCFService.svc/ajax/Hello",
                type: "POST",
                data: '{"name":"' + s + '"}',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.d;
                    document.getElementById("rMathResult").value = data.d;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function ajax_Add() {
            var n1 = document.getElementById("tNumber1").value;
            var n2 = document.getElementById("tNumber2").value;
            if (isNaN(n1) || (n1 == ""))
                n1 = 0;
            if (isNaN(n2) || (n2 == ""))
                n2 = 0;

            $.ajax({
                url: "../Services/WCFService.svc/ajax/Add",
                type: "POST",
                data: '{"n1":"' + n1 + '", "n2":"' + n2 + '" }',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.d;
                    document.getElementById("rMathResult").value = data.d;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function ajax_ComposeMessage() {
            var header = document.getElementById("tText").value;
            if (header == "")
                header = "n/a";
            var body = "this is the body";

            $.ajax({
                url: "../Services/WCFService.svc/ajax/ComposeMessage",
                type: "POST",
                data: '{"header":"' + header + '", "body":"' + body + '" }',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.d;
                    document.getElementById("rMathResult").value = data.d;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function ajax_SayHello() {
            $.ajax({
                url: "../Services/WCFService.svc/ajax/SayHello",
                type: "POST",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.d;
                    document.getElementById("rMathResult").value = data.d;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function ajax_SayHelloBy() {
            var s = document.getElementById("tText").value;
            if (s == "")
                s = "n/a";

            $.ajax({
                url: "../Services/WCFService.svc/ajax/SayHelloBy",
                type: "POST",
                data: '{"name":"' + s + '"}',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.d;
                    document.getElementById("rMathResult").value = data.d;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function ajax_GetValue() {
            $.ajax({
                url: "../Services/WCFService.svc/ajax/GetValue",
                type: "GET",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.d;
                    document.getElementById("rMathResult").value = data.d;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function ajax_DoWork() {
            $.ajax({
                url: "../Services/WCFService.svc/ajax/DoWork",
                type: "POST",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.d;
                    document.getElementById("rMathResult").value = data.d;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

    </script> <%--ajax--%>
    <script type="text/javascript">
        function soap_HelloWorld() {

            $.ajax({
                url: "../Services/WCFService.svc/soap/HelloWorld",
                type: "POST",
                datatype: "xml",
                timeout: 10000,
                contentType: "text/xml",
                success: function (data) {
                    //document.getElementById("rText").value = data;
                    //document.getElementById("rMathResult").value = data;
                    alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function soap_Hello() {
            var s = document.getElementById("tText").value;
            if (s == "")
                s = "n/a";

//            var theRequest = " \
//<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\"> \
//  <s:Header> \
//    <Action s:mustUnderstand=\"1\" xmlns=\"http://schemas.microsoft.com/ws/2005/05/addressing/none\">http://tempuri.org/ILOService/GetLoanActions</Action> \
//  </s:Header> \
//  <s:Body> \
//    <GetLoanActions xmlns=\"http://tempuri.org/\"> \
//      <request xmlns:d4p1=\"http://schemas.datacontract.org/2004/07/LOServices.Proxy.Requests\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\"> \
//        <d4p1:AssociationNumber>3</d4p1:AssociationNumber> \
//        <d4p1:IgnoreWarnings>false</d4p1:IgnoreWarnings> \
//      </request> \
//    </GetLoanActions> \
//  </s:Body> \
//</s:Envelope>";
//            data: theRequest,
//            data: '{"name":"' + s + '"}',
//            headers: { "SOAPAction": "http://tempuri.org/Contract/Operation" },
            //beforeSend: function (xhr) {
            //    xhr.setRequestHeader("SOAPAction", "http://tempuri.org/ISOAPService/Hello");
            //},
            //processData: false,
            //timeout: 10000,
            var theRequest = "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">" +
                   "<s:Body>" + 
                   "<Hello xmlns=\"http://tempuri.org/\">" +
                   "<name>" + s + "</name>" +
                   "</Hello>" +
                   "</s:Body>"  +
               "</s:Envelope>";

            $.ajax({
                url: "../Services/WCFService.svc/soap/Hello",
                type: "POST",
                datatype: "xml",
                data: theRequest,
                contentType: "text/xml",
                success: function (data) {
                    //document.getElementById("rText").value = data.HelloResult;
                    //document.getElementById("rMathResult").value = data.HelloResult;
                    alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function soap_Add() {
            var n1 = document.getElementById("tNumber1").value;
            var n2 = document.getElementById("tNumber2").value;
            if (isNaN(n1) || (n1 == ""))
                n1 = 0;
            if (isNaN(n2) || (n2 == ""))
                n2 = 0;

            $.ajax({
                url: "../Services/WCFService.svc/soap/Add",
                type: "POST",
                data: '{"n1":"' + n1 + '", "n2":"' + n2 + '" }',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.AddResult;
                    document.getElementById("rMathResult").value = data.AddResult;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function soap_ComposeMessage() {
            var header = document.getElementById("tText").value;
            if (header == "")
                header = "n/a";
            var body = "this is the body";

            $.ajax({
                url: "../Services/WCFService.svc/soap/ComposeMessage",
                type: "POST",
                data: '{"header":"' + header + '", "body":"' + body + '" }',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.ComposeMessageResult;
                    document.getElementById("rMathResult").value = data.ComposeMessageResult;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function soap_SayHello() {
            $.ajax({
                url: "../Services/WCFService.svc/soap/SayHello",
                type: "POST",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.SMMessage;
                    document.getElementById("rMathResult").value = data.SMMessage;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function soap_SayHelloBy() {
            var s = document.getElementById("tText").value;
            if (s == "")
                s = "n/a";

            $.ajax({
                url: "../Services/WCFService.svc/soap/SayHelloBy",
                type: "POST",
                data: '{"name":"' + s + '"}',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.SMMessage;
                    document.getElementById("rMathResult").value = data.SMMessage;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function soap_GetValue() {
            $.ajax({
                url: "../Services/WCFService.svc/soap/GetValue",
                type: "GET",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data.GetValueResult;
                    document.getElementById("rMathResult").value = data.GetValueResult;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function soap_DoWork() {
            $.ajax({
                url: "../Services/WCFService.svc/soap/DoWork",
                type: "POST",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rText").value = data;
                    document.getElementById("rMathResult").value = data;
                    //alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

    </script> <%--soap--%>
</body>
</html>
