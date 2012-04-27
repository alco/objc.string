#import "NSMutableString+ObjCString.h"
#import "str_primitives.h"


@implementation NSMutableString(ObjcString)

- (NSMutableString *)chain_fast {
    return str_chain_fast(self);
}
- (NSMutableString *)chain_fast:(void (^)(NSMutableString *s))block {
    return str_chain_block_fast(self, block);
}

@end
