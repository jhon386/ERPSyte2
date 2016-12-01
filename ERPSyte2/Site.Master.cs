using System;

namespace ERPSyte2
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                ftUserName.Text = string.Format("{0}: {1}", Classes.ERPUser.UID.ToString(), Classes.ERPUser.Name);
            }

        }
    }
}