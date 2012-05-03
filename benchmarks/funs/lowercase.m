#import "bench.h"

NSString *stock(NSString *str)
{
    return [str lowercaseString];
}

NSString *basic_impl(NSString *str)
{
    return [str lowercase];
}

///

"HELLO WORLD!" -> "hello world!"

"lowercaseString", stock

"lowercase"
basic_impl
