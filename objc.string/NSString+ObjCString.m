#import "NSString+ObjCString.h"
#import "str_funs.h"


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
- (NSString *)delete:(NSRange)range {
    return str_delete(self, range);
}
- (NSString *)expandTabs {
    return str_expand_tabs(self, 4);
}
- (NSString *)expandTabs:(NSUInteger)tabsize {
    return str_expand_tabs(self, tabsize);
}
- (NSString *)insert:(NSString *)str at:(NSUInteger)position {
    return str_insert(self, str, position);
}
- (NSString *)lowercase {
    return str_lowercase(self);
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
- (NSString *)splice:(NSRange)range with:(NSString *)str {
    return str_splice(self, range, str);
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
- (NSString *)uppercase {
    return str_uppercase(self);
}

#pragma mark -

- (NSString *)chain {
    return str_chain(self);
}
- (NSString *)chain:(void (^)(NSString *s))block {
    return str_chain_block(self, block);
}
- (NSString *)unchain {
    return str_unchain(self);
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

- (BOOL)isBlank
{
    return str_is_blank(self);
}

@end
