unit module BookStore;

constant PRICE = 8;
constant BOOKS-COUNT = 1..5;
constant DISCOUNT = 1, 0.95, 0.9, 0.8, 0.75;
constant COST = flat 0, PRICE «×« BOOKS-COUNT »×« DISCOUNT;

proto best-price ( Bag $basket where .values.all ≥ 0 --> Rat ) is export {*}
multi best-price (     $basket                       --> 0.0 )           { }
multi best-price (     $basket where .values.any > 0         )           {
    state Rat %mem{Str};
    my Str $key = ~$basket.values.sort;

    return %mem{$key} if %mem{$key}:exists;

    %mem{$key} = min gather {
            $basket.keys.combinations(BOOKS-COUNT).map: -> @book-ids {
                with $basket.BagHash {
                    .remove(@book-ids);
                    take COST[@book-ids.elems] + samewith(.Bag)
                }
            }
        }
}