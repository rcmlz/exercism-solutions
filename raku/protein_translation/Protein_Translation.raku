unit module Protein-Translation;

my class X::InvalidCodon is Exception {
    method message {
        'Invalid codon'
    }
}

our %PROTEIN is default(X::InvalidCodon) = {
    Methionine => <AUG>,
    Phenylalanine => <UUU UUC>,
    Leucine => <UUA UUG>,
    Serine => <UCU UCC UCA UCG>,
    Tyrosine => <UAU UAC>,
    Cysteine => <UGU UGC>,
    Tryptophan => <UGG>,
    STOP => <UAA UAG UGA> }.invert;

sub protein_translation(Str $rna --> Seq) {
    $rna.comb(3).map: { given %PROTEIN{$_} {
        when 'STOP' { last }
        when X::InvalidCodon { $_.new.throw }
        default { $_ or [] }
    }}
}

use Test;

throws-like protein_translation("AAA"), X::InvalidCodon;
throws-like protein_translation("AUGU"), X::InvalidCodon;

my @test-data =
        AUG => <Methionine>,
        UUU => <Phenylalanine>,
        UUC => <Phenylalanine>,
        UUA => <Leucine>,
        UUG => <Leucine>,
        UCU => <Serine>,
        UCC => <Serine>,
        UCA => <Serine>,
        UCG => <Serine>,
        UAU => <Tyrosine>,
        UAC => <Tyrosine>,
        UGU => <Cysteine>,
        UGC => <Cysteine>,
        UGG => <Tryptophan>,
        UAA => [],
        UAG => [],
        UGA => [],
        UUUUUU => <Phenylalanine Phenylalanine>,
        UUAUUG => <Leucine Leucine>,
        AUGUUUUGG => <Methionine Phenylalanine Tryptophan>,
        UAGUGG => [],
        UGGUAG => <Tryptophan>,
        AUGUUUUAA => <Methionine Phenylalanine>,
        UGGUAGUGG => <Tryptophan>,
        UGGUGUUAUUAAUGGUUU => <Tryptophan Cysteine Tyrosine>;

is protein_translation(.key), .value for @test-data;
done-testing