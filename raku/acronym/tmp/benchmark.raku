#use variables :D;
#use fatal;
#use experimental :cached; # turns on the is cached trait, which stores the result of a routine call, returning the same value if called with the same arguments.
use Benchmark;

# see https://exercism.org/tracks/raku/exercises/acronym/solutions

# my favorite solutions
sub regex-solution1($phrase) is export {
    ($phrase ~~ m:global/ <!after <:Letter> | <[']>> <:Letter> /).join.uc
}

sub regex-solution2($phrase) is export {
    ($phrase ~~ m:r:global/ <!after <:Letter> | <[']>> <:Letter> /).join.uc
}

sub regex-solution3($phrase) is export {
    $phrase.match(/ <!after <:Letter> | <[']>> <:Letter> /, :global).join.uc
}

sub regex-punct4($phrase) is export {
    $phrase.match(/ <!after <:Letter + :Other_Punctuation> > <:Letter> /, :global).join.uc
}

sub MAIN{
    my @data = get-data(3, 2);
    
    my %results = timethese 10, {
#        "regex-1" => sub { regex-solution1($_) for @data },
#        "regex-2" => sub { regex-solution2($_) for @data },
#        "regex-3" => sub { regex-solution3($_) for @data },
#        "regex-punct" => sub { regex-punct($_) for @data },
        "n-lazy" => sub { not-lazy-solution($_) for @data },
#        "y-lazy-1" => sub { lazy-solution1($_) for @data },
#        "y-lazy-2" => sub { lazy-solution2($_) for @data },
        "y-lazy-3" => sub { lazy-solution3($_) for @data },
#        "andinus" => sub { andinus($_) for @data },
#        "m-dango" => sub { m-dango($_) for @data },
#        "khoguan" => sub { khoguan($_) for @data },
#        "jgaughan" => sub { jgaughan($_) for @data },
#        "deoac" => sub { deoac($_) for @data },
#        "scimon" => sub { scimon($_) for @data },
#        "citizen428" => sub { citizen428($_) for @data },
#        "menketechnologies" => sub { menketechnologies($_) for @data },
#        "steffan153" => sub { steffan153($_) for @data },
#        "rafaelschipiura" => sub { rafaelschipiura($_) for @data },
#        "tunasalad" => sub { tunasalad($_) for @data },
#        "Skyb0rg007" => sub { Skyb0rg007($_) for @data },
#        "mryan" => sub { mryan($_) for @data },
#        "EspenBerget" => sub { EspenBerget($_) for @data },
#        "TheGreatCatAdorer" => sub { TheGreatCatAdorer($_) for @data },
#        "habere-et-dispertire" => sub { habere-et-dispertire($_) for @data },
        "habere-et-dispertire-improved" => sub { habere-et-dispertire-improved($_) for @data },
#        "factor3" => sub { factor3($_) for @data },
#        "kapitaali" => sub { kapitaali($_) for @data },
#        "Evan-Hock" => sub { Evan-Hock($_) for @data },
#        "Elixir28" => sub { Elixir28($_) for @data },
    }, :statistics;

    my %selected_result;
    for %results.kv -> $k, $v {
        %selected_result{$k} = $v<mean>
    }

    for %selected_result.sort: *.invert -> Pair $ (:key($key), :value($value)) {
        FIRST {say "solution\tmean"}
        say "$key\t$value"
    }    
}

# my other solutions

constant $word-borders = ' ', '-';
constant $valid-chars  = / <:Letter> /;
constant $valid-output = / ^<:Lu>+$ /;

sub not-lazy-solution($phrase) is export {
    $phrase.split($word-borders, :skip-empty)
           .map({   .comb
                    .first($valid-chars)})
           .join.uc
}

sub lazy-solution1($phrase) is export {
    $phrase.split($word-borders, :skip-empty)
           .map({   .comb
                    .lazy
                    .first($valid-chars)})
           .eager.join.uc
}

sub lazy-solution2($phrase) is export {
    $phrase.split($word-borders, :skip-empty)
           .lazy.map({   .comb
                         .first($valid-chars)})
           .eager.join.uc
}

sub lazy-solution3($phrase) is export {
    $phrase.split($word-borders, :skip-empty)
           .lazy.map({   .comb
                         .lazy
                         .first($valid-chars)})
           .eager.join.uc
}

# other people solutions

sub andinus($phrase) is export {
    [~] $phrase.split(/<[-_\s]>/).map(*.substr(0, 1).uc)
}

sub m-dango($_) is export {
    .split( ' -_'.comb, :skip-empty )
    .map( *.substr(^1) )
    .join
    .uc;

}

sub khoguan (Str:D $phrase) is export {
    if $phrase eq '' { return $phrase }
    return $phrase.trim
                  .split(/ <[\s\-_]>+ /)
                  .map( *.substr(0,1).uc )
                  .join;
}

sub jgaughan ($phrase) {
    $phrase
    ==> split(rx{ <[\s-]>+ })
    ==> map(-> $_ is copy { s/^ <[\W_]>* //; .comb(1, 1) })
    ==> join('')
    ==> uc()
}

sub deoac ($phrase) {
    my regex separators {  <-     [\s -] >+ }
    my regex unwanted   {  <-:Lu -[\s -] >  }

    my $acronym = $phrase
        # The acronym must be all upper-case.
        .uc

        # Get rid of punctuation (especially _leading punctuation)
        # and non-capital Unicode letters (e.g. Å is acceptable).
        .map( *.subst: / <unwanted> /, '', :g )

        # Words are separated by spaces and hyphens.
        .comb( / <separators> / )

        # We only need the first lettter of each word.
        .map( *.comb.head )

        # And put it all together!
        .join;

    return $acronym;
} # end of abbreviate ($phrase) is export

sub scimon ($phrase) is export {
    $phrase.split( /<-[' A..Z a..z]>/ ).map( -> $a is copy { $a ~~ s:g/<-[A..Z a..z]>//; $a } ).map( *.substr(0,1).uc ).join()
}

sub citizen428 (\phrase) is export {
    my regex word-char { <[ A..Z ' ]> };
  phrase.uc.comb(/<!after <word-char> >  <word-char>/).join
}

sub tunasalad ($phrase) {
    $phrase
    .subst(<'>, "", :g)
    .subst(/<-[a..z]-[A..Z]>/, " ", :g)
    .split(" ")
    .grep(?*)
    .map(*.ord)
    .chrs
    .uc
}

sub menketechnologies ($s) {
    $s.uc.split(/<[-_\s]>/).map(*.substr(0, 1)).join
}

sub steffan153 ($phrase) {
    [~] $phrase.uc.split("- _".comb).map: *.comb.head
}

sub rafaelschipiura ($phrase is copy) {
    $phrase ~~ s/\-/ /;
    $phrase ~~ s:g/<.punct>//;
    my $result = $phrase ~~ m/[^(\w)|\s(\w)]+ % .*?/;
    [~] $result.map(*.map(*.uc))
}

sub Skyb0rg007 ($phrase) {
    my regex word-start {
        <!after <[a .. z A .. Z ']>> <[a .. z A .. Z ]>
    }
    $phrase.comb(/<word-start>/)>>.uc.join("");
}

sub mryan ($phrase) returns Str {
  $phrase.split(/<[\s _ -]>+/)».comb».first».uc.join
}

sub EspenBerget ($phrase) {
  $phrase.split(/<[\s\-_]>/, :skip-empty).map(-> $word { $word.comb[0] }).join.uc
}

sub TheGreatCatAdorer ($phrase) {
    $phrase.split(/<[\s,_-]>+/).map(*.comb[0].uc).join
}

sub habere-et-dispertire ( $phrase ) {

    $phrase.split(   ' -_'.comb )
           .map( *.comb.head.uc )
           .join

}

sub habere-et-dispertire-improved ( $phrase ) {

    $phrase.split(   ' -_'.comb, :skip-empty )
           .map( *.comb.first )
           .join.uc

}

sub factor3 ($phrase) {
    $phrase.split(/<[-_\s]>/, :skip-empty)».comb»[0].join.uc
}

sub kapitaali ($phrase) {
    my $ret = "";
    my $a = $phrase.lc;
    $a ~~ s:g/<[\,\-\_]>/ /;
    $a ~~ s:g/\h\h+/ /;
    my @b = $a.trim.split(' ');
    for @b -> $item {
        $ret = $ret ~ substr($item, 0, 1).uc;
    }
    return $ret;
}

sub scpchicken ($phrase) {
    $phrase.split(/<[\ \-]>/).map({.comb.grep(* ~~ /<[A..Za..z]>/).head.uc}).join
}

sub Evan-Hock($phrase is copy) {
    $phrase ~~ s:g/<-[-\s\w]> | _//;
    $phrase.split(/\s+ | '-'/).map(*.substr(0, 1).uc).join
}

sub Elixir28 ($phrase) {
    return $phrase.uc
                  .subst(/<[_\-]>/," ",:g)
                  .subst(/<[\']>/,"")
                  .split(/\s+/)
                  .map(*.substr(0,1))
                  .join;
}

sub unicode-words(UInt $entry, UInt $alphabet-size, UInt $min-length, UInt $max-length where {$min-length <= $max-length}, @sizes, UInt $size-offset) {

    my Set $some-unicode-characters = 
          ('a'..'z') ∪ ('A'..'Z')
    #    ∪ (0..9) 
    #    ∪ ('∪', '∅', '∩', '⊖')
        ∪ ("\c[Latin Capital Letter A, Combining Grave Accent]","\c[Latin Capital Letter A with Grave]", "\c[Latin Capital Letter E, Combining Grave Accent]", "\c[Latin Capital Letter E with Grave]", "\c[Latin Small Letter A, Combining Grave Accent]", "\c[Latin Small Letter A with Grave]", "\c[Latin Small Letter E, Combining Grave Accent]", "\c[Latin Small Letter E with Grave]","\c[Latin Capital Letter ae with Macron]")
    #    ∪ ("\c[VULGAR FRACTION ONE HALF]", "\c[VULGAR FRACTION ONE SEVENTH]", "\c[VULGAR FRACTION ONE FIFTH]")
    #    ∪ ("\c[LATIN SMALL LETTER J WITH CARON, COMBINING DOT BELOW]", "\c[Roman Numeral Four]", "\c[Roman Numeral Three]", "\c[Roman Numeral Two]", "\c[Roman Numeral One]")
    #    ∪ ('à', 'è', 'ä', 'ö', 'ü', 'Ä', 'Ö', 'Ü', 'ß', "\c[LATIN CAPITAL LETTER SHARP S]")
    #    ∪ ("\c[PENGUIN]", "\c[BELL]", "\c[SMILING FACE WITH HALO]", "\c[GRINNING FACE]")
    #    ∪ ("\c[EGYPTIAN HIEROGLYPH A001]" .. "\c[EGYPTIAN HIEROGLYPH A004]")
    ;         
    
    my $n = @sizes[$entry + $size-offset];

    state @data;

    my $word-length = $min-length .. $max-length;
    state @alphabet = $some-unicode-characters.roll($alphabet-size);
    
    unless @data[$n] {
        @data[$n] = (@alphabet.roll($word-length.roll).join('') xx $n).List;
    }
    return @data[$n];
}

sub get-data($nr-of-increasing-problem-sizes=1, $start-size-element=3) {
    my @problem-size-factor-two = 1,2,4,8,16,32 ... Inf;
    gather {
        for ^$nr-of-increasing-problem-sizes {
            take join ' ', unicode-words($_, 10, 10, 100, @problem-size-factor-two, $start-size-element)
        }
    }

}