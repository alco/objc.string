#import <Foundation/Foundation.h>


@interface NSMutableString(ObjCString)

/*
 * Chaining support with 0 allocations.
 */

- (NSMutableString *)chain_fast;
- (NSMutableString *)chain_fast:(void (^)(NSMutableString *s))block;

@end
