using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using SpamApi.Core;

namespace SpamApi.Controllers
{
    public class SessionController : ApiController
    {
        [Route("api/Session/{userId}/{hostName}")]
        [HttpGet]
        public Guid Get(string userId, string hostName)
        {
            Session session = new Session(SessionEnvironment.Development, "", "", userId, hostName);
            return session.Id;
        }
    }
}
