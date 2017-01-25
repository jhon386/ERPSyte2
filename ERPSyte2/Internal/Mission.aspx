<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Mission.aspx.cs" Inherits="ERPSyte2.Internal.Mission" MasterPageFile="~/ViewOthers/Site.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="head" ID="HeadContent">

</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="MainContent" ID="BodyContent">
    <div>
        <table>
            <tr>
                <td>
                    <asp:Label ID="l_missioner" runat="server" Text="Сотрудник:" />
                </td>
                <td>
                    <asp:DropDownList ID="missioner" runat="server" />
                </td>
                <td>
                    <asp:Label ID="l_asserter" runat="server" Text="Утверждающий:" />
                </td>
                <td>
                    <asp:DropDownList ID="asserter" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="l_jobname" runat="server" Text="Вид работ:" />
                </td>
                <td colspan="3">
                    <asp:DropDownList ID="jobname" runat="server" />
                </td>
            </tr>
        </table>
        
    </div>
</asp:Content>