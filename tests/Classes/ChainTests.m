#import <GHUnit/GHUnit.h>
#import "NSString+ObjCString.h"
#import "NSMutableString+ObjCString.h"


@interface ChainTests: GHTestCase {
    NSString *_chainedStr;
}
@end


@implementation ChainTests

- (void)setUp
{
    _chainedStr = [@"foo  bar\t" chain];
}

- (void)tearDown
{
    _chainedStr = nil;
}

#pragma mark -

- (void)testAppend
{
    GHAssertEquals(_chainedStr, [_chainedStr append:@"bar"], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr append:@"bar"] unchain], @"");
}

- (void)testCapitalize
{
    GHAssertEquals(_chainedStr, [_chainedStr capitalize], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr capitalize] unchain], @"");
}

- (void)testCompress
{
    GHAssertEquals(_chainedStr, [_chainedStr compress], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr compress] unchain], @"");
}

- (void)testCut
{
    GHAssertEquals(_chainedStr, [_chainedStr cut:NSMakeRange(0, 3)], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr cut:NSMakeRange(0, 3)] unchain], @"");
}

- (void)testCutFrom
{
    GHAssertEquals(_chainedStr, [_chainedStr cutFrom:3], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr cutFrom:3] unchain], @"");
}

- (void)testCutTo
{
    GHAssertEquals(_chainedStr, [_chainedStr cutTo:3], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr cutTo:3] unchain], @"");
}

- (void)testDelete
{
    GHAssertEquals(_chainedStr, [_chainedStr delete:NSMakeRange(0, 3)], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr delete:NSMakeRange(2, 1)] unchain], @"");
}

- (void)testExpandTabs
{
    GHAssertEquals(_chainedStr, [_chainedStr expandTabs], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr expandTabs] unchain], @"");
}

- (void)testFilter
{
    GHAssertEquals(_chainedStr, [_chainedStr filter:@"abc"], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr filter:@"abc"] unchain], @"");
}

- (void)testFilterChars
{
    GHAssertEquals(_chainedStr, [_chainedStr filterChars:[NSCharacterSet newlineCharacterSet]], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr filterChars:[NSCharacterSet whitespaceCharacterSet]] unchain], @"");
}

- (void)testInsert
{
    GHAssertEquals(_chainedStr, [_chainedStr insert:@"abc" at:0], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr insert:@"bca" at:3] unchain], @"");
}

- (void)testLowercase
{
    GHAssertEquals(_chainedStr, [_chainedStr lowercase], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr lowercase] unchain], @"");
}

- (void)testRepeat
{
    GHAssertEquals(_chainedStr, [_chainedStr repeat:3], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr repeat:3] unchain], @"");
}

- (void)testReplace
{
    GHAssertEquals(_chainedStr, [_chainedStr replace:@"foo" with:@"bar"], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr replace:@"foo" with:@"bar"] unchain], @"");
}

- (void)testReverse
{
    GHAssertEquals(_chainedStr, [_chainedStr reverse], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr reverse] unchain], @"");
}

- (void)testSplice
{
    GHAssertEquals(_chainedStr, [_chainedStr splice:NSMakeRange(0, 3) with:@"hello"], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr splice:NSMakeRange(0, 3) with:@"bye"] unchain], @"");
}

- (void)testLtrim
{
    GHAssertEquals(_chainedStr, [_chainedStr ltrim], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr ltrim] unchain], @"");
}

- (void)testRtrim
{
    GHAssertEquals(_chainedStr, [_chainedStr rtrim], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr rtrim] unchain], @"");
}

- (void)testTitlecase
{
    GHAssertEquals(_chainedStr, [_chainedStr titlecase], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr titlecase] unchain], @"");
}

- (void)testTrim
{
    GHAssertEquals(_chainedStr, [_chainedStr trim], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr trim] unchain], @"");
}

- (void)testTruncate
{
    GHAssertEquals(_chainedStr, [_chainedStr truncate:5], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr truncate:5 at:kTruncateLeft] unchain], @"");
}

- (void)testUppercase
{
    GHAssertEquals(_chainedStr, [_chainedStr uppercase], @"");
    GHAssertEquals(_chainedStr, [[_chainedStr uppercase] unchain], @"");
}

- (void)testComplexChain
{
    NSString *testStr = @"\tapple orange plum \n";

    NSString *newStr = [testStr chain];
    [newStr trim];                           // => @"apple orange plum"
    [newStr replace:@"plum" with:@"donut"];  // => @"apple orange donut"
    [newStr capitalize];                     // => @"Apple orange donut"
    [newStr replace:@" " with:@", "];        // => @"Apple, orange, donut"
    [newStr append:@"."];                    // => @"Apple, orange, donut."
    NSString *result = [newStr unchain];

    GHAssertEquals(newStr, result, @"");
    GHAssertEqualStrings(@"Apple, orange, donut.", result, @"");
}

- (void)testComplexChainBlock
{
    NSString *testStr = @"\tapple orange plum \n";

    __block NSString *controlStr;
    NSString *result = [testStr chain:^(NSString *str) {
        controlStr = str;
        [[[[[str trim] replace:@"plum" with:@"donut"] capitalize] replace:@" " with:@", "] append:@"."];
    }];

    GHAssertEquals(controlStr, result, @"");
    GHAssertEqualStrings(@"Apple, orange, donut.", result, @"");
}

- (void)testFastChain
{
    NSMutableString *testStr = [NSMutableString stringWithString:@"\tapple orange plum \n"];

    NSString *newStr = [testStr chain_fast];
    GHAssertEquals(newStr, testStr, @"");

    [newStr trim];                           // => @"apple orange plum"
    [newStr replace:@"plum" with:@"donut"];  // => @"apple orange donut"
    [newStr capitalize];                     // => @"Apple orange donut"
    [newStr replace:@" " with:@", "];        // => @"Apple, orange, donut"
    [newStr append:@"."];                    // => @"Apple, orange, donut."
    NSString *result = [newStr unchain];

    GHAssertEquals(testStr, result, @"");
    GHAssertEqualStrings(@"Apple, orange, donut.", result, @"");
}

- (void)testFastChainBlock
{
    NSMutableString *testStr = [NSMutableString stringWithString:@"\tapple orange plum \n"];

    __block NSString *controlStr;
    NSString *result = [testStr chain_fast:^(NSMutableString *str) {
        controlStr = str;
        [[[[[str trim] replace:@"plum" with:@"donut"] capitalize] replace:@" " with:@", "] append:@"."];
    }];
    
    GHAssertEquals(testStr, controlStr, @"");
    GHAssertEquals(testStr, result, @"");
    GHAssertEqualStrings(@"Apple, orange, donut.", result, @"");
}

@end
