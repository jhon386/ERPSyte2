<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Missions.aspx.cs" Inherits="ERPSyte2.Internal.Missions" MasterPageFile="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="head" runat="server" ID="HeadContent">
    <link type="text/css" rel="Stylesheet" href="../Content/themes/base/jquery-ui.css" />
    <script type="text/javascript" src="../Scripts/jquery-1.6.4.min.js"></script>
    <script type="text/javascript" src="../Scripts/jquery-ui-1.10.4.min.js"></script>
    <script type="text/javascript" src="../Scripts/DatePickerReady.js"></script>
    <script type="text/javascript">
        function GetParamAndExport() {
            alert("GetParamAndExport");
        }
    </script>
    <style type="text/css">
        .hide {
            display: none;
        }

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
<asp:Content ContentPlaceHolderID="MainContent" runat="server" ID="BodyContent">
    <div id="tabs" style="width: auto; margin-left: 0px;">
        <ul>
            <li><a href="#tabs-1">Данные</a></li>
            <li><a href="#tabs-2">Фильтр</a></li>
        </ul>
        <div id="tabs-1">
            <asp:GridView ID="GridData" runat="server" AutoGenerateColumns="False" BorderStyle="Solid" BorderWidth="1px" CssClass="cgrid" PageSize="50" EnableViewState="False" AutoGenerateEditButton="False" OnRowDataBound="GridData_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="idmission" ItemStyle-CssClass="hide" />
                    <asp:BoundField HeaderText="Номер" DataField="NUM_KOM" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="Начало" DataField="FROMDATE" DataFormatString="{0:dd.MM.yyyy}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="Окончание" DataField="TODATE" DataFormatString="{0:dd.MM.yyyy}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="Сотрудник" DataField="NAMES" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol300" />
                    <asp:BoundField HeaderText="Создано" DataField="CUR_DATE" DataFormatString="{0:dd.MM.yyyy}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="Цель" DataField="TARGETS" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol300" />
                    <asp:BoundField HeaderText="Место" DataField="PLACES" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol300" />
                    <asp:BoundField HeaderText="Примечание" DataField="ARCHPRIM" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol300" />
                    <asp:TemplateField HeaderText="Документы" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol">
                        <ItemTemplate>
                            <asp:Label ID="LabelhasNeeds" runat="server" Text='<%# (DataBinder.Eval(Container.DataItem, "hasNeeds").ToString()=="True") ? "Да": "" %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Долг" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol">
                        <ItemTemplate>
                            <asp:Label ID="LabelhasDebt" runat="server" Text='<%# (DataBinder.Eval(Container.DataItem, "hasDebt").ToString()=="True") ? "Да": "" %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        <div id="tabs-2">
            <table style="background-color: ButtonFace;">
                <tr>
                    <td>Дата</td>
                    <td class="TDLabel1">с</td>
                    <td>
                        <asp:TextBox ID="FromDate" runat="server" CssClass="datefield"></asp:TextBox>
                    </td>
                    <td class="TDLabel1">по</td>
                    <td>
                        <asp:TextBox ID="ToDate" runat="server" CssClass="datefield"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td>Сотрудник</td>
                    <td colspan="4">
                        <asp:DropDownList ID="cmbUsers" runat="server" Style="width: 100%;"></asp:DropDownList>
                    </td>
                </tr>

                <tr>
                    <td>Город</td>
                    <td colspan="4">
                        <asp:TextBox ID="ePosition" runat="server" Style="width: 100%;"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td colspan="5" class="tdcntr">
                        <asp:Button ID="ApplyFilter" runat="server" Text="Применить" />
                    </td>
                </tr>
                <tr>
                    <td colspan="5" class="tdcntr">
                        <input type="button" id="btnExport3" value="Export To Excel" onclick="GetParamAndExport()" />
                        <a style="font-size: 10px; font-family: Arial, sans-serif; vertical-align: super" href="http://int-srv/Help/HelpExcel/HelpExcel.html">Настройка экспорта</a>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <script type="text/javascript">
        $("#tabs").tabs({ cookie: { expires: 1 } });

        $("#ApplyFilter").button();
        $("#btnExport").button();
    </script>
</asp:Content>