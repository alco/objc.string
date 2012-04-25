#import <GHUnit/GHUnit.h>
#import "NSString+ObjCString.h"


@interface ChainTests: GHTestCase
@end


@implementation ChainTests

- (void)testAppend
{
    NSString *chainedStr = [@"foo" chain];
    
    GHAssertEquals(chainedStr, [chainedStr append:@"bar"], @"");
    GHAssertEquals(chainedStr, [[chainedStr append:@"bar"] unchain], @"");
}

@end
