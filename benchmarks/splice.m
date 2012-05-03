#import "bench.h"


NSString *stock(NSString *str)
{
    return [str stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@"¡hola"];
}

NSString *lib_impl(NSString *str)
{
    return [str splice:NSMakeRange(0, 5) with:@"¡hola"];
}

// *** \\

"hello world!" -> "¡hola world!"

"replaceCharactersInRange:withString:", stock

"splice"
lib_impl
