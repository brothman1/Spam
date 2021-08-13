using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
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

        public SessionEnvironment Environment { get; }
        public Guid Id { get; private set; }
        public User User { get; }
        public string HostName { get; }
        public bool IsActive { get; private set; }
        public Session(SessionEnvironment environment, string domainName, string domainContainer, string userId, string hostName)
        {
            Environment = environment;
            //User = User.Get(domainName, domainContainer, userId);
            HostName = hostName;
            Start(userId);
        }
        private void Start()
        {
            StatusEvent((int)SessionStatusEventType.Start, GetEasternTimestamp(), User.SamAccountName, HostName, out string errorMessage);
            if (!string.IsNullOrEmpty(errorMessage))
            {
                throw new Exception(errorMessage);
            }
            IsActive = true;
        }
        private void Start(string userId)
        {
            StatusEvent((int)SessionStatusEventType.Start, GetEasternTimestamp(), userId, HostName, out string errorMessage);
            if (!string.IsNullOrEmpty(errorMessage))
            {
                throw new Exception(errorMessage);
            }
            IsActive = true;
        }
        public void End()
        {
            StatusEvent((int)SessionStatusEventType.Start, GetEasternTimestamp(), User.SamAccountName, HostName, out string errorMessage);
            if (!string.IsNullOrEmpty(errorMessage))
            {
                throw new Exception(errorMessage);
            }
            IsActive = false;
        }
        public void End(string userId)
        {
            StatusEvent((int)SessionStatusEventType.Start, GetEasternTimestamp(), userId, HostName, out string errorMessage);
            if (!string.IsNullOrEmpty(errorMessage))
            {
                throw new Exception(errorMessage);
            }
            IsActive = false;
        }
        private void StatusEvent(byte typeId, DateTime timestamp, string userId, string hostName, out string errorMessage)
        {
            using (SqlCommand statusEvent = new SqlCommand("dbo.usp_SessionStatusEvent", GetSqlConnection(Environment)))
            {
                statusEvent.CommandType = CommandType.StoredProcedure;
                statusEvent.Parameters.Add(new SqlParameter("@TypeId", SqlDbType.TinyInt) { Value = typeId });
                statusEvent.Parameters.Add(new SqlParameter("@Timestamp", SqlDbType.DateTime2, 7) { Value = timestamp });
                statusEvent.Parameters.Add(new SqlParameter("@UserId", SqlDbType.NVarChar, 32) { Value = userId });
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
    }
}
