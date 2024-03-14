my class X::Bowling::GameOver is Exception { method message { 'Cannot roll after game is over'} }
my class X::Bowling::GameInProgress is Exception {method message { 'Score cannot be taken until the end of the game'}}
my class X::Bowling::TooManyPins is Exception { method message { 'Pin count exceeds pins on the lane'}}
my class X::Bowling::NegativePins is Exception {method message {'Negative roll is invalid'}}

class Frame {
    has UInt $.ball-throw-one;
    has UInt $.ball-throw-two is rw;
    has UInt $.value is rw;

    method pins-knocked-down { $!ball-throw-one + ($!ball-throw-two or 0) }
    method is-open { self.pins-knocked-down < 10 }
    method is-strike { $!ball-throw-one == 10 }
    method is-spare { not self.is-strike && self.pins-knocked-down == 10 }
}

class Bowling {
    has @!frames;
    has Bool $!game-over = False;

    method roll ($pins) {
        X::Bowling::NegativePins.new.throw if $pins < 0;
        X::Bowling::TooManyPins.new.throw if $pins > 10;
        X::Bowling::GameOver.new.throw if $!game-over;

        my $new-frame = Frame.new(ball-throw-one => $pins);

        # first frame
        return @!frames.push($new-frame) unless @!frames.tail ~~ Frame;

        # subsequent frames
        if @!frames.tail.ball-throw-two.defined or @!frames.tail.is-strike {
            @!frames.push: $new-frame
        }else {
            X::Bowling::TooManyPins.new.throw if @!frames.tail.ball-throw-one + $pins > 10;
            @!frames.tail.ball-throw-two = $pins;
        }
        self!check-game-over
    }

    method !check-game-over {
        if (10 == @!frames.elems
                and @!frames.tail.ball-throw-two.defined
                and @!frames.tail.is-open)
                or (11 == @!frames.elems
                        and @!frames[*- 2].tail.is-spare)
                or (11 == @!frames.elems
                        and @!frames[*- 2].is-strike
                        and not @!frames.tail.is-strike
                        and @!frames.tail.ball-throw-two.defined)
                or (12 == @!frames.elems
                        and @!frames[*- 2].is-strike
                        and @!frames.tail.ball-throw-one.defined) {
            $!game-over = True
        }
        $!game-over
    }
    method !evaluate-frames {
        for @!frames[^10].kv -> $i, $frame {
            my UInt $res;
            if $frame.is-open {
                $res = $frame.pins-knocked-down
            }elsif $frame.is-spare {
                $res = 10 + @!frames[$i + 1].ball-throw-one
            }elsif $frame.is-strike {
                if @!frames[$i + 1].is-strike {
                    if @!frames[$i + 2].is-strike {
                        $res = 30
                    }else {
                        $res = 20 + @!frames[$i + 2].ball-throw-one
                    }
                }else {
                    $res = 10 + @!frames[$i + 1].pins-knocked-down
                }
            }
            @!frames[$i].value = $res
        }
    }

    method score {
        X::Bowling::GameInProgress.new.throw unless $!game-over;
        self!evaluate-frames;
        [+] @!frames[^10].map: *.value
    }
}
