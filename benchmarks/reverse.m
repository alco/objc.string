#import "bench.h"


NSString *lib_impl(NSString *str)
{
    return [str reverse];
}

NSString *alt_impl(NSString *str)
{
    NSMutableString *ms = [NSMutableString stringWithString:str];
    NSUInteger len = [ms length];
    for (NSUInteger i = 0; i < len; ++i) {
        [ms appendString:[ms substringWithRange:NSMakeRange(len-i-1, 1)]];
    }
    [ms deleteCharactersInRange:NSMakeRange(0, len)];
    return ms;
}

// *** \\

"hello world" -> "dlrow olleh"

NULL

"reverse"
lib_impl
alt_impl
