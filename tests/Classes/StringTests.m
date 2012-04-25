#import <GHUnit/GHUnit.h>
#import "NSString+ObjCString.h"


#define $regex(pattern) ((NSString *)[NSRegularExpression regularExpressionWithPattern:pattern \
                                                                               options:0       \
                                                                                 error:NULL])


@interface StringTests: GHTestCase
@end


@implementation StringTests

- (void)testAppend
{
    GHAssertEqualStrings(@"foobar", [@"foo" append:@"bar"], @"");
    GHAssertEqualStrings(@"foo", [@"foo" append:@""], @"");
    GHAssertEqualStrings(@"bar", [@"" append:@"bar"], @"");
    GHAssertEqualStrings(@"добрый　日", [@"добрый" append:@"　日"], @"");
}

- (void)testCapitalize
{
    GHAssertEqualStrings(@"Foo bar", [@"foo bar" capitalize], @"");
    GHAssertEqualStrings(@" foo bar", [@" foo bar" capitalize], @"");
    GHAssertEqualStrings(@"1foo bar", [@"1foo bar" capitalize], @"");
    GHAssertEqualStrings(@"Foo bar", [@"Foo bar" capitalize], @"");
}

- (void)testCompress
{
    GHAssertEqualStrings(@" foo bar ", [@"\t\f\rfoo     bar\n  \t " compress], @"");
}

- (void)testExpandTabs
{
    GHAssertEqualStrings(@"    foo", [@"\tfoo" expandTabs], @"");
    GHAssertEqualStrings(@"  foo   bar", [@"\tfoo \tbar" expandTabs:2], @"");
    GHAssertEqualStrings(@"foo bar", [@"\tfoo \tbar" expandTabs:0], @"");
}

- (void)testRepeat
{
    GHAssertEqualStrings(@"", [@"foo" repeat:0], @"");
    GHAssertEqualStrings(@"foo", [@"foo" repeat:1], @"");
    GHAssertEqualStrings(@"foofoofoo", [@"foo" repeat:3], @"");

    GHAssertEqualStrings(@"", [@"foo" repeat:0 sep:@","], @"");
    GHAssertEqualStrings(@"foo", [@"foo" repeat:1 sep:@","], @"");
    GHAssertEqualStrings(@"foo,foo,foo", [@"foo" repeat:3 sep:@","], @"");
}

- (void)testReplace
{
    GHAssertEqualStrings(@"foofoobazfoo", [@"foobarbazbar" replace:@"bar" with:@"foo"], @"");
    GHAssertEqualStrings(@"foobaz", [@"foobarbazbar" replace:@"bar" with:@""], @"");
}

- (void)testReplaceRegex
{
    GHAssertEqualStrings(@"foo foo  bar", [@"foo 1foo 123 13bar" replace:$regex(@"\\d+") with:@""], @"");
    GHAssertEqualStrings(@"bar.foo two.one", [@"foo.bar one.two" replace:$regex(@"(\\w+)\\.(\\w+)") with:@"$2.$1"], @"");
}

- (void)testTrim
{
    GHAssertEqualStrings(@"foo \t\n\f\r  ", [@"  \r\f\n\t foo \t\n\f\r  " ltrim], @"");
    GHAssertEqualStrings(@"  \r\f\n\t foo", [@"  \r\f\n\t foo \t\n\f\r  " rtrim], @"");
    GHAssertEqualStrings(@"foo", [@"  \r\f\n\t foo \t\n\f\r  " trim], @"");
}

@end