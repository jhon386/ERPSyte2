using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ERPSyte2.Internal
{
    public partial class Missions : System.Web.UI.Page
    {
        protected void Page_PreInit(object sender, EventArgs e) 
        {
            if (!Classes.ERPUser.IsAuthenticated)
                Response.Redirect("../AccessDenied.aspx", true);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Title = "Командировки";

                FromDate.Text = DateTime.Now.AddDays(-7).ToShortDateString();
                ToDate.Text = DateTime.Now.AddDays(7).ToShortDateString();
                ePosition.Text = "";

                int dtpwidth = 150;
                FromDate.Width = dtpwidth;
                ToDate.Width = dtpwidth;

                using (SqlConnection con = new SqlConnection(dbCon.csMS2))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter("ms_UsersList", con))
                    {
                        da.SelectCommand.CommandType = CommandType.StoredProcedure;
                        da.SelectCommand.Parameters.Add("@ShowFired", SqlDbType.Bit).Value = 0;
                        using (DataSet ds = new DataSet())
                        {
                            da.Fill(ds);
                            cmbUsers.DataSource = ds;
                            cmbUsers.DataTextField = "name";
                            cmbUsers.DataValueField = "id";
                            cmbUsers.DataBind();
                        }
                    }
                }

            }

            LoadData();
        }

        protected void LoadData()
        {
            DateTime dFromDate;
            DateTime dToDate;
            string cFromDate = "";
            string cToDate = "";
            if (DateTime.TryParse(FromDate.Text, out dFromDate))
                cFromDate = dFromDate.ToString("dd/MM/yyyy");
            if (DateTime.TryParse(ToDate.Text, out dToDate))
                cToDate = dToDate.ToString("dd/MM/yyyy");

            using (SqlConnection con = new SqlConnection(dbCon.csMS2))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("ms_Missions", con))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.Add("@ID", SqlDbType.Int);
                    da.SelectCommand.Parameters.Add("@ARCH", SqlDbType.SmallInt).Value = null;
                    da.SelectCommand.Parameters.Add("@FROMDATE", SqlDbType.DateTime).Value = cFromDate;
                    da.SelectCommand.Parameters.Add("@TODATE", SqlDbType.DateTime).Value = cToDate;
                    da.SelectCommand.Parameters.Add("@UID", SqlDbType.SmallInt).Value = cmbUsers.SelectedValue;
                    da.SelectCommand.Parameters.Add("@PLACES", SqlDbType.NVarChar, 250).Value = ePosition.Text;
                    using (DataSet ds = new DataSet())
                    {
                        da.Fill(ds);
                        GridData.DataSource = ds;
                        GridData.DataBind();
                    }
                }
            }
        }

        protected void GridData_RowDataBound(object sender, GridViewRowEventArgs e)
        {//http://stackoverflow.com/questions/331231/c-sharp-gridview-row-click

            if (e.Row.RowType == DataControlRowType.Header)
            {
                e.Row.Cells[0].CssClass = "hide";
            }

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor='#ceedfc'");
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor=''");
                e.Row.Attributes.Add("style", "cursor:pointer;");
                e.Row.Attributes.Add("onclick", "location='Mission.aspx?idmission=" + e.Row.Cells[0].Text + "'");
            }
        }
    }
}