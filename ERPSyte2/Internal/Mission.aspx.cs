using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ERPSyte2.Internal
{
    public partial class Mission : System.Web.UI.Page
    {
        public Models.msMission obMission = new Models.msMission();

        private void LoadAssertUsers()
        {
            using (SqlConnection con = new SqlConnection(dbCon.csMS2))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("ms_GetAsserters", con))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.Add("@OnlyChecked", SqlDbType.Bit).Value = 1;
                    using (DataSet ds = new DataSet())
                    {
                        da.Fill(ds);
                        asserter.DataSource = ds;
                        asserter.DataTextField = "NAME";
                        asserter.DataValueField = "UID";
                        asserter.DataBind();
                    }
                }
            }
            asserter.Items.Insert(0, "");
        }

        private void LoadUsers()
        {
            using (SqlConnection con = new SqlConnection(dbCon.csMS2))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("ms_UsersList", con))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.Add("@ShowFired", SqlDbType.Bit).Value = 0;
                    using (DataSet ds = new DataSet())
                    {
                        da.Fill(ds);
                        missioner.DataSource = ds;
                        missioner.DataTextField = "name";
                        missioner.DataValueField = "id";
                        missioner.DataBind();
                    }
                }
            }
            missioner.Items.Insert(0, "");
        }

        private void LoadAdmTarget()
        {
            using (SqlConnection con = new SqlConnection(dbCon.csMS2))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("ms_GetAdmTarget", con))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    using (DataSet ds = new DataSet())
                    {
                        da.Fill(ds);
                        jobname.DataSource = ds;
                        jobname.DataTextField = "Target";
                        jobname.DataValueField = "ID";
                        jobname.DataBind();
                    }
                }
            }
            jobname.Items.Insert(0, "");
        }

        private void LoadMission(int AIDMission)
        {
            obMission.Load(AIDMission);
            Title = "Командировка " + obMission.Num_kom;
            missioner.SelectedIndex = missioner.Items.IndexOf(missioner.Items.FindByValue(obMission.missioner.ToString()));
            asserter.SelectedIndex = asserter.Items.IndexOf(asserter.Items.FindByValue(obMission.Asserter.ToString()));
            //jobname.SelectedIndex = jobname.Items.IndexOf(jobname.Items.FindByValue(obMission. Asserter.ToString()));
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int i = 0;
                if (!string.IsNullOrEmpty(Request.QueryString["idmission"]) && Int32.TryParse(Request.QueryString["idmission"], out i))
                {
                    LoadAssertUsers();
                    LoadUsers();
                    LoadAdmTarget();
                    LoadMission(i);
                }
            }
        }
    }
}