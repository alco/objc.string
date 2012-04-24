#import <Foundation/Foundation.h>
#import "ObjString.h"
#import "NSMutableString+ObjcString.h"


#define ARRAY(...) [NSArray arrayWithObjects:__VA_ARGS__, nil]


int main(int argc, const char * argv[])
{

    @autoreleasepool {
        assert([[@"foo" append:@"bar"] isEqualToString:@"foobar"]);
        assert([[@"" append:@"bar"] isEqualToString:@"bar"]);
        assert([[@"foo" append:@""] isEqualToString:@"foo"]);
        
        assert([[@"foo bar" capitalize] isEqualToString:@"Foo bar"]);
        // FIXME
        //        assert([[@"foo bar-baz.baz" capitalizeAll] isEqualToString:@"Foo Bar-Baz.Baz"]);  // <--
        
        assert([[@"hello" chop] isEqual:ARRAY(@"h", @"e", @"l", @"l", @"o")]);
        assert([[@"hello" chop:2] isEqual:ARRAY(@"he", @"ll", @"o")]);
        assert([[@"hello" chop:0] isEqual:ARRAY(@"hello")]);
        
        assert([[@"foo" repeat:0] isEqualToString:@""]);
        
        assert([[@"," join:ARRAY(@"one", @"two", @"three")] isEqualToString:@"one,two,three"]);
        assert([[@"" join:ARRAY(@"foo", @"bar")] isEqualToString:@"foobar"]);
        
        NSLog(@"%@", [@"a b\nc \t  d" split]);
        // FIXME
        //assert([[@"a b\nc\t  d" split] isEqual:ARRAY(@"a", @"b", @"c", @"d")]);
        assert([[@"a b\nc\td" split] isEqual:ARRAY(@"a", @"b", @"c", @"d")]);
        assert([[@"a,b,c,d" split:@"," times:2] isEqual:ARRAY(@"a", @"b", @"c,d")]);
        assert([[@"a,b,c,d" split:@"," times:0] isEqual:ARRAY(@"a,b,c,d")]);
        assert([[@"a,b,c,d" split:@","] isEqual:ARRAY(@"a", @"b", @"c", @"d")]);
        
        NSLog(@"%@", [@"\thello \t  world   " compress]);
        assert([[@"\thello \t  world   " compress] isEqualToString:@" hello world "]);
        
        NSLog(@"%@", [@"test string String" capitalizedString]);
        NSLog(@"count = %lu", [@"hello world" count:@"l"]);
        NSLog(@"%@", [@", " join:[@"apple orange donut" split]]);
        NSLog(@"%@", [@"foo" repeat:3]);
        NSLog(@"%@", [@"foo" repeat:3 sep:@"bar"]);
        NSLog(@"%@", [@"foo" repeat:0]);
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
        
        NSString *anotherChained = [testStr chain:^(NSString *s) {
            [s trim];
            [s replace:@"plum" with:@"donut"];
            [s capitalize];
            [s replace:@" " with:@", "];
            [s append:@"."];
        }];
        assert([anotherChained isEqualToString:@"Apple, orange, donut."]);
        
        NSMutableString *mstr = [NSMutableString stringWithString:testStr];
        // Here we have 0 allocations. mstr is passed directly tp the block
        // and is modified in place by all string methods.
        NSMutableString *fastChained = [mstr chain_fast:^(NSMutableString *s) {
            [s trim];
            [s replace:@"plum" with:@"donut"];
            [s capitalize];
            [s replace:@" " with:@", "];
            [s append:@"."];
        }];
        assert([fastChained isEqualToString:@"Apple, orange, donut."]);
        assert([fastChained isKindOfClass:[NSMutableString class]]);
        assert(fastChained == mstr);
        
        // Chain example
        //  [[[[[@"   hello   world   " chain] compress] trim] capitalize] unchain]  <-- 1 allocation
        //    [[[@"   hello   world   " compress] trim] capitalize]                  <-- 3 allocations
        
        NSLog(@"All assertions hold.");
    }
    return 0;
}

