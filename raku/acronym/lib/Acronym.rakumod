unit module Acronym;

use variables :D;
use fatal;
use experimental :cached;

constant $word-borders = ' ', '-';
constant $valid-chars  = / <:Letter> /;
constant $valid-output = / ^<:Lu>+$ /;

sub abbreviate (Str:D $phrase --> Str:D) is export {
    #PRE  { $phrase ~~ / <:Letter> / }
    #POST { $_      ~~ / ^<:Lu>+$  / }
    
    $phrase.match(/ <!after <:Letter + :Other_Punctuation> > <:Letter> /, :global).join.uc

    #($phrase ~~ m:r:global/ <!after <:Letter> | <[']>> <:Letter> /).join.uc

    #$phrase.split($word-borders, :skip-empty)
    #       .lazy
    #       .map({   .comb
    #                .lazy
    #                .first($valid-chars)})
    #       .eager.join.uc

    #$phrase.match(/ <!after <:Letter + :Other_Punctuation> > <:Letter> /, :global).join.uc # to slow, better mention punctation like Apostrophe ' explicit!?
    #$phrase.match(/ <!after <:Letter> | <[']>> <:Letter> /, :global).join.uc
}