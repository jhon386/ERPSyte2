using System;
using System.Collections.Generic;
using System.IO;
using System.Web;

namespace ERPSyte2.Classes
{
    public class LogonUserText
    {
        internal static void SaveToFile(HttpResponse AResponse, HttpRequest ARequest)
        {
            //http://msdn.microsoft.com/en-us/library/system.web.httprequest.logonuseridentity.aspx
            // Validate that user is authenticated
            //if (!Request.LogonUserIdentity.IsAuthenticated)
            //    Response.Redirect("LoginPage.aspx");

            // Create a string that contains the file path
            string INFO_DIR = @"d:\temp\";
            string strFilePath = INFO_DIR + "CS_Log2.txt";

            AResponse.Write("Writing log file to " + strFilePath + "...");

            // Create stream writer object and pass it the file path
            StreamWriter sw = File.CreateText(strFilePath);

            // Write user info to log
            sw.WriteLine("Access log from " + DateTime.Now.ToString());
            sw.WriteLine("AuthenticationType: " + ARequest.LogonUserIdentity.AuthenticationType);
            sw.WriteLine("Groups: " + ARequest.LogonUserIdentity.Groups);
            sw.WriteLine("ImpersonationLevel: " + ARequest.LogonUserIdentity.ImpersonationLevel);
            sw.WriteLine("IsAnonymous: " + ARequest.LogonUserIdentity.IsAnonymous);
            sw.WriteLine("IsAuthenticated: " + ARequest.LogonUserIdentity.IsAuthenticated);
            sw.WriteLine("IsGuest: " + ARequest.LogonUserIdentity.IsGuest);
            sw.WriteLine("IsSystem: " + ARequest.LogonUserIdentity.IsSystem);
            sw.WriteLine("Name: " + ARequest.LogonUserIdentity.Name);
            sw.WriteLine("Owner: " + ARequest.LogonUserIdentity.Owner);
            sw.WriteLine("Token: " + ARequest.LogonUserIdentity.Token);
            sw.WriteLine("User: " + ARequest.LogonUserIdentity.User);

            // Close the stream to the file.
            sw.Close();
        }
    }
}