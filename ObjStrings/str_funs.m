#import "str_funs.h"
#import <objc/runtime.h>


#define WHOLE_RANGE(str) NSMakeRange(0, [(str) length])
#define IS_WHITESPACE(c) (c == '\t' || c == '\v' || c == '\n' || c == '\r' || c == ' ')

#define IS_CHAINING(str) objc_getAssociatedObject(str, &objective_string_chain_flag)
static int objective_string_chain_flag;


NSString *str_append(NSString *s1, NSString *s2)
{
    if (IS_CHAINING(s1)) {
        NSLog(@">>> Chainging append <<<");
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
        NSLog(@">>> Chaining capitalize <<<");
        str = (NSMutableString *)s;
    } else {
        str = [NSMutableString stringWithString:s];
    }
    [str replaceCharactersInRange:NSMakeRange(0, 1) withString:[[s substringToIndex:1] uppercaseString]];
    return str;
}

NSString *str_compress(NSString *s)
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+" 
                                                                           options:0
                                                                             error:NULL];
    NSMutableString *str;
    if (IS_CHAINING(s)) {
        NSLog(@">>> Chaining compress <<<");
        str = (NSMutableString *)s;
    } else {
        str = [NSMutableString stringWithString:s];
    }
    [regex replaceMatchesInString:str options:0 range:WHOLE_RANGE(str) withTemplate:@" "];
    return str;
}

NSString *str_replace(NSString *s, NSString *substr, NSString *repl)
{
    NSMutableString *str;
    if (IS_CHAINING(s)) {
        NSLog(@">>> Chaining replace <<<");
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

NSString *str_repeat(NSString *s, NSUInteger count, NSString *sep)
{
    NSMutableString *str;
    if (IS_CHAINING(s)) {
        NSLog(@">>> Chaining repeat <<<");
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

#pragma mark -

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


#pragma mark


#pragma mark

NSString *str_trim(NSString *s)
{
    if (IS_CHAINING(s)) {
        NSLog(@">>> Chaining trim <<<");
        NSMutableString *str = (NSMutableString *)s;
        str_ltrim_d(str);
        str_rtrim_d(str);
        return str;
    }
    return [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark

NSString *str_chain(NSString *s)
{
    // Set up an associated flag so that other methods know that self is being chained
    NSMutableString *str = [NSMutableString stringWithString:s];
    objc_setAssociatedObject(str, &objective_string_chain_flag, @"", OBJC_ASSOCIATION_ASSIGN);
    return str;
}

NSString *str_chain_block(NSString *s, void (^block)(NSMutableString *s))
{
    NSString *str = str_chain(s);
    block((NSMutableString *)str);
    return str_unchain(str);
}

NSMutableString *str_chain_fast(NSMutableString *s)
{
    objc_setAssociatedObject(s, &objective_string_chain_flag, @"", OBJC_ASSOCIATION_ASSIGN);
    return s;
}

NSMutableString *str_chain_block_fast(NSMutableString *s, void (^block)(NSMutableString *s))
{
    block(str_chain_fast(s));
    return (NSMutableString *)str_unchain(s);
}

NSString *str_unchain(NSString *s)
{
    id ref = objc_getAssociatedObject(s, &objective_string_chain_flag);
    NSCAssert(ref, @"Trying to unchain a string that was not chained.");

    objc_setAssociatedObject(s, &objective_string_chain_flag, nil, OBJC_ASSOCIATION_ASSIGN);
    return s;
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
