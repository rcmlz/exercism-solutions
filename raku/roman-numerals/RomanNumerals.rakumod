unit module RomanNumerals;

constant roman-num-ascii   = <I V X L C D M>;
constant roman-num-unicode = ("\c[Roman Numeral One]" .. "\c[Roman Numeral One Thousand]").words;
constant valid-roman-num-character = roman-num-ascii ∪ roman-num-unicode;

sub to-roman(Int $num is copy --> Str) is export {
	PRE  { $num > 0 }
	POST { $_.comb ⊆ valid-roman-num-character }

    join '', gather {
      while $num >= 1000 { $num -= 1000; take "M"}
      while $num >= 500  { $num -= 500; take "D"}
      while $num >= 100  { $num -= 100; take "C"}
      while $num >= 50   { $num -= 50; take "L"}
      while $num >= 10   { $num -= 10; take "X"}
      while $num >= 5    { $num -= 5; take "V"}
      while $num > 0     { $num -= 1; take "I"}
	}
}
