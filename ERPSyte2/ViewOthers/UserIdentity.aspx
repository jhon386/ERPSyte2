<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserIdentity.aspx.cs" Inherits="ERPSyte2.ViewOthers.WebIdentity" MasterPageFile="~/ViewOthers/Site.Master" %>

<asp:Content ContentPlaceHolderID="head" runat="server" ID="HeadContent">

</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server" ID="BodyContent" >
    <p>
        user:&nbsp;
        <asp:Label ID="tbUser" runat="server" />
        <br />
        <a href="../Internal/Mission.aspx">Missions</a>
    </p>
</asp:Content>