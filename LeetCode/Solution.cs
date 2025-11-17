using System.Text;

namespace LeetCode;

internal class Solution
{
	#region 49.Group Anagrams

	public static IList<IList<string>> GroupAnagrams(string[] strs)
	{
		var dict = new Dictionary<string, List<string>>();

		foreach (var str in strs)
		{
			var appearances = new int[26];

			foreach (var ch in str) appearances[ch - 'a']++;

			var hashableKey = string.Join("#", appearances);

			if (dict.TryGetValue(hashableKey, out var value))
				value.Add(str);

			else dict[hashableKey] = [str];
		}

		return [.. dict.Values];
	}

	#endregion

	#region 1.TwoSum

	public static int[] TwoSum(int[] nums, int target)
	{
		var dict = new Dictionary<int, int>();

		for (var i = 0; i < nums.Length; i++)
		{
			var candidateKey = target - nums[i];
			if (dict.TryGetValue(candidateKey, out var candidateVal)) return [candidateVal, i];
			dict.TryAdd(nums[i], i);
		}

		return [];
	}

	#endregion

	#region 217.Contains Duplicate

	public static bool ContainsDuplicate(int[] nums)
	{
		var hashSet = new HashSet<int>();

		foreach (var item in nums)
		{
			var added = hashSet.Add(item);
			if (!added) return true;
		}

		return false;
	}

	#endregion

	#region 242.Valid Anagram

	public static bool IsAnagram(string s, string t)
	{
		// Using Dict
		if (s.Length != t.Length) return false;

		var dict = new Dictionary<char, int>();

		foreach (var ch in s)
		{
			var added = dict.TryAdd(ch, 1);
			if (!added) dict[ch]++;
		}

		foreach (var ch in t)
		{
			if (!dict.TryGetValue(ch, out _)) return false;
			dict[ch]--;
			if (dict[ch] < 0) return false;
		}

		return true;


		// Using Array
		if (s.Length != t.Length) return false;

		var appearances = new int[26]; // Alphabet count 

		for (var i = 0; i < s.Length; i++)
		{
			appearances[s[i] - 'a']++;
			appearances[t[i] - 'a']--;
		}

		foreach (var appearance in appearances)
			if (appearance != 0)
				return false;

		return true;
	}

	#endregion

	#region 347. Top K Frequent Elements

	public static int[] TopKFrequent(int[] nums, int k)
	{

		if (nums.Length == 1) return nums;

		var frequences = new Dictionary<int, int>();

		foreach (var num in nums)
		{
			var added = frequences.TryAdd(num, 1);
			if (!added) frequences[num]++;
		}

		// Soring The Dict
		/*
		var sorted = frequences
			.OrderByDescending(x => x.Value)
			.ToArray();

		var result = new int[k];

		for (int i = 0; i < k; i++)
			result[i] = sorted[i].Key;
		
		return result;
		*/

		var result = new int[k];

		List<int>[] arr = new List<int>[nums.Length + 1];

		foreach (var (key, value) in frequences)
		{
			if (arr[value] is null) arr[value] = [key];
			else arr[value].Add(key);
		}

		var addedToResult = 0;
		for (int i = arr.Length - 1; i >= 0; i--)
		{
			if (arr[i] is null) continue;

			foreach (var item in arr[i])
			{
				if (addedToResult == k) return result;

				result[addedToResult] = item;
				addedToResult += 1;
			}

		}

		return result;

	}

	#endregion

	#region 271. Encode and Decode Strings

	public static string Encode(IList<string> strs)
	{
		var sb = new StringBuilder();
		foreach (var str in strs)
			sb.Append($"{str.Length}:{str}");
		return sb.ToString();
	}

	public static List<string> Decode(string s)
	{
		var lenStr = new StringBuilder();
		var result = new List<string>();

		for (int i = 0; i < s.Length; i++)
		{
			if (s[i] != ':') lenStr.Append(s[i]);
			else
			{
				var currStrChars = new List<char>();

				var len = int.Parse(lenStr.ToString());
				var currIndex = i + 1;
				var limit = currIndex + len;
				while (currIndex < limit)
				{
					if (currIndex == limit) break;
					currStrChars.Add(s[currIndex]);
					currIndex++;
				}

				var currStr = string.Concat(currStrChars);
				result.Add(currStr);
				lenStr.Clear();
				i = currIndex - 1;
			}
		}

		return result;
	}
	#endregion

}
