using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Web;
using ERPSyte2.Classes;

namespace ERPSyte2.Models
{
    public class msMission
    {
        public int idmission { get; set; }
        public int? accept { get; set; } 
        public int? missioner { get; set; }
        public string Num_kom { get; set; } //varchar(7)
        public DateTime? cur_date { get; set; }
        public DateTime? fromdate { get; set; }
        public DateTime? todate { get; set; }
        public bool? SelfOrganization { get; set; }
        public int? maker { get; set; }
        public DateTime? fktFromDate { get; set; }
        public DateTime? fktToDate { get; set; }
        public byte? arch { get; set; }
        public string archprim { get; set; } //varchar(250)
        public string NAMES { get; set; } //varchar(500)
        public string TARGETS { get; set; } //varchar(500)
        public string PLACES { get; set; } //varchar(500)
        public int? Asserter { get; set; }
        public bool? NeedForPass { get; set; }
        public bool? NeedForPassOld { get; set; }
        public bool? NeedInsur { get; set; }
        public bool? NeedVisa { get; set; }
        public bool? BT { get; set; }
        public bool? hasNeeds { get; set; }
        public bool? hasDebt { get; set; }
        public string missioner_text { get; set; } //varchar(64)
        public string asserter_text { get; set; } //varchar(64)

        internal void Load(int AIDMission)
        {
            idmission = AIDMission;
            using (SqlConnection con = new SqlConnection(dbCon.csMS2))
            {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("ms_Missions", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add("@ID", SqlDbType.Int).Value = idmission;
                        using (SqlDataReader rdr = cmd.ExecuteReader())
                        {
                            if (rdr.Read())
                            {
                                accept = dbSafeConvert.GetInt32(rdr, "accept");
                                missioner = dbSafeConvert.GetInt32(rdr, "missioner");
                                Num_kom = dbSafeConvert.GetString(rdr, "Num_kom");
                                cur_date = dbSafeConvert.GetDateTime(rdr, "cur_date");
                                fromdate = dbSafeConvert.GetDateTime(rdr, "fromdate");
                                todate = dbSafeConvert.GetDateTime(rdr, "todate");
                                SelfOrganization = dbSafeConvert.GetBoolean(rdr, "SelfOrganization");
                                maker = dbSafeConvert.GetInt32(rdr, "maker");
                                fktFromDate = dbSafeConvert.GetDateTime(rdr, "fktFromDate");
                                fktToDate = dbSafeConvert.GetDateTime(rdr, "fktToDate");
                                arch = dbSafeConvert.GetByte(rdr, "arch");
                                archprim = dbSafeConvert.GetString(rdr, "archprim");
                                NAMES = dbSafeConvert.GetString(rdr, "NAMES");
                                TARGETS = dbSafeConvert.GetString(rdr, "TARGETS");
                                PLACES = dbSafeConvert.GetString(rdr, "PLACES");
                                Asserter = dbSafeConvert.GetInt32(rdr, "Asserter");
                                NeedForPass = dbSafeConvert.GetBoolean(rdr, "NeedForPass");
                                NeedForPassOld = dbSafeConvert.GetBoolean(rdr, "NeedForPassOld");
                                NeedInsur = dbSafeConvert.GetBoolean(rdr, "NeedInsur");
                                NeedVisa = dbSafeConvert.GetBoolean(rdr, "NeedVisa");
                                BT = dbSafeConvert.GetBoolean(rdr, "BT");
                                hasNeeds = dbSafeConvert.GetBoolean(rdr, "hasNeeds");
                                hasDebt = dbSafeConvert.GetBoolean(rdr, "hasDebt");
                                missioner_text = dbSafeConvert.GetString(rdr, "missioner_text");
                                asserter_text = dbSafeConvert.GetString(rdr, "asserter_text"); 
                            }

                            if (rdr != null && !rdr.IsClosed)
                                rdr.Close();
                        }
                        if (cmd != null)
                            cmd.Dispose();
                    }
                    if (con != null && con.State == ConnectionState.Open)
                        con.Close();

            }
        }
    }
}