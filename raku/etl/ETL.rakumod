unit module ETL;

sub transform (%input) is export {
	my Int:D %tmp{Str:D} = %input.invert;
	my Int:D %result{Str:D};

	for %tmp.keys -> $k {
		%result{$k.lc} = %tmp{$k};
    }

	return %result;
}
