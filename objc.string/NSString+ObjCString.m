#import "NSString+ObjCString.h"
#import "str_primitives.h"


@implementation NSString(ObjectiveString)

- (NSString *)append:(NSString *)str {
    return str_append(self, str);
}
- (NSString *)capitalize {
    return str_capitalize(self);
}
- (NSString *)center:(NSUInteger)width {
    return str_fill(self, width, @" ", kObjCStringMiddle);
}
- (NSString *)center:(NSUInteger)width with:(NSString *)character {
    return str_fill(self, width, character, kObjCStringMiddle);
}
- (NSString *)compress {
    return str_compress(self);
}
- (NSString *)cut:(NSRange)range {
    return str_cut(self, range);
}
- (NSString *)cutFrom:(NSUInteger)position {
    return str_cut_from(self, position);
}
- (NSString *)cutTo:(NSUInteger)position {
    return str_cut_to(self, position);
}
- (NSString *)delete:(NSRange)range {
    return str_splice(self, range, @"");
}
- (NSString *)expandTabs {
    return str_expand_tabs(self, 4);
}
- (NSString *)expandTabs:(NSUInteger)tabsize {
    return str_expand_tabs(self, tabsize);
}
- (NSString *)filter:(NSString *)str {
    return str_filter_chars(self, [NSCharacterSet characterSetWithCharactersInString:str]);
}
- (NSString *)filterChars:(NSCharacterSet *)chars {
    return str_filter_chars(self, chars);
}
- (NSString *)insert:(NSString *)str at:(NSUInteger)position {
    return str_splice(self, NSMakeRange(position, 0), str);
}
- (NSString *)ljust:(NSUInteger)width {
    return str_fill(self, width, @" ", kObjCStringLeft);
}
- (NSString *)ljust:(NSUInteger)width with:(NSString *)character {
    return str_fill(self, width, character, kObjCStringLeft);
}
- (NSString *)rjust:(NSUInteger)width {
    return str_fill(self, width, @" ", kObjCStringRight);
}
- (NSString *)rjust:(NSUInteger)width with:(NSString *)character {
    return str_fill(self, width, character, kObjCStringRight);
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
- (NSString *)reverse {
    return str_reverse(self);
}
- (NSString *)splice:(NSRange)range with:(NSString *)str {
    return str_splice(self, range, str);
}
- (NSString *)titlecase {
    return str_titlecase(self);
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
- (NSString *)ltruncate:(NSUInteger)length {
    return str_truncate(self, length, kObjCStringLeft);
}
- (NSString *)rtruncate:(NSUInteger)length {
    return str_truncate(self, length, kObjCStringRight);
}
- (NSString *)truncate:(NSUInteger)length {
    return str_truncate(self, length, kObjCStringMiddle);
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
- (NSArray *)partition:(NSString *)separator {
    return str_partition(self, separator, NSIntegerMax);
}
- (NSArray *)partition:(NSString *)separator times:(NSUInteger)times {
    return str_partition(self, separator, times);
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
