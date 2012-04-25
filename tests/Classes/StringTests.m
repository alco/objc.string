#import <GHUnit/GHUnit.h>
#import "NSString+ObjCString.h"


@interface StringTests: GHTestCase
@end


@implementation StringTests

- (void)testAppend
{
    GHAssertEqualStrings(@"foobar", [@"foo" append:@"bar"], @"");
    GHAssertEqualStrings(@"foo", [@"foo" append:@""], @"");
    GHAssertEqualStrings(@"bar", [@"" append:@"bar"], @"");
    GHAssertEqualStrings(@"добрый 日", [@"добрый" append:@" 日"], @"");
}

@end