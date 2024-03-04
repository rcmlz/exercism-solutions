unit module Solution;

constant $word-borders = ' ', '-';
our $valid-chars  = / <:Letter> /;
our $valid-output = / ^<:Lu>+$ /;

sub abbreviate (Str:D $phrase --> Str:D) is export {
    PRE  { $phrase ~~ / $valid-chars  / }
    POST { $_      ~~ / $valid-output / }

    $phrase.split($word-borders)
           .map( *.comb.first($valid-chars) )
           .join
           .uc
}

role Solvable is export {
    method solve {
        # do all your magic in here ...

        # read single character from STDIN
        #say getc();

        # read single line from STDIN
        say abbreviate(get());
        
        # looping from STDIN
        #say abbreviate($_) for lines()
        #for words() { say $_ }
        
        # create subroutines
        #sub some-calculation() {
        #    say 1;
        #}
        #some-calculation;
    }
}