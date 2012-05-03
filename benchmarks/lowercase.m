#import "bench.h"


NSString *stock(NSString *str)
{
    return [str lowercaseString];
}

NSString *lib_impl(NSString *str)
{
    return [str lowercase];
}

// *** \\

"HELLO WORLD!" -> "hello world!"

"lowercaseString", stock

"lowercase"
lib_impl
