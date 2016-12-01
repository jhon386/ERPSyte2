using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Security.Principal;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.Text;
using System.Configuration;
using System.Web;
using System.Web.Configuration;
using System.ServiceModel.Configuration;


namespace ErpWcfService2
{
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class ErpWcfService : IErpWcfService
    {
        public string GetData(int value)
        {
            return string.Format("You entered: {0}", value);
        }

        public CompositeType GetDataUsingDataContract(CompositeType composite)
        {
            if (composite == null)
            {
                throw new ArgumentNullException("composite");
            }
            if (composite.BoolValue)
            {
                composite.StringValue += "Suffix";
            }
            return composite;
        }

        public string WhoIAm()
        {
            return WindowsIdentity.GetCurrent().Name;
        }

        [OperationBehavior(Impersonation = ImpersonationOption.Required)]
        public string WhoIAm2()
        {
            return WindowsIdentity.GetCurrent().Name;
        }

        public string Hello(string greeting)
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendFormat("[From Bar Service] You said: { 0}\r\n", greeting);

            // Working with AppSettings
            sb.AppendFormat("Bob likes the fruit '{ 0}'\r\n", ConfigurationManager.AppSettings["Fruit"]);
            sb.AppendFormat("He also likes the cookie '{ 0}'\r\n", ConfigurationManager.AppSettings["Cookie"]);

            //// Working with other config data
            //BindingsSectionGroup bsg = (BindingsSectionGroup)ConfigurationManager.GetSection("system.serviceModel / bindings");

            //foreach (BasicHttpBindingElement be in bsg.BasicHttpBinding.Bindings)
            //    sb.AppendFormat("Binding: { 0}, MaxReceivedMessageSize: { 1}\r\n", be.Name, be.MaxReceivedMessageSize);

            // Working with Session state
            int myCount = 0;
            if (HttpContext.Current.Session["MyCount"] != null)
                myCount = (int)HttpContext.Current.Session["MyCount"];

            HttpContext.Current.Session["MyCount"] = ++myCount;
            sb.AppendFormat("MyCount is '{ 0}'\r\n", myCount);

            return sb.ToString();
        }

    }
}
