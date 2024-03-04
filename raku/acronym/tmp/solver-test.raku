#!/usr/bin/env raku

sub MAIN(){
	($*IN does Solvable).solve;
}