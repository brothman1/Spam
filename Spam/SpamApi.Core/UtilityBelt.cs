using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

namespace SpamApi.Core
{
    public static class UtilityBelt
    {
        #region TryParseEnum
        public static bool TryParseEnum<TEnum>(this string toBeParsed, out TEnum parsedEnum, out bool partialParse, params string[] excludedValues) where TEnum : struct, Enum
        {
            partialParse = false;
            if (toBeParsed.ToEnum(out parsedEnum) && !excludedValues.Contains(toBeParsed))
            {
                return true;
            }
            if (toBeParsed.ToEnumPartial(out parsedEnum) && !excludedValues.Contains(toBeParsed))
            {
                partialParse = true;
                return true;
            }
            return false;
        }
        public static bool TryParseEnumExact<TEnum>(this string toBeParsed, out TEnum parsedEnum, params string[] excludedValues) where TEnum : struct, Enum
        {
            if (toBeParsed.ToEnum(out parsedEnum) && !excludedValues.Contains(toBeParsed))
            {
                return true;
            }
            return false;
        }
        private static bool ToEnum<TEnum>(this string toBeParsed, out TEnum parsedEnum) where TEnum : struct, Enum
        {
            if (Enum.TryParse(toBeParsed, true, out parsedEnum))
            {
                return true;
            }
            parsedEnum = default;
            return false;
        }
        private static bool ToEnumPartial<TEnum>(this string toBeParsed, out TEnum parsedEnum) where TEnum : struct, Enum
        {
            List<TEnum> matchingEnums = Enum.GetNames(typeof(TEnum))
                                            .Select(enumName => enumName.ToLower())
                                            .Where(enumName => enumName.StartsWith(toBeParsed.ToLower()))
                                            .OrderBy(enumName => enumName)
                                            .Select(enumName => (TEnum)Enum.Parse(typeof(TEnum), enumName, true))
                                            .ToList();
            if (matchingEnums.Count > 0)
            {
                parsedEnum = matchingEnums[0];
                return true;
            }
            parsedEnum = default;
            return false;
        }
        #endregion
        public static string GetEnumValues<TEnum>(string delimeter, string end, params string[] excludedValues) where TEnum : struct, Enum
        {
            List<string> enumValues = Enum.GetNames(typeof(TEnum))
                                            .Where(enumName => !excludedValues.Contains(enumName))
                                            .Select(enumName => $"\"{enumName.ToUserFriendlyString()}\"")
                                            .ToList();
            if (enumValues.Count > 1)
            {
                enumValues[enumValues.Count - 1] = $"{end} {enumValues[enumValues.Count - 1]}";
            }
            return string.Join($"{delimeter} ", enumValues);
        }
        #region ToUserFriendlyString
        public static string ToUserFriendlyString(this Enum value)
        {
            return Regex.Replace(value.ToString(), "(\\B[A-Z])", " $1");
        }
        public static string ToUserFriendlyString(this string value)
        {
            return Regex.Replace(value, "(\\B[A-Z])", " $1");
        }
        #endregion
    }
}
