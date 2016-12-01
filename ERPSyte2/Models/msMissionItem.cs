using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace ERPSyte2.Models
{
    public class msMissionItem
    {
        //переделать хранилище на таблицу тк может быть несколько строк мест назначения
        public int iditem { get; set; }
        public int idmission { get; set; }
        public string tName  { get; set; }
        public string tplace  { get; set; }
        public int tplaceid { get; set; }
        public string jobname { get; set; }
        public DateTime? fromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public string pribor { get; set; }
        public string n_pribor { get; set; }
        public string dogovor { get; set; }
        public int montage { get; set; }
        public DateTime? fktFromdate { get; set; }
        public DateTime? fktToDate { get; set; }
        public bool? InHoliday { get; set; }
        public bool? wasNotTrip { get; set; }
        public bool? hasDebt { get; set; }
        public bool? modified { get; set; }
        public string Activity_intlst { get; set; }
        public string Activity_strlst { get; set; }
        public string Region_intlst { get; set; }
        public string Region_strlst { get; set; }
        public string tRegion { get; set; }

        internal void Load(int AIDMission)
        {
            using (SqlConnection con = new SqlConnection(dbCon.csMS2))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("ms_MissionsItem", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@idmission", SqlDbType.Int).Value = AIDMission;
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
/*
                        while (rdr.Read())
                        {
                            iditem = 
                            idmission =
                            tName =
                            tplace =
                            tplaceid =
                            jobname =
                            fromDate =
                            ToDate =
                            pribor =
                            n_pribor =
                            dogovor =
                            montage =
                            fktFromdate =
                            fktToDate =
                            InHoliday =
                            wasNotTrip =
                            hasDebt =
                            modified =
                            Activity_intlst =
                            Activity_strlst =
                            Region_intlst =
                            Region_strlst =
                            tRegion =

                        }
*/
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