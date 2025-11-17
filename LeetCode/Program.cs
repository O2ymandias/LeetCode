using LeetCode;

string[] strs = ["neet", "code", "love", "you"];
var encoded = Solution.Encode(strs);
var decoded = Solution.Decode(encoded);
foreach (var str in decoded)
	Console.WriteLine(str);
