objc.string
===========

Self-contained library for efficient string manipulation in Objective-C.


## Motivation ##

It is quite surprising, but no such library has been developed yet, at least in the open source land. Or I just haven't found one.

There are quite a few so called toolkits for Objective-C released by various companies. It's certainly great that companies share their experience through the code they have accumulated over time. The code is usually well-written and commented, but the problem with those toolkits is that they are mostly useful for the people that created them. The are two main concerns involved:

* Those toolkits tend to be monolithic in the sense that it's not easy to use just one or two classes (out of dozens) because they often depend on the other classes in the same or other toolkits.

* They don't have a clear purpose other than "this is a collection of functionality we find useful; hopefully you will benefit from it too". You will agree that we all dislike unnecessary dependencies and dependencies that we don't fully understand or use to their full potential.

In contrast with those general purpose toolkits, the goal of **objc.string** is to provide a comprehensive set of string manipulation routines in a small, self-contained library with zero dependencies (there are some, but for your own good; they are described in the _Configuration_ section below). It does one thing and does it well. What it does not do:

* networking
* hashing
* HTML-related stuff
* compression/decompression
* text rendering
* ray tracing
* anything else unrelated to the core string operations

While developing it, I drew inspiration from [Underscore.string][1], Python's [string methods][2] and my own experience with strings.

This is an early development version. I'd love to hear your feedback and suggestions. If you'd like to have a certain function added, please open a new issue or send a pull request ;)

  [1]: https://github.com/epeli/underscore.string
  [2]: http://docs.python.org/library/stdtypes.html#string-methods


## Features ##

Here's what the library does do:

* provides a comprehensive and consistent API
* the same API is used to deal with plain strings as well as regular expressions
* embraces functional approach (treats both `NSString` and `NSMutableString` as immutable)
* (while still providing a way to modify strings "in place")
* contains a complete set of unit tests and benchmarks


## Core Concepts ##

**objc.string** has two basic principles at its core:

* All functions adhere to functional style: they return a new object, leaving the original string untouched.

* Most of the functions can be chained to efficiently perform multiple string operations without redundant allocations.

Consider the following example:

```objc
NSString *testStr = @"\tapple orange plum \n", *newStr;

newStr = [testStr trim];                          // => @"apple orange plum"
newStr = [newStr replace:@"plum" with:@"donut"];  // => @"apple orange donut"
newStr = [newStr capitalize];                     // => @"Apple orange donut"
newStr = [newStr replace:@" " with:@", "];        // => @"Apple, orange, donut"
newStr = [newStr append:@"."];                    // => @"Apple, orange, donut."
```

This code produces four intermediate strings that get thrown away. Of course, there is `NSMutableString`, but Apple decided it does not need that many methods at all, so we Objective-C developers are pretty much screwed when it comes to manipulating string in an efficient manner.

**objc.string** does not provide a parallel set of functions that operate on instances of `NSMutableString`. Instead, it provides an ability to use the same functions to modify the input string in-place. This is achieved by using the `chain`/`unchain` methods:

```objc
NSString *testStr = @"\tapple orange plum \n";

NSString *newStr = [testStr chain];
[newStr trim];                           // => @"apple orange plum"
[newStr replace:@"plum" with:@"donut"];  // => @"apple orange donut"
[newStr capitalize];                     // => @"Apple orange donut"
[newStr replace:@" " with:@", "];        // => @"Apple, orange, donut"
[newStr append:@"."];                    // => @"Apple, orange, donut."
[newStr unchain];
```

A new string is allocated when the `chain` method is called. All successive method calls change `newStr` without allocating new strings. Note that the code has been formatted on multiple lines only for clarity. All of the following examples produce the same string in the end:

```objc
NSString *testStr = @"\tapple orange plum \n";

// This is an inefficient way of combining multiple string operations, resulting
// in allocation of four intermediate strings (5 allocations total)
NSString *aStr =
    [[[[[testStr trim] replace:@"plum" with:@"donut"] capitalize] replace:@" " with:@", "] append:@"."];

// One new string is allocated. This is more efficient.
NSString *anotherStr = [testStr chain];
[[[testStr trim] replace:@"plum" with:@"donut"] capitalize];
// Return values can be ignored while chaining. Each method simply returns a
// pointer to the same input string.
[testStr replace:@" " with:@", "];
[testStr append:@"."];
[testStr unchain];

// Same as the previous one, but automatically calls `unchain` behind the scenes.
// This is the recommended way to combine multiple string operations.
NSString *yetAnotherStr = [testStr chain:^(NSString *str) {
    [[[[[str trim] replace:@"plum" with:@"donut"] capitalize] replace:@" " with:@", "]append:@"."];
}];

// If you already have an instance of NSMutableString, you can avoid allocations altogether.
NSMutableString *mstr = ...;
[mstr chain_fast:^(NSMutableString *str) {
    ...
}];
```

Another nice feature of **objc.string** is that it provides support for multiple workflows. The basic functionality is implemented as a set of functions in the _str_funs.m_ file. Categories are also provided for `NSString` and `NSMutableString`. If you like the category approach, add the _objc.string_ directory to your project and include the _NSString+ObjCStringAdditions.h_ file where you want to use it. If you're not a fan of categories, add only _str_funs.h_ and _str_funs.m_ to your project and use plain functions.


## Documentation ##

Documentation is not yet available. See the list of available functions in the _str_funs.h_ file.


## Running Tests ##

[GHUnit][3] is used for testing purposes, it is included as a git submodule. To prepare the test project, run `make test` in the project's root directory. This will fetch the submodule and build it. Once it's done, open _ObjCStringTests.xcodeproj_ in the _tests_ directory and run it.

  [3]: https://github.com/gabriel/gh-unit


## License ##

Feel free to hack on the code. I'll add a license once the library is mature and stable enough.
