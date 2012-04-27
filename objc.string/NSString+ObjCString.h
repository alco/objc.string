#import <Foundation/Foundation.h>


@interface NSString(ObjCString)

/*
 * The core string methods. All are chainable.
 */

- (NSString *)append:(NSString *)str;
- (NSString *)capitalize;

/*
 * Center `str` in a string of length `width`. Use `ch` as a filling character.
 * (chainable)
 *
 *     str_center(@"hello", 10, @" ")  =>  @"   hello  "
 */
- (NSString *)center:(NSUInteger)width;
- (NSString *)center:(NSUInteger)width with:(NSString *)character;
- (NSString *)compress;
- (NSString *)cut:(NSRange)range;
- (NSString *)cutFrom:(NSUInteger)position;
- (NSString *)cutTo:(NSUInteger)position;

/*
 * Same as str_splice(str, range, @"").
 * (chainable)
 *
 *     str_delete(@"foobar", NSMakeRange(3, 3))
 *     => @"foo"
 */
- (NSString *)delete:(NSRange)range;
- (NSString *)expandTabs;  // -expandTabs:4
- (NSString *)expandTabs:(NSUInteger)tabsize;
- (NSString *)filter:(NSString *)str;
- (NSString *)filterChars:(NSCharacterSet *)chars;

/*
 * Same as str_splice(str, NSMakeRange(position, 0), newstr).
 * (chainable)
 *
 *     str_insert(@"foo", @"bar", 2)
 *     => @"fobaro"
 */
- (NSString *)insert:(NSString *)str at:(NSUInteger)position;

/*
 * Left-justify `str` in a string of length `width` using `ch` as a filling character.
 * (chainable)
 *
 *     str_ljust(@"hello", 10, @"-")  =>  @"hello-----"
 */
- (NSString *)ljust:(NSUInteger)width;
- (NSString *)ljust:(NSUInteger)width with:(NSString *)character;

/*
 * Right-justify `str` in a string of length `width` using `ch` as a filling character.
 * (chainable)
 *
 *     str_rjust(@"hello", 10, @"-")  =>  @"-----hello"
 */
- (NSString *)rjust:(NSUInteger)width;
- (NSString *)rjust:(NSUInteger)width with:(NSString *)character;
- (NSString *)lowercase;
- (NSString *)repeat:(NSUInteger)count;
- (NSString *)repeat:(NSUInteger)count sep:(NSString *)separator;
- (NSString *)replace:(NSString *)substr with:(NSString *)repl;
- (NSString *)reverse;
- (NSString *)splice:(NSRange)range with:(NSString *)str;
- (NSString *)titlecase;
- (NSString *)ltrim;
- (NSString *)rtrim;
- (NSString *)trim;
- (NSString *)ltruncate:(NSUInteger)length;
- (NSString *)rtruncate:(NSUInteger)length;
- (NSString *)truncate:(NSUInteger)length;  // truncates in the middle
- (NSString *)uppercase;

/*
 * The chaining mechanism.
 */

- (NSString *)chain;
- (NSString *)chain:(void (^)(NSString *s))block;
- (NSString *)unchain;

#pragma mark -

/*
 * Various string <-> array methods.
 */

- (NSString *)join:(NSArray *)components;
- (NSArray *)chop;  // -chop:1
- (NSArray *)chop:(NSUInteger)count;
- (NSArray *)split;
- (NSArray *)splitLines;
- (NSArray *)split:(NSString *)separator;
- (NSArray *)split:(NSString *)separator times:(NSUInteger)times;

#pragma mark -

/*
 * Other utility methods.
 */

- (NSUInteger)count:(NSString *)substr;
- (BOOL)isBlank;
- (BOOL)has:(NSString *)substr;                // <--
- (BOOL)hasChars:(NSCharacterSet *)chars;      // <--
- (BOOL)hasOnlyChars:(NSCharacterSet *)chars;  // <--

- (BOOL)isAlpha;                               // <--
- (BOOL)isDigit;                               // <--
- (BOOL)isAlnum;                               // <--

@end
