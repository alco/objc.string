#import <Foundation/Foundation.h>


@interface NSString(ObjCString)

/* ***
 * For the description of each method see str_funs.h.
 * ***
 */

/*
 * The methods below are all chainable.
 */

- (NSString *)append:(NSString *)str;
- (NSString *)capitalize;
- (NSString *)compress;
- (NSString *)expandTabs;  // -expandTabs:4
- (NSString *)expandTabs:(NSUInteger)tabsize;
- (NSString *)repeat:(NSUInteger)count;
- (NSString *)repeat:(NSUInteger)count sep:(NSString *)separator;
- (NSString *)replace:(NSString *)substr with:(NSString *)repl;
- (NSString *)ltrim;
- (NSString *)rtrim;
- (NSString *)trim;

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

/*
 * Chaining mechanism.
 */

- (NSString *)chain;
- (NSString *)chain:(void (^)(NSString *s))block;
- (NSString *)unchain;

@end
