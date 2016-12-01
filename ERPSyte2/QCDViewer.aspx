<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QCDViewer.aspx.cs" Inherits="ERPSyte2.QCDViewer" MasterPageFile="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="head" runat="server" ID="HeadContent">
    <link type="text/css" rel="Stylesheet" href="Content/themes/base/jquery-ui.css" />
    <script type="text/javascript" src="Scripts/jquery-1.6.4.min.js"></script>
    <script type="text/javascript" src="Scripts/jquery-ui-1.10.4.min.js"></script>
    <script type="text/javascript" src="Scripts/DatePickerReady.js"></script>
    <script type="text/javascript" src="Scripts/d3.min.js"></script>
    <script type="text/javascript" src="Scripts/QCD_ExportExcel.js"></script>
    <script type="text/javascript">
        function GetParamAndExport(){
            var cDateRecordFrom = "";
            var cDateRecordTo = "";
            var cDateTransferFrom = document.getElementById("<%= DateTransferFrom.ClientID %>").value;
            var cDateTransferTo = document.getElementById("<%= DateTransferTo.ClientID %>").value;
            var cDateAcceptFrom = document.getElementById("<%= DateAcceptFrom.ClientID %>").value;
            var cDateAcceptTo = document.getElementById("<%= DateAcceptTo.ClientID %>").value;
            var cItem = document.getElementById("<%= Item.ClientID %>").value;
            var cDescription = document.getElementById("<%= Description.ClientID %>").value;
            var cRepeated = document.getElementById("<%= Repeated.ClientID %>").value;
            var cTemaNIOKR = document.getElementById("<%= TemaNIOKR.ClientID %>").value;
            var cVend = document.getElementById("<%= Vend.ClientID %>").value;
            var cVendN = document.getElementById("<%= VendN.ClientID %>").value;
            var cChecker = document.getElementById("<%= Checker.ClientID %>").value;
            var cScrap = document.getElementById("<%= Scrap.ClientID %>").value;
            var cLot = document.getElementById("<%= Lot.ClientID %>").value;
            var cWaitWork = (document.getElementById("<%= cbWaitWork.ClientID %>").checked ? 1 : 0); 
            var cWaitANP = (document.getElementById("<%= cbWaitANP.ClientID %>").checked ? 1 : 0); 
            var cWaitWorkDay = document.getElementById("<%= tbWaitWork.ClientID %>").value;
            var cWaitANPDay = document.getElementById("<%= tbWaitANP.ClientID %>").value;
            var cShowTo = document.getElementById("<%= ShowTo.ClientID %>").value;
            var cShowCooperate = 0;
            var cShowBuy = 0;
            var cShowOnlyLocQCD = (document.getElementById("<%= cbShowOnlyLocQCD.ClientID %>").checked ? 1 : 0); 
            var cShowOnlyLocWork = (document.getElementById("<%= cbShowOnlyLocWork.ClientID %>").checked ? 1 : 0); 
            var cUM = document.getElementById("<%= UMs.ClientID %>").value;
            switch (cShowTo)
            {
                case "все":
                    cShowCooperate = 1;
                    cShowBuy = 1;
                    break;
                case "Кооперация":
                    cShowCooperate = 1;
                    cShowBuy = 0;
                    break;
                case "Закупка":
                    cShowCooperate = 0;
                    cShowBuy = 1;
                    break;
            }

            ExportToExcelClient(cShowCooperate, cShowBuy,
                cDateRecordFrom, cDateRecordTo, cDateTransferFrom, cDateTransferTo, cDateAcceptFrom, cDateAcceptTo,
                cItem, cDescription, cRepeated, cTemaNIOKR, cVend, cVendN, cChecker, cScrap, cLot, 
                cWaitWork, cWaitANP, cWaitWorkDay, cWaitANPDay, cShowOnlyLocQCD, cShowOnlyLocWork, cUM);
        }
    </script>
    <style type="text/css">
        .bar {
            fill: steelblue;
        }

            .bar:hover {
                fill: brown;
            }

        .axis {
            font: 10px sans-serif;
        }

            .axis path,
            .axis line {
                fill: none;
                stroke: #000;
                shape-rendering: crispEdges;
            }

        .x.axis path {
            display: none;
        }

        .arc path {
            stroke: #fff;
        }

        .bar1 {
            fill: steelblue;
        }

        .bar2 {
            fill: orange;
        }
    </style>
</asp:Content>
<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <div id="tabs" style="width: 1500pt; margin-left: 0px;">
        <h3 style="text-align:center; margin-bottom:10px;">Журнал верификации закупленной продукции</h3>
        <ul>
            <li><a href="#tabs-1">Данные</a></li>
            <li><a href="#tabs-2">Фильтр</a></li>
            <li><a href="#tabs-3">Отчет по Деталям</a></li>
            <li><a href="#tabs-4">Отчет по Поставщикам</a></li>
        </ul>
        <div id="tabs-1">
            <asp:GridView ID="GridViewData" runat="server" AutoGenerateColumns="False" BorderStyle="Solid" BorderWidth="1px" CssClass="cgrid" PageSize="50" EnableViewState="False">
                <Columns>
                    <asp:BoundField HeaderText="Вх.№" DataField="jii_num" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <%--<asp:BoundField HeaderText="Дата оприходования" DataField="DateRecord" DataFormatString="{0:dd.MM.yyyy}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />--%>
                    <asp:BoundField HeaderText="Дата передачи на ВК" DataField="DateTransfer" DataFormatString="{0:dd.MM.yyyy}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="Дата проведения ВК" DataField="DerDateAccept" DataFormatString="{0:dd.MM.yyyy}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="Изделие" DataField="Item" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="Наименование" DataField="Description" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="Партия" DataField="Lot" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="Признак" DataField="Kind" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <%--<asp:BoundField HeaderText="Тема НИОКР" DataField="TemaNIOKR" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />--%>
                    <asp:TemplateField HeaderText="Повторное предъявление" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol">
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# (DataBinder.Eval(Container.DataItem, "Repeated").ToString()=="1") ? "Да": "" %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Источник" DataField="DocumentIncom" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolnw" />
                    <asp:BoundField HeaderText="Номер документа" DataField="DerDocumentNum" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="Получено" DataField="Qty" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="Е/И" DataField="UM" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="Принято" DataField="DerQtyAccepted" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="Брак" DataField="DerQtyScrapped" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="% брака" DataField="DerScrapPercent" DataFormatString="{0:G3}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="Склад" DataField="whse" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="МС" DataField="RcvLoc" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolnw" />
                    <asp:BoundField HeaderText="поток ВК" DataField="RcvName" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="Входное АНП" DataField="AnpNum" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="Выходное АНП" DataField="AnpScrap" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="Поставщик" DataField="VendName" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="Контролер" DataField="CheckerName" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="Примечание" DataField="Note" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                </Columns>
            </asp:GridView>
        </div>
        <div id="tabs-2">
            <table style="background-color: ButtonFace;">
                <tr>
                    <td colspan="6">&nbsp;</td>
                    <td colspan="3"  class="tdcntr">Фильтр для указания периода сравнения</td>
                </tr>
                <%--<tr>
                    <td>Дата оприходования</td>
                    <td class="TDLabel1">с</td>
                    <td>
                        <asp:TextBox ID="DateRecordFrom" runat="server" CssClass="datefield"></asp:TextBox>
                    </td>
                    <td class="TDLabel1">по</td>
                    <td>
                        <asp:TextBox ID="DateRecordTo" runat="server" CssClass="datefield"></asp:TextBox>
                    </td>
                    <td class="TDLabel1">с</td>
                    <td>
                        <asp:TextBox ID="DateRecordFrom2" runat="server" CssClass="datefield"></asp:TextBox>
                    </td>
                    <td class="TDLabel1">по</td>
                    <td>
                        <asp:TextBox ID="DateRecordTo2" runat="server" CssClass="datefield"></asp:TextBox>
                    </td>
                </tr>--%>

                <tr>
                    <td>Дата передачи на ВК</td>
                    <td class="TDLabel1">с</td>
                    <td>
                        <asp:TextBox ID="DateTransferFrom" runat="server" CssClass="datefield"></asp:TextBox>
                    </td>
                    <td class="TDLabel1">по</td>
                    <td>
                        <asp:TextBox ID="DateTransferTo" runat="server" CssClass="datefield"></asp:TextBox>
                    </td>
                    <td class="TDLabel1">с</td>
                    <td>
                        <asp:TextBox ID="DateTransferFrom2" runat="server" CssClass="datefield"></asp:TextBox>
                    </td>
                    <td class="TDLabel1">по</td>
                    <td>
                        <asp:TextBox ID="DateTransferTo2" runat="server" CssClass="datefield"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td>Дата проведения ВК</td>
                    <td class="TDLabel1">с</td>
                    <td>
                        <asp:TextBox ID="DateAcceptFrom" runat="server" CssClass="datefield"></asp:TextBox>
                    </td>
                    <td class="TDLabel1">по</td>
                    <td>
                        <asp:TextBox ID="DateAcceptTo" runat="server" CssClass="datefield"></asp:TextBox>
                    </td>
                    <td class="TDLabel1">с</td>
                    <td>
                        <asp:TextBox ID="DateAcceptFrom2" runat="server" CssClass="datefield"></asp:TextBox>
                    </td>
                    <td class="TDLabel1">по</td>
                    <td>
                        <asp:TextBox ID="DateAcceptTo2" runat="server" CssClass="datefield"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td colspan="2">Изделие</td>
                    <td colspan="3">
                        <asp:TextBox ID="Item" runat="server" Style="width: 100%;"></asp:TextBox>
                    </td>
                    <td colspan="4" rowspan="10">&nbsp;</td>
                </tr>

                <tr>
                    <td colspan="2">Наименование</td>
                    <td colspan="3">
                        <asp:TextBox ID="Description" runat="server" Style="width: 100%;"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td colspan="2">Единицы измерения</td>
                    <td colspan="3">
                        <asp:DropDownList ID="UMs" runat="server" Style="width: 100%;"></asp:DropDownList>
                    </td>
                </tr>

                <tr>
                    <td colspan="2">Повторное предъявление</td>
                    <td colspan="3">
                        <asp:DropDownList ID="Repeated" runat="server" Style="width: 100%;"></asp:DropDownList>
                    </td>
                </tr>

                <tr>
                    <td colspan="2">Тема НИОКР</td>
                    <td colspan="3">
                        <asp:DropDownList ID="TemaNIOKR" runat="server" Style="width: 100%;"></asp:DropDownList>
                    </td>
                </tr>

                <tr>
                    <td colspan="2">Имя</td>
                    <td colspan="3">
                        <asp:TextBox ID="Vend" runat="server" Style="width: 100%;"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td colspan="2">Поставщик или Имя</td>
                    <td colspan="3">
                        <asp:DropDownList ID="VendN" runat="server" Style="width: 100%;"></asp:DropDownList>
                    </td>
                </tr>

                <tr>
                    <td colspan="2">Контролер</td>
                    <td colspan="3">
                        <asp:DropDownList ID="Checker" runat="server" Style="width: 100%;"></asp:DropDownList>
                    </td>
                </tr>

                <tr>
                    <td colspan="2">Брак</td>
                    <td colspan="3">
                        <asp:DropDownList ID="Scrap" runat="server" Style="width: 100%;"></asp:DropDownList>
                    </td>
                </tr>

                <tr>
                    <td colspan="2">Партия</td>
                    <td colspan="3">
                        <asp:TextBox ID="Lot" runat="server" Style="width: 100%;"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td colspan="2">Показывать</td>
                    <td colspan="3">
                        <asp:DropDownList ID="ShowTo" runat="server" Style="width: 100%;"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td colspan="9">
                        <table class="centered">
                            <tr>
                                <td colspan="3"  class="tdcntr">
                                    <h4>Показывать только поток ВК</h4>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <asp:CheckBox ID="cbShowOnlyLocQCD" runat="server" CssClass="CheckBoxFilter" Text="ОТК" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <asp:CheckBox ID="cbShowOnlyLocWork" runat="server" CssClass="CheckBoxFilter" Text="Производство" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <hr />
                                </td>
                            </tr>

                            <tr>
                                <td colspan="3"  class="tdcntr">
                                    <h4>Показывать только ждущие обработки</h4>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:CheckBox ID="cbWaitWork" runat="server" CssClass="CheckBoxFilter" Text="Ждущие проведения ВК более" />
                                </td>
                                <td>
                                    <asp:TextBox ID="tbWaitWork" runat="server" CssClass="TextBoxFilter" Text="3" MaxLength="3" />
                                    <asp:RangeValidator ID="vWaitWork" runat="server" ControlToValidate="tbWaitWork" 
                                        MinimumValue="0" MaximumValue="999" Type="Integer"
                                        ErrorMessage="укажите целое положительное число рабочих дней, ждущих проведение ВК изделий" Display="Dynamic" SetFocusOnError="true">!
                                    </asp:RangeValidator>
                                </td>
                                <td>рабочих дней</td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:CheckBox ID="cbWaitANP" runat="server" CssClass="CheckBoxFilter" Text="Ждущие отработки задачи по АНП более" />
                                </td>
                                <td>
                                    <asp:TextBox ID="tbWaitANP" runat="server" CssClass="TextBoxFilter" Text="3" MaxLength="3" />
                                    <asp:RangeValidator ID="vWaitANP" runat="server" ControlToValidate="tbWaitANP" 
                                        MinimumValue="0" MaximumValue="999" Type="Integer"
                                        ErrorMessage="укажите целое положительное число рабочих дней, ждущих обработки АНП изделий" Display="Dynamic" SetFocusOnError="true">!
                                    </asp:RangeValidator>
                                </td>
                                <td>рабочих дней</td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <hr />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>

                <tr style="margin-top:10px;">
                    <td colspan="9" class="tdcntr">
                        <asp:Button ID="ApplyFilter" runat="server" Text="Применить" />&nbsp;&nbsp;&nbsp;
                        <input type="button" id="btnExport3" value="Экспорт в Excel" onclick="GetParamAndExport()" /> 
                        <a style ="font-size: 10px; font-family:Arial, sans-serif; vertical-align:super " href ="http://int-srv/Help/HelpExcel/HelpExcel.html">Настройка экспорта</a>
                    </td>
                </tr>
            </table>
            <asp:ValidationSummary runat="server" ID="Summary" DisplayMode="BulletList"
                HeaderText="Пожалуйста, исправьте следующие ошибки:" ShowSummary="true" ShowMessageBox="true" />
        </div>
        <div id="tabs-3">
            <asp:GridView ID="GridViewDataDetails" runat="server" AutoGenerateColumns="False" BorderStyle="Solid" BorderWidth="1px" CssClass="cgrid" PageSize="50" EnableViewState="False">
                <Columns>
                    <asp:BoundField HeaderText="период" DataField="rangeTransfer" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="предъявлений" DataField="presentation" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="повторных предъявлений" DataField="repeated" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="кол-во АНП" DataField="AnpQty" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="предъявлено" DataField="produced" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="принято" DataField="accepted" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="забраковано" DataField="rejected" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="% брака" DataField="scrapedPercent" DataFormatString="{0:G3}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="возврат поставщику" DataField="returned" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="доработка на участке" DataField="reworkedWC" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="использование без доработки" DataField="reworkedNot" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="списание" DataField="discarded" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="доработка при сборке" DataField="reworkedAsm" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                </Columns>
            </asp:GridView>
            <br />
            <br />
            <table border="1">
                <tr>
                    <td class="HeaderChart">
                        <asp:Label ID="LabelPie1" runat="server" CssClass="HeaderPie"></asp:Label>
                    </td>
                    <td class="HeaderChart">
                        <asp:Label ID="LabelPie2" runat="server" CssClass="HeaderPie"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td id="pie1">
                        <script type="text/javascript">
                            <%if (dtViewerDetails != null && dtViewerDetails.Rows.Count > 0)
                              {%>
                            var pie1data = [
                                { text: "принято <%= gRmnd100IntField(dtViewerDetails,0,"scrapedPercent") %>%", value: <%= gRmnd100IntField(dtViewerDetails,0,"scrapedPercent") %> },
                                { text: "забраковано <%= gIntField(dtViewerDetails,0,"scrapedPercent") %>%", value: <%= gIntField(dtViewerDetails,0,"scrapedPercent") %> },
                            ];

                            var width = 500,
                                height = 500,
                                radius = Math.min(width, height) / 2;

                            var color = d3.scale.ordinal()
                                .range(["#98abc5", "#a05d56"]);

                            var arc = d3.svg.arc()
                                .outerRadius(radius - 10)
                                .innerRadius(0);

                            var pie = d3.layout.pie()
                                .sort(null)
                                .value(function (d) { return d.value; });

                            var pie1svg = d3.select("#pie1").append("svg")
                                .attr("width", width)
                                .attr("height", height)
                                .attr("id", "pie1id")
                                .append("g")
                                .data(pie1data)
                                .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

                            var g = pie1svg.selectAll(".arc")
                                .data(pie(pie1data))
                                .enter().append("g")
                                .attr("class", "arc");

                            g.append("path")
                                .attr("d", arc)
                                .style("fill", function (d) { return color(d.data.text); });

                            g.append("text")
                                .attr("transform", function (d) { return "translate(" + arc.centroid(d) + ")"; })
                                .attr("dy", ".35em")
                                .style("text-anchor", "middle")
                                .text(function (d) { return d.data.text; });
                            <%}%>
                        </script>
                    </td>
                    <td id="pie2">
                        <script type="text/javascript">
                            <%if (dtViewerDetails != null && dtViewerDetails.Rows.Count > 1)
                              {%>
                            var pie2data = [
                                { text: "принято <%= gRmnd100IntField(dtViewerDetails,1,"scrapedPercent") %>%", value: <%= gRmnd100IntField(dtViewerDetails,1,"scrapedPercent") %> },
                                { text: "забраковано <%= gIntField(dtViewerDetails,1,"scrapedPercent") %>%", value: <%= gIntField(dtViewerDetails,1,"scrapedPercent") %> },
                            ];

                            var width = 500,
                                height = 500,
                                radius = Math.min(width, height) / 2;

                            var color = d3.scale.ordinal()
                                .range(["#98abc5", "#a05d56"]);

                            var arc = d3.svg.arc()
                                .outerRadius(radius - 10)
                                .innerRadius(0);

                            var pie = d3.layout.pie()
                                .sort(null)
                                .value(function (d) { return d.value; });

                            var pie2svg = d3.select("#pie2").append("svg")
                                .attr("width", width)
                                .attr("height", height)
                                .attr("id", "pie2id")
                                .append("g")
                                .data(pie2data)
                                .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

                            var g = pie2svg.selectAll(".arc")
                                .data(pie(pie2data))
                                .enter().append("g")
                                .attr("class", "arc");

                            g.append("path")
                                .attr("d", arc)
                                .style("fill", function (d) { return color(d.data.text); });

                            g.append("text")
                                .attr("transform", function (d) { return "translate(" + arc.centroid(d) + ")"; })
                                .attr("dy", ".35em")
                                .style("text-anchor", "middle")
                                .text(function (d) { return d.data.text; });
                            <%}%>
                        </script>
                    </td>
                </tr>
                <tr>
                    <td class="HeaderChart">
                        <asp:Label ID="LabelBar1" runat="server" CssClass="HeaderPie"></asp:Label>
                    </td>
                    <td class="HeaderChart">
                        <asp:Label ID="LabelBar2" runat="server" CssClass="HeaderPie"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td id="bar1">
                        <script type="text/javascript">
                            <%if (dtViewerDetails != null && dtViewerDetails.Rows.Count > 0)
                              {%>
                            var bar1data = [
                                { text: "возврат поставщику", value: <%= gIntField(dtViewerDetails,0,"returned") %> },
                                { text: "доработка на участке", value: <%= gIntField(dtViewerDetails,0,"reworkedWC") %> },
                                { text: "использование без доработки", value: <%= gIntField(dtViewerDetails,0,"reworkedNot") %> },
                                { text: "списание", value: <%= gIntField(dtViewerDetails,0,"discarded") %> },
                                { text: "доработка при сборке", value: <%= gIntField(dtViewerDetails,0,"reworkedAsm") %> },
                            ];

                            var margin = { top: 20, right: 20, bottom: 100, left: 100 },
                                width = 500 - margin.left - margin.right,
                                height = 500 - margin.top - margin.bottom;

                            var x = d3.scale.ordinal()
                                .rangeRoundBands([0, width], .1);

                            var y = d3.scale.linear()
                                .range([height, 0]);

                            var xAxis = d3.svg.axis()
                                .scale(x)
                                .orient("bottom");

                            var yAxis = d3.svg.axis()
                                .scale(y)
                                .orient("left")
                                .ticks(10);

                            var bar1svg = d3.select("#bar1").append("svg")
                                .attr("width", width + margin.left + margin.right)
                                .attr("height", height + margin.top + margin.bottom)
                                .attr("id", "bar1id")
                                .append("g")
                                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

                            x.domain(bar1data.map(function (d) { return d.text; }));
                            y.domain([0, d3.max(bar1data, function (d) { return d.value; })]);

                            bar1svg.append("g")
                                .attr("class", "x axis")
                                .attr("transform", "translate(0," + height + ")")
                                .call(xAxis)
                                    .selectAll("text")  
                                        .style("text-anchor", "end")
                                        .attr("dx", "-.8em")
                                        .attr("dy", ".15em")
                                        .attr("transform", function(d) { return "rotate(-45)" });

                            bar1svg.append("g")
                                .attr("class", "y axis")
                                .call(yAxis)
                                .append("text")
                                .attr("transform", "rotate(-90)")
                                .attr("y", 6)
                                .attr("dy", ".71em")
                                .style("text-anchor", "end")
                                .text("Количество");

                            bar1svg.selectAll(".bar")
                                .data(bar1data)
                                .enter().append("rect")
                                .attr("class", "bar")
                                .attr("x", function (d) { return x(d.text); })
                                .attr("width", x.rangeBand())
                                .attr("y", function (d) { return y(d.value); })
                                .attr("height", function (d) { return height - y(d.value); })
                                .append("title")
                                .text(function(d) { return d.text + " " + d.value; });

                            <%}%>
                        </script>
                    </td>
                    <td id="bar2">
                        <script type="text/javascript">
                            <%if (dtViewerDetails != null && dtViewerDetails.Rows.Count > 1)
                              {%>
                            var bar2data = [
                                { text: "возврат поставщику", value: <%= gIntField(dtViewerDetails,1,"returned") %> },
                                { text: "доработка на участке", value: <%= gIntField(dtViewerDetails,1,"reworkedWC") %> },
                                { text: "использование без доработки", value: <%= gIntField(dtViewerDetails,1,"reworkedNot") %> },
                                { text: "списание", value: <%= gIntField(dtViewerDetails,1,"discarded") %> },
                                { text: "доработка при сборке", value: <%= gIntField(dtViewerDetails,1,"reworkedAsm") %> },
                            ];

                            var margin = { top: 20, right: 20, bottom: 100, left: 100 },
                                width = 500 - margin.left - margin.right,
                                height = 500 - margin.top - margin.bottom;

                            var x = d3.scale.ordinal()
                                .rangeRoundBands([0, width], .1);

                            var y = d3.scale.linear()
                                .range([height, 0]);

                            var xAxis = d3.svg.axis()
                                .scale(x)
                                .orient("bottom");

                            var yAxis = d3.svg.axis()
                                .scale(y)
                                .orient("left")
                                .ticks(10);

                            var bar2svg = d3.select("#bar2").append("svg")
                                .attr("width", width + margin.left + margin.right)
                                .attr("height", height + margin.top + margin.bottom)
                                .attr("id", "bar2id")
                                .append("g")
                                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

                            x.domain(bar2data.map(function (d) { return d.text; }));
                            y.domain([0, d3.max(bar2data, function (d) { return d.value; })]);

                            bar2svg.append("g")
                                .attr("class", "x axis")
                                .attr("transform", "translate(0," + height + ")")
                                .call(xAxis)
                                .selectAll("text")  
                                    .style("text-anchor", "end")
                                    .attr("dx", "-.8em")
                                    .attr("dy", ".15em")
                                    .attr("transform", function(d) { return "rotate(-45)" });

                            bar2svg.append("g")
                                .attr("class", "y axis")
                                .call(yAxis)
                                .append("text")
                                .attr("transform", "rotate(-90)")
                                .attr("y", 6)
                                .attr("dy", ".71em")
                                .style("text-anchor", "end")
                                .text("Количество");

                            bar2svg.selectAll(".bar")
                                .data(bar2data)
                                .enter().append("rect")
                                .attr("class", "bar")
                                .attr("x", function (d) { return x(d.text); })
                                .attr("width", x.rangeBand())
                                .attr("y", function (d) { return y(d.value); })
                                .attr("height", function (d) { return height - y(d.value); })
                                .append("title")
                                .text(function(d) { return d.text + " " + d.value; });

                            <%}%>
                        </script>
                    </td>
                </tr>
            </table>
        </div>
        <div id="tabs-4">
            <asp:Label ID="LabelDataVendors" runat="server" CssClass="HeaderPie"></asp:Label>
            <br />
            <asp:GridView ID="GridViewDataVendors" runat="server" AutoGenerateColumns="False" BorderStyle="Solid" BorderWidth="1px" CssClass="cgrid" PageSize="50" EnableViewState="False">
                <Columns>
                    <asp:BoundField HeaderText="Поставщик" DataField="VendName" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="Предъявлений" DataField="presentation" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="Повторных" DataField="repeated" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="Предъявлено" DataField="produced" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="Забраковано" DataField="rejected" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="% Брака" DataField="scrapedPercent" DataFormatString="{0:G3}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="% Брака НИОКР" DataField="scrapedPercentNIOKR" DataFormatString="{0:G3}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="% Брака без НИОКР" DataField="scrapedPercentWONIOKR" DataFormatString="{0:G3}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                </Columns>
            </asp:GridView>
            <br />
            <br />
            <div id="BarScrapDataVendors">
                <asp:Label ID="BarScrapDataVendorsLabel" runat="server" CssClass="HeaderPie"></asp:Label>
                <br />
                <script type="text/javascript">
                            <%if (dtViewerVendors != null && dtViewerVendors.Rows.Count > 0)
                              {
                            %>
                    var scrap1data = [
                                <%
                                  for (int i = 0; i < dtViewerVendors.Rows.Count; i++)
                                  { 
                                %>
                                    { text: <%= gStrField(dtViewerVendors,i,"VendName") %>, value: <%= gIntField(dtViewerVendors,i,"scrapedPercent") %> },
                                <%
                                  }
                                %>
                            ];

                    var margin = { top: 20, right: 20, bottom: 100, left: 100 },
                        width = 700 - margin.left - margin.right,
                        height = 500 - margin.top - margin.bottom;

                    var x = d3.scale.ordinal()
                        .rangeRoundBands([0, width], .1);

                    var y = d3.scale.linear()
                        .range([height, 0]);

                    var xAxis = d3.svg.axis()
                        .scale(x)
                        .orient("bottom");

                    var yAxis = d3.svg.axis()
                        .scale(y)
                        .orient("left")
                        .ticks(10);

                    var bar1scrap = d3.select("#BarScrapDataVendors").append("svg")
                        .attr("width", width + margin.left + margin.right)
                        .attr("height", height + margin.top + margin.bottom)
                        .attr("id", "bar1scrapid")
                        .append("g")
                        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

                    x.domain(scrap1data.map(function (d) { return d.text; }));
                    y.domain([0, d3.max(scrap1data, function (d) { return d.value; })]);

                    bar1scrap.append("g")
                        .attr("class", "x axis")
                        .attr("transform", "translate(0," + height + ")")
                        .call(xAxis)
                        .selectAll("text")  
                            .style("text-anchor", "end")
                            .attr("dx", "-.8em")
                            .attr("dy", ".15em")
                            .attr("transform", function(d) { return "rotate(-45)" });

                    bar1scrap.append("g")
                        .attr("class", "y axis")
                        .call(yAxis);

                    bar1scrap.selectAll(".bar")
                        .data(scrap1data)
                        .enter().append("rect")
                        .attr("class", "bar")
                        .attr("x", function (d) { return x(d.text); })
                        .attr("width", x.rangeBand())
                        .attr("y", function (d) { return y(d.value); })
                        .attr("height", function (d) { return height - y(d.value); })
                        .append("title")
                        .text(function(d) { return d.text + " " + d.value + "%"; });
                    <%}%>
                </script>
                <br />
                <br />
                <asp:Label ID="BarScrapDataVendorsPartLabel" runat="server" CssClass="HeaderPie"></asp:Label>
                <br />
                <script type="text/javascript">
                            <%if (dtViewerVendors != null && dtViewerVendors.Rows.Count > 0)
                              {
                            %>
                    var scrap1data2 = [
                                <%
                                  for (int i = 0; i < dtViewerVendors.Rows.Count; i++)
                                  { 
                                %>
                                    { text: <%= gStrField(dtViewerVendors,i,"VendName") %>, 
                                        produced: <%= gIntField(dtViewerVendors,i,"produced") %>, 
                                        rejected: <%= gIntField(dtViewerVendors,i,"rejected") %> },
                                <%
                                  }
                                %>
                            ];

                    var margin = { top: 20, right: 20, bottom: 100, left: 100 },
                        width = 700 - margin.left - margin.right,
                        height = 500 - margin.top - margin.bottom;

                    var x = d3.scale.ordinal()
                        .rangeRoundBands([0, width], .1);

                    var y = d3.scale.linear()//log()//linear()
                        .range([height, 0]);

                    var xAxis = d3.svg.axis()
                        .scale(x)
                        .orient("bottom");

                    var yAxis = d3.svg.axis()
                        .scale(y)
                        .orient("left")
                        //linear()
                        .ticks(10);
                    //log()
                    //.ticks(15,"");


                    var bar1scrap2 = d3.select("#BarScrapDataVendors").append("svg")
                        .attr("width", width + margin.left + margin.right)
                        .attr("height", height + margin.top + margin.bottom)
                        .append("g")
                        .attr("class", "graph")
                        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

                    x.domain(scrap1data2.map(function (d) { return d.text; }));
                    //linear()
                    y.domain([0, d3.max(scrap1data2, function (d) { return d3.max([d.rejected, d.produced]); } )]);
                    //log()
                    //y.domain([0.9, d3.max(scrap1data2, function (d) { return d3.max([d.rejected, d.produced]); } )]);


                    bar1scrap2.append("g")
                        .attr("class", "x axis")
                        .attr("transform", "translate(0," + height + ")")
                        .call(xAxis)
                        .selectAll("text")  
                            .style("text-anchor", "end")
                            .attr("dx", "-.8em")
                            .attr("dy", ".15em")
                            .attr("transform", function(d) { return "rotate(-45)" });

                    bar1scrap2.append("g")
                        .attr("class", "y axis")
                        .call(yAxis);

                    var bars1 = bar1scrap2.selectAll(".bar").data(scrap1data2).enter();

                    bars1.append("rect")
                        .attr("class", "bar1")
                        .attr("x", function(d) { return x(d.text); })
                        .attr("width", x.rangeBand()/2)
                        .attr("y", function(d) { return y(d.produced); })
                        .attr("height", function(d,i,j) { return height - y(d.produced); })
                        .append("title")
                        .text(function(d) { return d.text + " - предъявлено " + d.produced; });

                    bars1.append("rect")
                        .attr("class", "bar2")
                        .attr("x", function(d) { return x(d.text) + x.rangeBand()/2; })
                        .attr("width", x.rangeBand() / 2)
                        .attr("y", function(d) { return y(d.rejected); })
                        .attr("height", function(d,i,j) { return height - y(d.rejected); })
                        .append("title")
                        .text(function(d) { return d.text + " - забраковано " + d.rejected; });
                    <%}%>
                </script>
            </div>
            <asp:Label ID="LabelDataVendors2" runat="server" CssClass="HeaderPie"></asp:Label>
            <br />
            <asp:GridView ID="GridViewDataVendors2" runat="server" AutoGenerateColumns="False" BorderStyle="Solid" BorderWidth="1px" CssClass="cgrid" PageSize="50" EnableViewState="False">
                <Columns>
                    <asp:BoundField HeaderText="Поставщик" DataField="VendName" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="Предъявлений" DataField="presentation" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="Повторных" DataField="repeated" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="Предъявлено" DataField="produced" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="Забраковано" DataField="rejected" DataFormatString="{0:G0}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="% Брака" DataField="scrapedPercent" DataFormatString="{0:G3}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="% Брака НИОКР" DataField="scrapedPercentNIOKR" DataFormatString="{0:G3}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                    <asp:BoundField HeaderText="% Брака без НИОКР" DataField="scrapedPercentWONIOKR" DataFormatString="{0:G3}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolrt" />
                </Columns>
            </asp:GridView>
            <br />
            <br />
            <div id="BarScrapDataVendors2">
                <asp:Label ID="BarScrapDataVendorsLabel2" runat="server" CssClass="HeaderPie"></asp:Label>
                <br />
                <script type="text/javascript">
                            <%if (dtViewerVendors2 != null && dtViewerVendors2.Rows.Count > 0)
                              {
                            %>
                    var scrap2data = [
                                <%
                                  for (int i = 0; i < dtViewerVendors2.Rows.Count; i++)
                                  { 
                                %>
                                    { text: <%= gStrField(dtViewerVendors2,i,"VendName") %>, value: <%= gIntField(dtViewerVendors2,i,"scrapedPercent") %> },
                                <%
                                  }
                                %>
                            ];

                    var margin = { top: 20, right: 20, bottom: 100, left: 100 },
                        width = 700 - margin.left - margin.right,
                        height = 500 - margin.top - margin.bottom;

                    var x = d3.scale.ordinal()
                        .rangeRoundBands([0, width], .1);

                    var y = d3.scale.linear()
                        .range([height, 0]);

                    var xAxis = d3.svg.axis()
                        .scale(x)
                        .orient("bottom");

                    var yAxis = d3.svg.axis()
                        .scale(y)
                        .orient("left")
                        .ticks(10);

                    var bar2scrap = d3.select("#BarScrapDataVendors2").append("svg")
                        .attr("width", width + margin.left + margin.right)
                        .attr("height", height + margin.top + margin.bottom)
                        .attr("id", "bar2scrapid")
                        .append("g")
                        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

                    x.domain(scrap2data.map(function (d) { return d.text; }));
                    y.domain([0, d3.max(scrap2data, function (d) { return d.value; })]);

                    bar2scrap.append("g")
                        .attr("class", "x axis")
                        .attr("transform", "translate(0," + height + ")")
                        .call(xAxis)
                        .selectAll("text")  
                            .style("text-anchor", "end")
                            .attr("dx", "-.8em")
                            .attr("dy", ".15em")
                            .attr("transform", function(d) { return "rotate(-45)" });

                    bar2scrap.append("g")
                        .attr("class", "y axis")
                        .call(yAxis);

                    bar2scrap.selectAll(".bar")
                        .data(scrap2data)
                        .enter().append("rect")
                        .attr("class", "bar")
                        .attr("x", function (d) { return x(d.text); })
                        .attr("width", x.rangeBand())
                        .attr("y", function (d) { return y(d.value); })
                        .attr("height", function (d) { return height - y(d.value); })
                        .append("title")
                        .text(function(d) { return d.text + " " + d.value + "%"; });
                    <%}%>
                </script>
                <br />
                <br />
                <asp:Label ID="BarScrapDataVendorsPartLabel2" runat="server" CssClass="HeaderPie"></asp:Label>
                <br />
                <script type="text/javascript">
                            <%if (dtViewerVendors2 != null && dtViewerVendors2.Rows.Count > 0)
                              {
                            %>
                    var scrap2data2 = [
                                <%
                                  for (int i = 0; i < dtViewerVendors2.Rows.Count; i++)
                                  { 
                                %>
                                    { text: <%= gStrField(dtViewerVendors2,i,"VendName") %>, 
                                        produced: <%= gIntField(dtViewerVendors2,i,"produced") %>, 
                                        rejected: <%= gIntField(dtViewerVendors2,i,"rejected") %> },
                                <%
                                  }
                                %>
                            ];

                    var margin = { top: 20, right: 20, bottom: 100, left: 100 },
                        width = 700 - margin.left - margin.right,
                        height = 500 - margin.top - margin.bottom;

                    var x = d3.scale.ordinal()
                        .rangeRoundBands([0, width], .1);

                    var y = d3.scale.linear()
                        .range([height, 0]);

                    var xAxis = d3.svg.axis()
                        .scale(x)
                        .orient("bottom");

                    var yAxis = d3.svg.axis()
                        .scale(y)
                        .orient("left")
                        .ticks(10);

                    var bar2scrap2 = d3.select("#BarScrapDataVendors2").append("svg")
                        .attr("width", width + margin.left + margin.right)
                        .attr("height", height + margin.top + margin.bottom)
                        .append("g")
                        .attr("class", "graph")
                        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

                    x.domain(scrap2data2.map(function (d) { return d.text; }));
                    y.domain([0, d3.max(scrap2data2, function (d) { return d3.max([d.rejected, d.produced]); } )]);


                    bar2scrap2.append("g")
                        .attr("class", "x axis")
                        .attr("transform", "translate(0," + height + ")")
                        .call(xAxis)
                        .selectAll("text")  
                            .style("text-anchor", "end")
                            .attr("dx", "-.8em")
                            .attr("dy", ".15em")
                            .attr("transform", function(d) { return "rotate(-45)" });

                    bar2scrap2.append("g")
                        .attr("class", "y axis")
                        .call(yAxis);

                    var bars2 = bar2scrap2.selectAll(".bar").data(scrap2data2).enter();

                    bars2.append("rect")
                        .attr("class", "bar1")
                        .attr("x", function(d) { return x(d.text); })
                        .attr("width", x.rangeBand()/2)
                        .attr("y", function(d) { return y(d.produced); })
                        .attr("height", function(d,i,j) { return height - y(d.produced); })
                        .append("title")
                        .text(function(d) { return d.text + " - предъявлено " + d.produced; });

                    bars2.append("rect")
                        .attr("class", "bar2")
                        .attr("x", function(d) { return x(d.text) + x.rangeBand()/2; })
                        .attr("width", x.rangeBand() / 2)
                        .attr("y", function(d) { return y(d.rejected); })
                        .attr("height", function(d,i,j) { return height - y(d.rejected); })
                        .append("title")
                        .text(function(d) { return d.text + " - забраковано " + d.rejected; });
                    <%}%>
                </script>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $("#tabs").tabs({ cookie: { expires: 1 } });

        $("#ApplyFilter").button();
        $("#btnExport").button();
    </script>
</asp:Content>
