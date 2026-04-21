unit module MicroBlog;

sub post (Str :$tweet) is export { 
  $tweet.comb(5).head()
}
