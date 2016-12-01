using System;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ERPSyte2
{
    public partial class _Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            hlUserIdentity.Visible = HttpContext.Current.User.IsInRole(Global.gloRoleAdminName);
        }
    }
}