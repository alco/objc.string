#import "ObjString.h"
#import <objc/runtime.h>


#define WHOLE_RANGE(str) NSMakeRange(0, [(str) length])
static int objective_string_chain_flag;

#define IS_CHAINING objc_getAssociatedObject(self, &objective_string_chain_flag)


@implementation NSString(ObjectiveString)

- (NSString *)append:(NSString *)str
{
    return [self stringByAppendingString:str];
}

- (NSString *)capitalize
{
    NSMutableString *str = [NSMutableString stringWithCapacity:[self length]];
    [str appendString:[[self substringToIndex:1] capitalizedString]];
    [str appendString:[self substringFromIndex:1]];
    return str;
}

#pragma mark

- (NSArray *)split
{
    return [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSArray *)split:(NSString *)separator
{
    return [self componentsSeparatedByString:separator];
}

- (NSArray *)split:(NSString *)separator times:(int)times
{
    if (times == 0)
        return [NSArray arrayWithObject:self];
    // ...
    return nil;
}

#pragma mark

- (NSString *)expandTabs
{
    return [self expandTabs:4];
}

- (NSString *)expandTabs:(int)tabsize
{
    NSString *space = [@" " repeat:tabsize];
    return [self stringByReplacingOccurrencesOfString:@"\t" withString:space];
}

#pragma mark

- (NSString *)replace:(NSString *)substr with:(NSString *)newstr
{
    return [self stringByReplacingOccurrencesOfString:substr withString:newstr];
}

#pragma mark

- (NSString *)join:(NSArray *)components
{
    return [components componentsJoinedByString:self];
}

- (NSString *)repeat:(int)count
{
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:[self length] * count];
    for (int i = 0; i < count; ++i)
        [result appendString:self];
    return result;
}

- (NSString *)repeat:(int)count sep:(NSString *)separator
{
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:([self length] + [separator length]) * count];
    for (int i = 0; i < count-1; ++i) {
        [result appendString:self];
        [result appendString:separator];
    }
    [result appendString:self];
    return result;
}

#pragma mark

// Should be invoked on a temporary mutable or chained string
static void _ltrim(NSMutableString *str)
{
    unsigned i;
    // Find the first non-whitespace character
    for (i = 0; i < [str length]; ++i) {
        unichar c = [str characterAtIndex:i];
        if (c == '\t' || c == '\v' || c == '\n' || c == '\r' || c == ' ')
            continue;
        break;
    }
    [str deleteCharactersInRange:NSMakeRange(0, i)];
}

// Should be invoked on a temporary mutable or chained string
static void _rtrim(NSMutableString *str)
{
    if ([str length] < 1)
        return;
    
    int i;
    for (i = [str length] - 1; i >= 0; --i) {
        unichar c = [str characterAtIndex:i];
        if (c == '\t' || c == '\v' || c == '\n' || c == '\r' || c == ' ')
            continue;
        break;
    }
    ++i;
    [str deleteCharactersInRange:NSMakeRange(i, [str length] - i)];
}

- (NSString *)trim
{
    if (IS_CHAINING) {
        NSLog(@">>> Chaining trim <<<");
        NSMutableString *str = (NSMutableString *)self;
        _ltrim(str);
        _rtrim(str);
        return str;
    }
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (int)count:(NSString *)substr
{
    int count = 0;
    NSRange strRange = WHOLE_RANGE(self);
    int len = strRange.length;
    do {
        NSRange range = [self rangeOfString:substr options:0 range:strRange];
        if (range.location == NSNotFound)
            break;
        ++count;
        int new_loc = range.location + range.length;
        strRange.location = new_loc;
        strRange.length = len - new_loc;
    } while (1);

    return count;
}

#pragma mark

- (NSString *)chain
{
    // Set up an associated flag so that other methods know that self is being chained
    NSMutableString *str = [NSMutableString stringWithString:self];
    objc_setAssociatedObject(str, &objective_string_chain_flag, @"", OBJC_ASSOCIATION_ASSIGN);
    return str;
}

- (NSString *)unchain
{
    objc_setAssociatedObject(self, &objective_string_chain_flag, nil, OBJC_ASSOCIATION_ASSIGN);
    return self;
}

@end
