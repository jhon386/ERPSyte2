using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;

namespace ERPSyte2.Classes
{
    public class dbSafeConvert
    {
        public static string GetString(SqlDataReader AReader, string AFieldName)
        {
            int colIndex = AReader.GetOrdinal(AFieldName);
            if (!AReader.IsDBNull(colIndex))
                return AReader.GetString(colIndex);
            else
                return string.Empty;
        }

        public static int? GetInt32(SqlDataReader AReader, string AFieldName)
        {
            int colIndex = AReader.GetOrdinal(AFieldName);
            if (!AReader.IsDBNull(colIndex))
                return AReader.GetInt32(colIndex);
            else
                return null;
        }

        public static DateTime? GetDateTime(SqlDataReader AReader, string AFieldName)
        {
            int colIndex = AReader.GetOrdinal(AFieldName);
            if (!AReader.IsDBNull(colIndex))
                return AReader.GetDateTime(colIndex);
            else
                return null;
        }

        public static byte? GetByte(SqlDataReader AReader, string AFieldName)
        {
            int colIndex = AReader.GetOrdinal(AFieldName);
            if (!AReader.IsDBNull(colIndex))
                return AReader.GetByte(colIndex);
            else
                return null;
        }

        public static bool? GetBoolean(SqlDataReader AReader, string AFieldName)
        {
            int colIndex = AReader.GetOrdinal(AFieldName);
            if (!AReader.IsDBNull(colIndex))
                return AReader.GetBoolean(colIndex);
            else
                return null;
        }

    }
}