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

}
