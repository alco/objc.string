#import "str_funs.h"
#import <objc/runtime.h>


#define WHOLE_RANGE(str) NSMakeRange(0, [(str) length])
#define IS_WHITESPACE(c) (c == ' ' || c == '\t' || c == '\n' || c == '\f' || c == '\r')

#define IS_CHAINING(str) objc_getAssociatedObject(str, &objc_string_chain_flag)
static int objc_string_chain_flag;


void str_ltrim_d(NSMutableString *s);
void str_rtrim_d(NSMutableString *s);


NSString *str_append(NSString *s1, NSString *s2)
{
    if (IS_CHAINING(s1)) {
        NSMutableString *str = (NSMutableString *)s1;
        [str appendString:s2];
        return str;
    }
    return [s1 stringByAppendingString:s2];
}

NSString *str_capitalize(NSString *s)
{
    NSMutableString *str;
    if (IS_CHAINING(s)) {
        str = (NSMutableString *)s;
    } else {
        str = [NSMutableString stringWithString:s];
    }
    [str replaceCharactersInRange:NSMakeRange(0, 1) withString:[[s substringToIndex:1] uppercaseString]];
    return str;
}

NSString *str_compress(NSString *s)
{
    return str_replace(s, $regex(@"\\s+"), @" ");
}

NSString *str_cut(NSString *s, NSRange range)
{
    if (IS_CHAINING(s)) {
        NSMutableString *str = (NSMutableString *)s;
        [str deleteCharactersInRange:NSMakeRange(0, range.location)];
        [str deleteCharactersInRange:NSMakeRange(range.length, [s length] - range.length)];
        return str;
    }
    return [s substringWithRange:range];
}

NSString *str_cut_from(NSString *s, NSUInteger position)
{
    if (IS_CHAINING(s)) {
        NSMutableString *str = (NSMutableString *)s;
        [str deleteCharactersInRange:NSMakeRange(0, position)];
        return str;
    }
    return [s substringFromIndex:position];
}

NSString *str_cut_to(NSString *s, NSUInteger position)
{
    if (IS_CHAINING(s)) {
        NSMutableString *str = (NSMutableString *)s;
        [str deleteCharactersInRange:NSMakeRange(position, [s length] - position)];
        return str;
    }
    return [s substringToIndex:position];
}

NSString *str_delete(NSString *s, NSRange range)
{
    return str_splice(s, range, @"");
}

NSString *str_expand_tabs(NSString *s, NSUInteger tabsize)
{
    NSString *tab_str = str_repeat(@" ", tabsize, @"");
    return str_replace(s, @"\t", tab_str);
}

NSString *str_filter(NSString *s, NSString *charstr)
{
    return str_filter_chars(s, [NSCharacterSet characterSetWithCharactersInString:charstr]);
}

NSString *str_filter_chars(NSString *s, NSCharacterSet *chars)
{
    NSMutableString *str;
    if (IS_CHAINING(s)) {
        str = (NSMutableString *)s;
    } else {
        str = [NSMutableString stringWithString:s];
    }

    // This is a fast way to get access to string characters
    CFStringInlineBuffer buf;
    CFRange whole_range = { 0, [str length] };
    CFStringInitInlineBuffer((CFStringRef)str, &buf, whole_range);

    NSUInteger len = [str length], offset = 0;
    for (NSUInteger index = 0; index < len; ++index) {
        unichar c = (unichar)CFStringGetCharacterFromInlineBuffer(&buf, index);
        if ([chars characterIsMember:c]) {
            [str deleteCharactersInRange:NSMakeRange(index - offset, 1)];
            ++offset;
        }
    }

    return str;
}

NSString *str_insert(NSString *s, NSString *newstr, NSUInteger position)
{
    return str_splice(s, NSMakeRange(position, 0), newstr);
}

NSString *str_lowercase(NSString *s)
{
    if (IS_CHAINING(s)) {
        CFMutableStringRef str = (CFMutableStringRef)s;
        CFLocaleRef locale = CFLocaleCopyCurrent();
        CFStringLowercase(str, locale);
        CFRelease(locale);
        return s;
    }
    return [s lowercaseString];
}

NSString *str_repeat(NSString *s, NSUInteger count, NSString *sep)
{
    NSMutableString *str;
    if (IS_CHAINING(s)) {
        str = (NSMutableString *)s;
    } else {
        if (count == 0)
            return @"";
        str = [NSMutableString stringWithCapacity:([s length] + [sep length]) * count];
    }

    if (count == 0) {
        [str setString:@""];
        return str;
    }

    for (NSUInteger i = 0; i < count - 1; ++i) {
        [str appendString:s];
        [str appendString:sep];
    }
    [str appendString:s];

    return str;
}

NSString *str_replace(NSString *s, NSString *substr, NSString *repl)
{
    NSMutableString *str;
    if (IS_CHAINING(s)) {
        str = (NSMutableString *)s;
    } else {
        str = [NSMutableString stringWithString:s];
    }

    if ([substr isKindOfClass:[NSRegularExpression class]])
        [(NSRegularExpression *)substr replaceMatchesInString:str
                                                      options:0
                                                        range:WHOLE_RANGE(str)
                                                 withTemplate:repl];
    else
        [str replaceOccurrencesOfString:substr withString:repl options:0 range:WHOLE_RANGE(str)];
    return str;
}

NSString *str_reverse(NSString *s)
{
    // *** IMPORTANT ***
    // Currently, to keep the invariant of the chained string, we append characters
    // to s when it is being chained. A more efficient way might to create a new string
    // with the CFStringCreateMutableWithExternalCharactersNoCopy function. However,
    // this would break the single-pointer invariant.

    // This is a fast way to get access to string characters
    NSUInteger len = [s length];
    CFRange whole_range = { 0, len };
    CFStringInlineBuffer buf;
    CFStringInitInlineBuffer((CFStringRef)s, &buf, whole_range);

    UniChar *chars = (UniChar *)malloc(whole_range.length * sizeof(UniChar));
    for (NSUInteger index = 0; index < len; ++index) {
        UniChar c = CFStringGetCharacterFromInlineBuffer(&buf, index);
        chars[len - index - 1] = c;
    }

    if (IS_CHAINING(s)) {
        CFMutableStringRef str = (CFMutableStringRef)s;
        CFStringDelete(str, whole_range);
        CFStringAppendCharacters(str, chars, len);
        return (NSString *)str;
    } else {
        return (NSString *)CFStringCreateWithCharactersNoCopy(kCFAllocatorDefault, chars, len, kCFAllocatorMalloc);
    }
}

NSString *str_splice(NSString *s, NSRange range, NSString *newstr)
{
    NSMutableString *str;
    if (IS_CHAINING(s)) {
        str = (NSMutableString *)s;
    } else {
        str = [NSMutableString stringWithString:s];
    }
    [str replaceCharactersInRange:range withString:newstr];
    return str;
}

NSString *str_titlecase(NSString *s)
{
    CFMutableStringRef str;
    if (IS_CHAINING(s)) {
        str = (CFMutableStringRef)s;
    } else {
        str = (CFMutableStringRef)[NSMutableString stringWithString:s];
    }
    // First, force every character to lowercase. Then, capitalize the first
    // letter of each word.
    CFLocaleRef locale = CFLocaleCopyCurrent();
    CFStringCapitalize(str, locale);
    CFRelease(locale);

    return (NSString *)str;
}

NSString *str_ltrim(NSString *s)
{
    return str_replace(s, $regex(@"^\\s+"), @"");
}

NSString *str_rtrim(NSString *s)
{
    return str_replace(s, $regex(@"\\s+$"), @"");
}

NSString *str_trim(NSString *s)
{
    if (IS_CHAINING(s)) {
        NSMutableString *str = (NSMutableString *)s;
        str_ltrim_d(str);
        str_rtrim_d(str);
        return str;
    }
    return [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

NSString *str_uppercase(NSString *s)
{
    if (IS_CHAINING(s)) {
        CFMutableStringRef str = (CFMutableStringRef)s;
        CFLocaleRef locale = CFLocaleCopyCurrent();
        CFStringUppercase(str, locale);
        CFRelease(locale);
        return s;
    }
    return [s uppercaseString];
}

#pragma mark

NSString *str_chain(NSString *s)
{
    // Set up an associated flag so that other methods know that the string is being chained
    NSMutableString *str = [NSMutableString stringWithString:s];
    objc_setAssociatedObject(str, &objc_string_chain_flag, @"", OBJC_ASSOCIATION_ASSIGN);
    return str;
}

NSString *str_chain_block(NSString *s, void (^block)(NSString *s))
{
    NSString *str = str_chain(s);
    block(str);
    return str_unchain(str);
}

NSMutableString *str_chain_fast(NSMutableString *s)
{
    // Same as str_chain, but don't create a new string
    objc_setAssociatedObject(s, &objc_string_chain_flag, @"", OBJC_ASSOCIATION_ASSIGN);
    return s;
}

NSMutableString *str_chain_block_fast(NSMutableString *s, void (^block)(NSMutableString *s))
{
    block(str_chain_fast(s));
    return (NSMutableString *)str_unchain(s);
}

NSString *str_unchain(NSString *s)
{
    id ref = objc_getAssociatedObject(s, &objc_string_chain_flag);
    NSCAssert(ref, @"Trying to unchain a string that was not chained.");

    objc_setAssociatedObject(s, &objc_string_chain_flag, nil, OBJC_ASSOCIATION_ASSIGN);
    return s;
}

#pragma mark -

NSString *str_join(NSString *s, NSArray *components)
{
    return [components componentsJoinedByString:s];
}

NSArray *str_chop(NSString *s, NSUInteger count)
{
    if (count == 0)
        return [NSArray arrayWithObject:s];

    NSUInteger len = [s length];
    NSUInteger residual = len % count;
    NSUInteger i;

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:len/count + 1];
    for (i = 0; i < len - residual; i += count)
        [array addObject:[s substringWithRange:NSMakeRange(i, count)]];
    if (residual > 0)
        [array addObject:[s substringFromIndex:i]];
    return array;
}

NSArray *str_split_space(NSString *s)
{
    NSRegularExpression *regex = (NSRegularExpression *)$regex(@"\\s+");
    static const NSUInteger kAverageWordLength = 6;

    __block NSUInteger position = 0;
    NSMutableArray *components = [NSMutableArray arrayWithCapacity:[s length] / kAverageWordLength];
    [regex enumerateMatchesInString:s options:0 range:WHOLE_RANGE(s) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange subrange = NSMakeRange(position, result.range.location - position);
        [components addObject:[s substringWithRange:subrange]];
        position = result.range.location + result.range.length;
    }];
    if (position < [s length])
        [components addObject:[s substringFromIndex:position]];
    else
        [components addObject:@""];
    return components;
}

NSArray *str_split_lines(NSString *s)
{
    return [s componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

NSArray *str_split(NSString *s, NSString *sep, NSUInteger count)
{
    if (count == 0)
        return [NSArray arrayWithObject:s];

    NSArray *components = [s componentsSeparatedByString:sep];
    if (count >= components.count - 1)
        return components;

    NSMutableArray *rest_components = [NSMutableArray arrayWithArray:components];
    [rest_components removeObjectsInRange:NSMakeRange(0, count)];
    NSString *rest = str_join(sep, rest_components);

    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count + 1];
    NSUInteger i = 0;
    for (NSString *str in components) {
        [result addObject:str];
        if (++i == count)
            break;
    }
    [result addObject:rest];
    return result;
}

#pragma mark -

NSUInteger str_count(NSString *s, NSString *substr)
{
    NSUInteger count = 0;
    NSRange strRange = WHOLE_RANGE(s);
    int len = strRange.length;
    do {
        NSRange range = [s rangeOfString:substr options:0 range:strRange];
        if (range.location == NSNotFound)
            break;
        ++count;
        int new_loc = range.location + range.length;
        strRange.location = new_loc;
        strRange.length = len - new_loc;
    } while (1);

    return count;
}

BOOL str_is_blank(NSString *s)
{
    NSRegularExpression *regex = (NSRegularExpression *)$regex(@"^\\s*$");
    NSUInteger match_count = [regex numberOfMatchesInString:s options:0 range:WHOLE_RANGE(s)];
    return match_count == 1;
}

#pragma mark -

// Should be invoked on a temporary mutable or chained string
void str_ltrim_d(NSMutableString *s)
{
    NSUInteger i, len = [s length];
    // Find the first non-whitespace character
    for (i = 0; i < len; ++i) {
        unichar c = [s characterAtIndex:i];
        if (!IS_WHITESPACE(c))
            break;
    }
    [s deleteCharactersInRange:NSMakeRange(0, i)];
}

// Should be invoked on a temporary mutable or chained string
void str_rtrim_d(NSMutableString *s)
{
    NSUInteger len = [s length];
    if (len < 1)
        return;

    NSInteger i;
    for (i = len - 1; i >= 0; --i) {
        unichar c = [s characterAtIndex:i];
        if (!IS_WHITESPACE(c))
            break;
    }
    ++i;
    [s deleteCharactersInRange:NSMakeRange(i, len - i)];
}
