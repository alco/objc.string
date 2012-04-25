#import <Foundation/Foundation.h>


#define $regex(pattern) ((NSString *)[NSRegularExpression regularExpressionWithPattern:pattern \
                                                                               options:0       \
                                                                                 error:NULL])

/*
 * *** General notes ***
 *
 * 1. Whitespace.
 *
 * Whitespace is defined by NSRegularExpression as [ \t\n\f\r\p{Z}] where \p{Z}
 * is defined as "any kind of whitespace or invisible separator".
 */

/* ***
 * The functions below are all chainable.
 * ***
 */

/*
 * Append `s2` after `s1`. Synonym for [s1 stringByAppendingString:s2].
 * (chainable)
 *
 *     str_append(@"foo", @"bar")  =>  @"foobar"
 */
NSString *str_append(NSString *s1, NSString *s2);

/*
 * Capitalize the first character in `str` (only if it's a letter).
 * (chainable)
 *
 *     str_capitalize(@"one two")  =>  @"One two"
 */
NSString *str_capitalize(NSString *str);

/*
 * Compress adjacent whitespace into one space.
 * (chainable)
 *
 *     str_compress(@"\thello  \t world  ")  =>  @" hello world "
 */
NSString *str_compress(NSString *str);

/*
 * Replace tabs with `tabsize` number of spaces in `str`.
 * (chainable)
 *
 *     str_expand_tabs(@"\tx = 1;", 2)  =>  @"  x = 1;"
 */
NSString *str_expand_tabs(NSString *str, NSUInteger tabsize);

/*
 * Repeat the string `count` times, inserting `sep` in-between. If `count` == 0,
 * returns an empty string.
 * (chainable)
 *
 *     str_repeat(@"hello", 0, @"")  =>  @""
 *     str_repeat(@"foo", 3, @",")   =>  @"foo,foo,foo"
 */
NSString *str_repeat(NSString *str, NSUInteger count, NSString *sep);

/*
 * Replace ocurrences of `pattern` with `repl`. `pattern` can be a string or a
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

/*
 * Trim whitespace at the beginning of `str`.
 * (chainable)
 *
 *     str_ltrim(@"\t\n  hello\r\v \b")  =>  @"hello\r\v \b"
 */
NSString *str_ltrim(NSString *str);

/*
 * Trim whitespace at the end of `str`.
 * (chainable)
 *
 *     str_rtrim(@"\t\n  hello\r\v \b")  =>  @"\t\n  hello"
 */
NSString *str_rtrim(NSString *str);

/*
 * Trim whitespace from `str` at both ends.
 * (chainable)
 *
 *     str_trim(@"\t\n  hello\r\v \b")  =>  @"hello"
 */
NSString *str_trim(NSString *str);

/* ***
 * Various string <-> array functions.
 * ***
 */

/*
 * Join the strings in the given array into one string interleaving them with `sep`.
 *
 *     str_join(@",", array(@"a", @"b", @"c"))  =>  @"a,b,c"
 *     str_join(@"", array(@"foo", @"bar"))     =>  @"foobar"
 */
NSString *str_join(NSString *sep, NSArray *components);

/*
 * Cut the string into pieces, `count` characters each. If `count` == 0, returns an
 * array containing the original string.
 *
 *     str_chop(@"hello", 1)  =>  array(@"h", @"e", @"l", @"l", @"o")
 *     str_chop(@"hello", 3)  =>  array(@"hel", @"lo")
 */
NSArray *str_chop(NSString *str, NSUInteger count);

/*
 * Split the string at whitespace.
 *
 *     str_split_space(@"a \t b\nc   d\r")  =>  array(@"a", @"b", @"c", @"d", @""))
 */
NSArray *str_split_space(NSString *str);

/*
 * Split the string at line breaks.
 *
 *     str_split_lines(@"a\n c\nd\n")  =>  array(@"a", @" b", @"d", @""))
 */
NSArray *str_split_lines(NSString *str);

/*
 * Split the string at each occurrence of `sep`. Perform at most `count` splits.
 *
 *     str_split(@"a,b,c", @",", 0)             =>  array(@"a,b,c")
 *     str_split(@"a,b,c", @",", NSIntegerMax)  =>  array(@"a", @"b", @"c")
 */
NSArray *str_split(NSString *str, NSString *sep, NSUInteger count);

/* ***
 * Other utility functions.
 * ***
 */

/*
 * Count the number of occurrences of `substr` in `str`.
 *
 *     str_count(@"hello", @"l")  =>  2
 *     str_count(@"hello", @"0")  =>  0
 */
NSUInteger str_count(NSString *str, NSString *substr);

/* ***
 * Chaining mechanism.
 * ***
 */

/*
 * The str_chain function makes it possible to reduce the number of object
 * allocations when performing a sequence of string operations. The returned
 * object can be treated as an ordinary string, but it will be modified
 * in-place. To get back a clean string, use the str_unchain function.
 *
 * To keep your sanity, please don't let a chained string escape the scope it
 * was defined in. This means that for each call to str_chain (or
 * str_chain_fast) there should be a corresponding call to str_unchain in the
 * same function scope. When using str_chain_block and str_chain_block_fast,
 * this invariant is kept for you automatically, so you don't need to call
 * str_unchain yourself.
 */
NSString *str_chain(NSString *str);

/*
 * str_chain_block allows you to perform a series of operations on a chained
 * string in one block.  The benefit of this is to make sure that a chained
 * string does not leave the scope of the function it is created in.
 *
 * When using this function, you don't need to call str_unchain.
 */
NSString *str_chain_block(NSString *str, void (^block)(NSString *str));

/*
 * This function works similarly to str_chain except that it modified the
 * mutable string you pass to it.
 */
NSMutableString *str_chain_fast(NSMutableString *str);

/*
 * This works similarly to str_chain_block with the same optimizations applied
 * as in str_chain_fast.
 */
NSMutableString *str_chain_block_fast(NSMutableString *str, void (^block)(NSMutableString *str));

/*
 * Unchain `str` and return it. Successive string operations on `str` will not
 * modify it in place anymore.
 */
NSString *str_unchain(NSString *str);


/** The functions below are not chainable **/

/*
 * Make every word in the string begin with an upper case letter, other
 * characters in the word are forced to lowercase. Synonym for
 * [str capitalizedString].
 *
 *     str_titlecase(@"one two")  =>  @"One Two"
 */
NSString *str_titlecase(NSString *str);

/*
 * Convert the string to lower case. Synonym for [str lowercaseString].
 *
 *     str_lowercase(@"HellO")  =>  @"hello"
 */
NSString *str_lowercase(NSString *str);

/*
 * Convert the string to upper case. Synonym for [str uppercaseString].
 *
 *     str_uppercase(@"HellO")  =>  @"HELLO"
 */
NSString *str_uppercase(NSString *str);

/*
 * Swap the case of each letter in str.
 *
 *     str_swapcase(@"Hello")  =>  @"hELLO"
 */
NSString *str_swapcase(NSString *str);
