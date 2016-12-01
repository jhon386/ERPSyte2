<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserIdentity.aspx.cs" Inherits="ERPSyte2.WebIdentity" MasterPageFile="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="head" runat="server" ID="HeadContent">

</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server" ID="BodyContent" >
    <p>
        user:&nbsp;
        <asp:Label ID="tbUser" runat="server" />
        <br />
        <a href="Internal/Missions.aspx">Missions</a>
    </p>
</asp:Content>