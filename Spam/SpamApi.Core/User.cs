using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.DirectoryServices.AccountManagement;

namespace SpamApi.Core
{
    [DirectoryRdnPrefix("CN")]
    [DirectoryObjectClass("Person")]
    public class User : UserPrincipal
    {
        private static PrincipalContext _defaultContext = new PrincipalContext(ContextType.Domain, "GEICO", "dc=GEICO,dc=corp,dc=net");
        private static IdentityType _defaultIdentityType = IdentityType.SamAccountName;
        private static string _defaultIdentityValue = Environment.UserName;

        [DirectoryProperty("department")]
        public string Department => (string)ExtensionGet("department").FirstOrDefault();
        //Create Manager property.  
        [DirectoryProperty("manager")]
        public string Manager => (string)ExtensionGet("manager").FirstOrDefault();
        //Create DirectReports property.
        [DirectoryProperty("directreports")]
        public List<string> DirectReports => ExtensionGet("directreports").Select(x => x.ToString()).ToList();

        public User(PrincipalContext context) : base(context)
        {
        }

        public static User Get() => Get(_defaultContext, _defaultIdentityType, _defaultIdentityValue);
        public static User Get(IdentityType identityType, string identityValue) => Get(_defaultContext, identityType, identityValue);
        public static User Get(string domainName, string domainContainer, string userId)
        {
            PrincipalContext context = new PrincipalContext(ContextType.Domain, domainName, domainContainer);
            return Get(context, _defaultIdentityType, userId);
        }
        public static User Get(PrincipalContext context, IdentityType identityType, string identityValue)
        {
            return (User)FindByIdentityWithType(context, typeof(User), identityType, identityValue);
        }

        public bool IsMemberOf(IdentityType identityType, string identityValue, bool recursive)
        {
            if (recursive)
            {
                using (GroupPrincipal contextGroup = GroupPrincipal.FindByIdentity(Context, identityType, identityValue))
                {
                    return contextGroup.GetMembers(true).Contains(this);
                }
            }
            return IsMemberOf(Context, identityType, identityValue);
        }
        public bool IsManagerOf(IdentityType identityType, string identityValue)
        {
            User user = Get(identityType, identityValue);
            int index = 0;
            while (user.DistinguishedName != user.Manager & index < 10)
            {
                user = Get(IdentityType.DistinguishedName, user.Manager);
                if (user == this)
                {
                    return true;
                }
                index++;
            }
            return false;
        }
    }
}
