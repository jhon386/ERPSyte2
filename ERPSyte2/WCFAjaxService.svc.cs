using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.Text;

namespace ERPSyte2
{
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class WCFAjaxService : IWCFAjaxService
    {
        // To use HTTP GET, add [WebGet] attribute. (Default ResponseFormat is WebMessageFormat.Json)
        // To create an operation that returns XML,
        //     add [WebGet(ResponseFormat=WebMessageFormat.Xml)],
        //     and include the following line in the operation body:
        //         WebOperationContext.Current.OutgoingResponse.ContentType = "text/xml";
        public void DoWork()
        {
            return;
        }

        public string HelloWorld()
        {
            return "Hello, world!";
        }

        public string Hello(string name)
        {
            return string.Format("Hello: {0}", name);
        }

        public double Add(double n1, double n2)
        {
            return n1 + n2;        
        }
    }

    [ServiceContract(Namespace = "")]
    public interface IWCFAjaxService
    {
        [OperationContract]
        void DoWork();

        [OperationContract]
        [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
        string HelloWorld();

        [OperationContract]
        [WebInvoke(Method ="POST", BodyStyle = WebMessageBodyStyle.Bare, ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        //[WebGet(UriTemplate = "{name}")]
        string Hello(string name);

        [OperationContract]
        [WebInvoke(Method ="POST", BodyStyle =WebMessageBodyStyle.Wrapped, ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        double Add(double n1, double n2);
    }
}
