#import "bench.h"


NSString *splice(NSString *str)
{
    return [str splice:NSMakeRange(0, 5) with:@"¡hola"];
}

NSString *stock_splice(NSString *str)
{
    return [str stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@"¡hola"];
}

DEFBENCH(
    STOCK_PAIR(@"replaceCharactersInRange:withString:", stock_splice)
    , @"str_splice"
    , @"hello world!"
    , @"¡hola world!"
    , splice
    , NULL
    )
