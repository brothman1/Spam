using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using SpamApi.Core;
using static SpamApi.Core.UtilityBelt;

namespace SpamApi.Controllers
{
    public class SessionController : ApiController
    {
        [Route("api/Session/{environment}/{domainName}/{domainContainer}/{userId}/{hostName}")]
        [HttpGet]
        public HttpResponseMessage Get(string environment, string domainName, string domainContainer, string userId, string hostName)
        {
            try
            {
                if (environment.TryParseEnum(out SessionEnvironment sessionEnvironment, out _, "None"))
                {
                    Session session = new Session(sessionEnvironment, domainName, domainContainer, userId, hostName);
                    return Request.CreateResponse(HttpStatusCode.OK, session.Id);
                }
                throw new ArgumentException($"{typeof(SessionEnvironment).Name} must be either {GetEnumValues<SessionEnvironment>(",", "or", "None")}");
            }
            catch (Exception e)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, e.Message);
            }
        }
        [Route("api/Session/{environment}/{id:Guid}")]
        [HttpGet]
        public HttpResponseMessage Get(string environment, Guid id)
        {
            try
            {
                if (environment.TryParseEnum(out SessionEnvironment sessionEnvironment, out _, "None"))
                {
                    return Request.CreateResponse(HttpStatusCode.OK, new Session(sessionEnvironment, id));
                }
                throw new ArgumentException($"{typeof(SessionEnvironment).Name} must be either {GetEnumValues<SessionEnvironment>(",", "or", "None")}");
            }
            catch (Exception e)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, e.Message);
            }
        }
    }
}
