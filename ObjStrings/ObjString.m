#import "ObjString.h"
#import "str_funs.h"


#define WHOLE_RANGE(str) NSMakeRange(0, [(str) length])


@implementation NSString(ObjectiveString)

- (NSString *)append:(NSString *)str {
    return str_append(self, str);
}
- (NSString *)capitalize {
    return str_capitalize(self);
}
- (NSString *)compress {
    return str_compress(self);
}
- (NSString *)expandTabs {
    return str_expand_tabs(self, 4);
}
- (NSString *)expandTabs:(NSUInteger)tabsize {
    return str_expand_tabs(self, tabsize);
}
- (NSString *)repeat:(NSUInteger)count {
    return str_repeat(self, count, @"");
}
- (NSString *)repeat:(NSUInteger)count sep:(NSString *)separator {
    return str_repeat(self, count, separator);
}
- (NSString *)replace:(NSString *)substr with:(NSString *)newstr {
    return str_replace(self, substr, newstr);
}
- (NSString *)ltrim {
    return str_ltrim(self);
}
- (NSString *)rtrim {
    return str_rtrim(self);
}
- (NSString *)trim {
    return str_trim(self);
}

#pragma mark -

- (NSString *)join:(NSArray *)components {
    return str_join(self, components);
}
- (NSArray *)chop {
    return str_chop(self, 1);
}
- (NSArray *)chop:(NSUInteger)count {
    return str_chop(self, count);
}
- (NSArray *)split {
    return str_split_space(self);
}
- (NSArray *)splitLines {
    return str_split_lines(self);
}
- (NSArray *)split:(NSString *)separator {
    return str_split(self, separator, NSIntegerMax);
}
- (NSArray *)split:(NSString *)separator times:(NSUInteger)times {
    return str_split(self, separator, times);
}

#pragma mark -

- (NSUInteger)count:(NSString *)substr
{
    return str_count(self, substr);
}

#pragma mark

- (NSString *)chain {
    return str_chain(self);
}
- (NSString *)chain:(void (^)(NSString *s))block {
    return str_chain_block(self, block);
}
- (NSString *)unchain {
    return str_unchain(self);
}

@end
