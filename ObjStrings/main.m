#import <Foundation/Foundation.h>
#import "ObjString.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {        
        NSLog(@"%@", [@"test string String" capitalizedString]);
        NSLog(@"count = %d", [@"hello world" count:@"l"]);
        NSLog(@"%@", [@", " join:[@"apple orange donut" split]]);
        NSLog(@"%@", [@"foo" repeat:3]);
        NSLog(@"%@", [@"foo" repeat:3 sep:@"bar"]);
        NSLog(@"%@", [@"\tfoo = bar;" expandTabs:2]);
        NSLog(@"%@", [@"Hello, Joe. How's your mom, Joe?" replace:@"Joe" with:@"Bill"]);
        
        
        NSString *testStr = @"\tapple orange plum \n";
        
        // Without chaining, 5 temporary strings are allocated during this sequence
        // of string transformations
        NSString *newStr1 = [[[[[testStr trim] replace:@"plum" with:@"donut"] capitalize] replace:@" " with:@", "] append:@"."];
        NSLog(@"%@", newStr1);
        NSCAssert([newStr1 isEqualToString:@"Apple, orange, donut."], @"");
        
        // With chaining, we get only 1 amortized allocation total (not taking into account internal
        // allocations that happen for the unchained version too)
        // The result is the same.
        NSString *chained = [[[[[[testStr chain] trim] replace:@"plum" with:@"donut"] capitalize] replace:@" " with:@", "] append:@"."];
        NSString *newStr2 = [chained unchain];
        NSLog(@"%@", newStr2);
        NSCAssert([newStr2 isEqualToString:@"Apple, orange, donut."], @"");
    }
    return 0;
}

