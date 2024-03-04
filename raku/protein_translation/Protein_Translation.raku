constant %PROTEIN = {
    Methionine => <AUG>,
    Phenylalanine => <UUU UUC>,
    Leucine => <UUA UUG>,
    Serine => <UCU UCC UCA UCG>,
    Tyrosine => <UAU UAC>,
    Cysteine => <UGU UGC>,
    Tryptophan => <UGG>,
    STOP => <UAA UAG UGA>}.invert;

sub protein_translation( Str $rna --> Seq(Str) ) {
	$rna.comb(3).map: {  given %PROTEIN{$_} {
                             when 'STOP' { last }
                             default     { $_ or [] }                      
                         }
                      }
}

use Test;

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

plan @test-data.elems;
ok protein_translation(.key) eqv .value.Seq for @test-data;
done-testing