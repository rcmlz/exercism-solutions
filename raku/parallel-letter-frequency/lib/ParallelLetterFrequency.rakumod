unit module ParallelLetterFrequency;

sub letter-frequencies (+@texts) is export {
    bag @texts.race.map: *.lc.comb(/<:L>/)
}
