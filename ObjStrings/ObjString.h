#import <Foundation/Foundation.h>

@interface NSString(ObjectiveString)

- (NSString *)append:(NSString *)str;

- (NSString *)capitalize;

- (NSArray *)split;
- (NSArray *)split:(NSString *)separator;
- (NSArray *)split:(NSString *)separator times:(int)times;

- (NSString *)expandTabs;
- (NSString *)expandTabs:(int)tabsize;

- (NSString *)replace:(NSString *)substr with:(NSString *)newstr;

- (NSString *)join:(NSArray *)components;

- (NSString *)repeat:(int)count;
- (NSString *)repeat:(int)count sep:(NSString *)separator;

- (NSString *)trim;
- (int)count:(NSString *)substr;

// The -chain method makes it possible to reduce the number of object allocations
// when performing a sequence of string operations. The returned object can be
// treated as an ordinary string, but it will be mutated in-place but the
// ObjectiveString methods. To get back a clean string, use the -value method.
- (NSString *)chain;
- (NSString *)unchain;

@end
