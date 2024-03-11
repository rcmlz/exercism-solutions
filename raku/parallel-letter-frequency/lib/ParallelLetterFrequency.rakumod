unit module ParallelLetterFrequency;

sub letter-frequencies (+@texts) is export {
    bag @texts.race(degree => min(16, $*KERNEL.cpu-cores),
                    batch  => min(64, @texts.elems div $*KERNEL.cpu-cores + 1 ))
              .map: *.lc.comb(/<:L>/)
}
