using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Data;
using System.Data.SqlClient;
using System.Security;

namespace SpamApi.Core
{
    public static class SpamUtility
    {
        private static readonly string developmentConnectionString = @"Data Source=DESKTOP-977JTTD\ROTH1;Initial Catalog=SpamDb;Integrated Security=true";
        private static readonly string testConnectionString = @"Data Source=DESKTOP-977JTTD\ROTH1;Initial Catalog=SpamDb;Integrated Security=true";
        private static readonly string productionConnectionString = @"Data Source=DESKTOP-977JTTD\ROTH1;Initial Catalog=SpamDb;Integrated Security=true";
        public static SqlConnection GetSqlConnection(SessionEnvironment environment)
        {
            switch(environment)
            {
                case SessionEnvironment.Development:
                    return new SqlConnection(developmentConnectionString);
                case SessionEnvironment.Test:
                    return new SqlConnection(testConnectionString);
                case SessionEnvironment.Production:
                    return new SqlConnection(productionConnectionString);
                default:
                    return default;
            }
        }
        public static DateTime GetEasternTimestamp() => TimeZoneInfo.ConvertTime(DateTime.Now, TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time"));
    }
}
