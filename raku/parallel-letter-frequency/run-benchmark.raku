#!/usr/bin/env raku

sub letter-frequencies (+@texts) {
    bag @texts.race.map: *.lc.comb(/<:L>/)
}

sub letter-frequencies-single-core (+@texts) {
    bag @texts.map: *.lc.comb(/<:L>/)
}

sub MAIN {
    run-benchmark    
}

sub run-benchmark(:$runs = 3) {
    my $alphabet = ('A'..'Z') ∪ ('a'..'z') ∪ <ä ö ü Ä Ö Ü è ß ç>;
    my @text-count = 10, 100, 1000;
    my @words-per-text = 10, 100, 100;
    my @word-len = 10, 100, 100;
    
    say "\nSpeedup of e.g. '1.1' indicates that parallel execution\nruns 10% faster than single core execution.\nSpeedup '2.0' indicates double speed.\nA speedup smaller than 1 indicates that\nparallel execution is actually slower.\n";
    
    for ^$runs -> $i {
        say "Run: " ~ $i + 1;
        
        say "generating data";
        my @data = ($alphabet.roll(@word-len[$i]).join xx @words-per-text[$i]).join(' ') xx @text-count[$i];
        say "generated :: texts: %s, words per text: %s, word length: %s".sprintf(@data.elems, @data[0].words.elems, @data[0].words[0].comb.elems);
        
        say "timing parallel execution";
        my $par-time = time-it(&letter-frequencies, @data.eager);
        say "timing single core execution";
        my $single-time = time-it(&letter-frequencies-single-core, @data.eager);
        my $speedup = $single-time / $par-time;
        say "speedup: $speedup\n"
    }
}

sub time-it($fun, @data){
    my $start = now;
    eager $fun(|@data); # just to make sure there is no laziness hidden ...
    now - $start
}