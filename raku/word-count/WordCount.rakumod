unit module WordCount;

grammar G {
	rule TOP { ^ [ <:!Letter - :Decimal_Number>*
				   <word>
                   <:!Letter - :Decimal_Number>*
                  ]* $ }
	token word { << <:Letter + :Decimal_Number + [']>+ }
}

sub count-words ($sentence) is export {
	my $parsed = G.parse($sentence);
	my @results;
	@results.append(.Str.lc) for $parsed.values;
	@results.map({s/\'$//});
	return @results.Bag;
}
