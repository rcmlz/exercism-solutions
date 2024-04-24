constant letter-key = 'a'..'z' => [R,] 'a'..'z';

sub encode ($phrase) is export {
    $phrase.subst(/<:!Letter-:Number>/, :g).lc.trans(letter-key).comb(5)
}

sub decode ($phrase) is export {
    $phrase.subst(/<ws>/, :g).trans: letter-key
}
