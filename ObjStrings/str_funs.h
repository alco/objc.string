#import <Foundation/Foundation.h>


/*
 * Append `s2` after `s1`. Synonym for [s1 stringByAppendingString:s2].
 * (chainable)
 *
 *     str_append(@"foo", @"bar")  =>  @"foobar"
 */
NSString *str_append(NSString *s1, NSString *s2);

/* Capitalize the first character in `str` (only if it's a letter).
 * (chainable)
 *
 *     str_capitalize(@"one two")  =>  @"One two"
 */
NSString *str_capitalize(NSString *str);


/* Compress adjacent whitespace into one space.
 * (chainable)
 *
 *     str_compress(@"\thello  \t world  ")  =>  @" hello world "
 */
NSString *str_compress(NSString *str);

/* Replace ocurrences of `pattern` with `repl`. `pattern` can be a string or a
 * regex. If `pattern` is a regex, then `repl` is treated as a template string
 * (as per the NSRegularExpression docs).
 * (chainable)
 *
 *     str_replace(@"Hello, ma", @"ma", @"pa")
 *     => @"Hello, pa"
 *
 *     str_replace(@"foo.bar one.two", $regex(@"(\\w+)\\.(\\w+)"), @"$2\\.$1")
 *     => @"bar.foo two.one"
 */
NSString *str_replace(NSString *str, NSString *pattern, NSString *repl);

/* Repeat the string `count` times, inserting `sep` in-between. If `count` == 0,
 * returns an empty string.
 * (chainable)
 *
 *     str_repeat(@"hello", 0, @"")  =>  @""
 *     str_repeat(@"foo", 3, @",")   =>  @"foo,foo,foo"
 */
NSString *str_repeat(NSString *str, NSUInteger count, NSString *sep);

/* Cut the string into pieces, `count` characters each. If `count` == 0, returns an
 * array containing the original string.
 *
 *     str_chop(@"hello", 1)  =>  array(@"h", @"e", @"l", @"l", @"o")
 *     str_chop(@"hello", 3)  =>  array(@"hel", @"lo")
 */
NSArray *str_chop(NSString *str, NSUInteger count);


NSString *str_trim(NSString *s);

NSString *str_chain(NSString *s);
NSString *str_chain_block(NSString *s, void (^block)(NSMutableString *s));
NSMutableString *str_chain_fast(NSMutableString *s);
NSMutableString *str_chain_block_fast(NSMutableString *s, void (^block)(NSMutableString *s));
NSString *str_unchain(NSString *s);

void str_ltrim_d(NSMutableString *s);
void str_rtrim_d(NSMutableString *s);


/** The functions below are not chainable **/

/* Make every word in the string begin with an upper case letter, other
 * characters in the word are forced to lowercase. Synonym for
 * [str capitalizedString].
 *
 *     str_titlecase(@"one two")  =>  @"One Two"
 */
NSString *str_titlecase(NSString *str);

/* Convert the string to lower case. Synonym for [str lowercaseString].
 *
 *     str_lowercase(@"HellO")  =>  @"hello"
 */
NSString *str_lowercase(NSString *str);

/* Convert the string to upper case. Synonym for [str uppercaseString].
 *
 *     str_uppercase(@"HellO")  =>  @"HELLO"
 */
NSString *str_uppercase(NSString *str);

/* Swap the case of each letter in str.
 *
 *     str_swapcase(@"Hello")  =>  @"hELLO"
 */
NSString *str_swapcase(NSString *str);
