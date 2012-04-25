#import <Foundation/Foundation.h>


@interface NSString(ObjCString)

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

// The -chain method makes it possible to reduce the number of object allocations
// when performing a sequence of string operations. The returned object can be
// treated as an ordinary string, but it will be mutated in-place but the
// ObjectiveString methods. To get back a clean string, use the -value method.
- (NSString *)chain;
- (NSString *)chain:(void (^)(NSString *s))block;
- (NSString *)unchain;

@end