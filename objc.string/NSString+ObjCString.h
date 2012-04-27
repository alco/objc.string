#import <Foundation/Foundation.h>


@interface NSString(ObjCString)

/* ***
 * For a description of each method see str_funs.h.
 * ***
 */

/*
 * The methods below are all chainable.
 */

typedef enum {
    kTruncateLeft,
    kTruncateMiddle,
    kTruncateRight
} TruncateFlag;

- (NSString *)append:(NSString *)str;
- (NSString *)capitalize;
- (NSString *)center:(NSUInteger)width;
- (NSString *)center:(NSUInteger)width with:(NSString *)character;
- (NSString *)compress;
- (NSString *)cut:(NSRange)range;
- (NSString *)cutFrom:(NSUInteger)position;
- (NSString *)cutTo:(NSUInteger)position;
- (NSString *)delete:(NSRange)range;
- (NSString *)expandTabs;  // -expandTabs:4
- (NSString *)expandTabs:(NSUInteger)tabsize;
- (NSString *)filter:(NSString *)str;
- (NSString *)filterChars:(NSCharacterSet *)chars;
- (NSString *)insert:(NSString *)str at:(NSUInteger)position;
- (NSString *)ljust:(NSUInteger)width;
- (NSString *)ljust:(NSUInteger)width with:(NSString *)character;
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
- (NSString *)truncate:(NSUInteger)length;  // truncate:length at:kTruncateRight
- (NSString *)truncate:(NSUInteger)length at:(TruncateFlag)flag;
- (NSString *)uppercase;

/*
 * Chaining mechanism.
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
