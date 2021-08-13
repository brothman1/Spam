using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using Newtonsoft.Json;
using static SpamApi.Core.SpamUtility;

namespace SpamApi.Core
{
    public enum SessionEnvironment
    {
        None,
        Development,
        Test,
        Production
    }
    public enum SessionStatusEventType
    {
        None,
        Start,
        End
    }
    public class Session
    {
        [JsonIgnore]
        public SessionEnvironment Environment { get; }
        [JsonIgnore]
        public User User { get; }
        [JsonIgnore]
        public string HostName { get; private set; }
        public Guid Id { get; private set; }
        public bool IsActive { get; private set; }
        public string RelevantSecurityGroups { get; private set; }
        public Session(SessionEnvironment environment, string domainName, string domainContainer, string userId, string hostName)
        {
            Environment = environment;
            User = User.Get(domainName, domainContainer, userId);
            HostName = hostName;
            RelevantSecurityGroups = GetRelevantSecurityGroups(domainName, domainContainer);
            Start();
        }
        public Session(SessionEnvironment environment, Guid id)
        {
            Environment = environment;
            Id = id;
            GetSessionInformation(out string userId, out string domainName, out string domainContainer, out string errorMessage);
            if (!string.IsNullOrEmpty(errorMessage))
            {
                throw new Exception(errorMessage);
            }
            User = User.Get(domainName, domainContainer, userId);
            RelevantSecurityGroups = GetRelevantSecurityGroups(domainName, domainContainer);
        }
        private void Start()
        {
            ExecuteStatusEvent((int)SessionStatusEventType.Start, GetEasternTimestamp(), User.SamAccountName, User.Context.Name, User.Context.Container, HostName, out string errorMessage);
            if (!string.IsNullOrEmpty(errorMessage))
            {
                throw new Exception(errorMessage);
            }
            IsActive = true;
        }
        public void End()
        {
            ExecuteStatusEvent((int)SessionStatusEventType.End, GetEasternTimestamp(), null, null, null, null, out string errorMessage);
            if (!string.IsNullOrEmpty(errorMessage))
            {
                throw new Exception(errorMessage);
            }
            IsActive = false;
        }
        private void ExecuteStatusEvent(byte typeId, DateTime timestamp, string userId, string domainName, string domainContainer, string hostName, out string errorMessage)
        {
            using (SqlCommand statusEvent = new SqlCommand("dbo.usp_SessionStatusEvent", GetSqlConnection(Environment)))
            {
                statusEvent.CommandType = CommandType.StoredProcedure;
                statusEvent.Parameters.Add(new SqlParameter("@TypeId", SqlDbType.TinyInt) { Value = typeId });
                statusEvent.Parameters.Add(new SqlParameter("@Timestamp", SqlDbType.DateTime2, 7) { Value = timestamp });
                statusEvent.Parameters.Add(new SqlParameter("@UserId", SqlDbType.NVarChar, 32) { Value = userId });
                statusEvent.Parameters.Add(new SqlParameter("@DomainName", SqlDbType.NVarChar, 32) { Value = domainName });
                statusEvent.Parameters.Add(new SqlParameter("@DomainContainer", SqlDbType.NVarChar, 128) { Value = domainContainer });
                statusEvent.Parameters.Add(new SqlParameter("@HostName", SqlDbType.NVarChar, 128) { Value = hostName });
                statusEvent.Parameters.Add(new SqlParameter("@SessionId", SqlDbType.UniqueIdentifier) { Direction = ParameterDirection.InputOutput, Value = Id });
                statusEvent.Parameters.Add(new SqlParameter("@ErrorMessage", SqlDbType.NVarChar, 4000) { Direction = ParameterDirection.InputOutput });
                statusEvent.Connection.Open();
                statusEvent.ExecuteNonQuery();
                statusEvent.Connection.Close();
                Id = (Guid)statusEvent.Parameters["@SessionId"].Value;
                errorMessage = statusEvent.Parameters["@ErrorMessage"].Value.ToString();
            }
        }
        private void GetSessionInformation(out string userId, out string domainName, out string domainContainer, out string errorMessage)
        {
            using (SqlCommand sessionInformation = new SqlCommand("dbo.usp_GetSession", GetSqlConnection(Environment)))
            {
                sessionInformation.CommandType = CommandType.StoredProcedure;
                sessionInformation.Parameters.Add(new SqlParameter("@SessionId", SqlDbType.UniqueIdentifier) { Value = Id });
                sessionInformation.Parameters.Add(new SqlParameter("@UserId", SqlDbType.NVarChar, 32) { Direction = ParameterDirection.InputOutput });
                sessionInformation.Parameters.Add(new SqlParameter("@DomainName", SqlDbType.NVarChar, 32) { Direction = ParameterDirection.InputOutput });
                sessionInformation.Parameters.Add(new SqlParameter("@DomainContainer", SqlDbType.NVarChar, 128) { Direction = ParameterDirection.InputOutput });
                sessionInformation.Parameters.Add(new SqlParameter("@HostName", SqlDbType.NVarChar, 128) { Direction = ParameterDirection.InputOutput });
                sessionInformation.Parameters.Add(new SqlParameter("@IsActive", SqlDbType.Bit) { Direction = ParameterDirection.InputOutput });
                sessionInformation.Parameters.Add(new SqlParameter("@ErrorMessage", SqlDbType.NVarChar, 4000) { Direction = ParameterDirection.InputOutput });
                sessionInformation.Connection.Open();
                sessionInformation.ExecuteNonQuery();
                sessionInformation.Connection.Close();
                if (DBNull.Value.Equals(sessionInformation.Parameters["@UserId"].Value))
                {
                    throw new ArgumentException("SessionId not found!");
                }
                userId = sessionInformation.Parameters["@UserId"].Value.ToString();
                domainName = sessionInformation.Parameters["@DomainName"].Value.ToString();
                domainContainer = sessionInformation.Parameters["@DomainContainer"].Value.ToString();
                HostName = sessionInformation.Parameters["@HostName"].Value.ToString();
                IsActive = (bool)sessionInformation.Parameters["@IsActive"].Value;
                errorMessage = sessionInformation.Parameters["@ErrorMessage"].Value.ToString();
            }
        }
        private string GetRelevantSecurityGroups(string domainName, string domainContainer)
        {
            List<string> securityGroups = new List<string>();
            using (SqlCommand getSecurityGroups = new SqlCommand("dbo.usp_GetSecurityGroups", GetSqlConnection(Environment)))
            {
                getSecurityGroups.CommandType = CommandType.StoredProcedure;
                getSecurityGroups.Parameters.Add(new SqlParameter("@DomainName", SqlDbType.NVarChar, 32) { Value = domainName });
                getSecurityGroups.Parameters.Add(new SqlParameter("@DomainContainer", SqlDbType.NVarChar, 128) { Value = domainContainer });
                getSecurityGroups.Parameters.Add(new SqlParameter("@ErrorMessage", SqlDbType.NVarChar, 4000) { Direction = ParameterDirection.InputOutput });
                getSecurityGroups.Connection.Open();
                using (SqlDataReader getSecurityGroupsReader = getSecurityGroups.ExecuteReader())
                {
                    while (getSecurityGroupsReader.Read())
                    {
                        securityGroups.Add(getSecurityGroupsReader["Name"].ToString());
                    }
                    getSecurityGroupsReader.Close();
                }
                getSecurityGroups.Connection.Close();
            }
            return string.Join(",", securityGroups.Where(group => User.IsMemberOf(User.Context, User.DefaultIdentityType, group)));
        }
    }
}
