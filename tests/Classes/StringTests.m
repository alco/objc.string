#import <GHUnit/GHUnit.h>
#import "NSString+ObjCString.h"


#define $regex(pattern) ((NSString *)[NSRegularExpression regularExpressionWithPattern:pattern \
                                                                               options:0       \
                                                                                 error:NULL])

#define ARRAY(...) [NSArray arrayWithObjects:__VA_ARGS__, nil]


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
    GHAssertEqualStrings(@"Здравствуй, дед", [@"здравствуй, дед" capitalize], @"");
}

- (void)testCompress
{
    GHAssertEqualStrings(@" foo bar ", [@"\t\f\rfoo     bar\n  \t " compress], @"");
}

- (void)testDelete
{
    GHAssertEqualStrings(@"foo", [@"foobar" delete:NSMakeRange(3, 3)], @"");
    GHAssertEqualStrings(@"bar", [@"foobar" delete:NSMakeRange(0, 3)], @"");
    GHAssertEqualStrings(@"foobar", [@"foobar" delete:NSMakeRange(3, 0)], @"");
    GHAssertThrows([@"foo" delete:NSMakeRange(-1, 0)], @"");
    GHAssertThrows([@"foo" delete:NSMakeRange(4, 0)], @"");
}

- (void)testExpandTabs
{
    GHAssertEqualStrings(@"    foo", [@"\tfoo" expandTabs], @"");
    GHAssertEqualStrings(@"  foo   bar", [@"\tfoo \tbar" expandTabs:2], @"");
    GHAssertEqualStrings(@"foo bar", [@"\tfoo \tbar" expandTabs:0], @"");
}

- (void)testInsert
{
    GHAssertEqualStrings(@"foobar", [@"foo" insert:@"bar" at:3], @"");
    GHAssertEqualStrings(@"barfoo", [@"foo" insert:@"bar" at:0], @"");
    GHAssertEqualStrings(@"foobarbaz", [@"foobaz" insert:@"bar" at:3], @"");
    GHAssertEqualStrings(@"foo", [@"foo" insert:@"" at:0], @"");
    GHAssertThrows([@"foo" insert:@"" at:-1], @"");
    GHAssertThrows([@"foo" insert:@"" at:4], @"");
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

- (void)testSplice
{
    GHAssertEqualStrings(@"foo", [@"foo" splice:NSMakeRange(0, 0) with:@""], @"");
    GHAssertEqualStrings(@"barfoo", [@"foo" splice:NSMakeRange(0, 0) with:@"bar"], @"");
    GHAssertEqualStrings(@"bar", [@"foo" splice:NSMakeRange(0, 3) with:@"bar"], @"");
    GHAssertEqualStrings(@"fobar", [@"foo" splice:NSMakeRange(2, 1) with:@"bar"], @"");
    GHAssertEqualStrings(@"bar", [@"" splice:NSMakeRange(0, 0) with:@"bar"], @"");
    GHAssertThrows([@"foo" splice:NSMakeRange(-1, 0) with:@""], @"");
    GHAssertThrows([@"foo" splice:NSMakeRange(4, 0) with:@""], @"");
}

- (void)testTrim
{
    GHAssertEqualStrings(@"foo \t\n\f\r  ", [@"  \r\f\n\t foo \t\n\f\r  " ltrim], @"");
    GHAssertEqualStrings(@"  \r\f\n\t foo", [@"  \r\f\n\t foo \t\n\f\r  " rtrim], @"");
    GHAssertEqualStrings(@"foo", [@"  \r\f\n\t foo \t\n\f\r  " trim], @"");
}

#pragma mark -

- (void)testJoin
{
    NSArray *comps = ARRAY(@"one", @"two", @"three");
    GHAssertEqualStrings(@"onetwothree", [@"" join:comps], @"");
    GHAssertEqualStrings(@"one two three", [@" " join:comps], @"");
    GHAssertEqualStrings(@"one..two..three", [@".." join:comps], @"");
}

- (void)testChop
{
    GHAssertEqualObjects(ARRAY(@"h", @"e", @"l", @"l", @"o"), [@"hello" chop], @"");
    GHAssertEqualObjects(ARRAY(@"he", @"ll", @"o"), [@"hello" chop:2], @"");
    GHAssertEqualObjects(ARRAY(@"hello"), [@"hello" chop:0], @"");
}

- (void)testSplit
{
    GHAssertEqualObjects(ARRAY(@"a", @"b", @"c", @"d"), [@"a b\nc\t  d" split], @"");
    GHAssertEqualObjects(ARRAY(@"", @"a", @"b", @"c", @"d", @""), [@" a b\nc\t  d " split], @"");
}

- (void)testSplitLines
{
    GHAssertEqualObjects(ARRAY(@"foo", @"bar"), [@"foo\nbar" splitLines], @"");
    GHAssertEqualObjects(ARRAY(@"", @"one", @" two ", @"three", @""), [@"\none\n two \nthree\n" splitLines], @"");
}

- (void)testSplitSep
{
    GHAssertEqualObjects(ARRAY(@"a", @"b", @"", @"c", @"d"), [@"a,b,,c,d" split:@","], @"");
    GHAssertEqualObjects(ARRAY(@"a", @"b", @"c,d"), [@"a,b,c,d" split:@"," times:2], @"");
    GHAssertEqualObjects(ARRAY(@"a,b,c,d"), [@"a,b,c,d" split:@"," times:0], @"");
}

#pragma mark -

- (void)testCount
{
    GHAssertEquals((NSUInteger)3, [@"hello world" count:@"l"], @"");
    GHAssertEquals((NSUInteger)3, [@" hello world " count:@" "], @"");
    GHAssertEquals((NSUInteger)2, [@"foo bar foo" count:@"foo"], @"");
}

@end