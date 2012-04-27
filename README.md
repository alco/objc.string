objc.string
===========

Self-contained library for efficient string manipulation in Objective-C.


## Motivation ##

It is quite surprising, but no such library has been developed yet, at least in the open source land. Or I just haven't found one.

There are quite a few so called toolkits for Objective-C released by various companies. It's certainly great that companies share their experience through the code they have accumulated over time. The code is usually well-written and commented, but the problem with those toolkits is that they are mostly useful for the people that created them. The are two main concerns involved:

* Those toolkits tend to be monolithic in the sense that it's not easy to use just one or two classes (out of dozens) because they often depend on the other classes in the same or other toolkits.

* They don't have a clear purpose other than "this is a collection of functionality we find useful; hopefully you will benefit from it too". You will agree that we all dislike unnecessary dependencies and dependencies that we don't fully understand or use to their full potential.

In contrast with those general purpose toolkits, the goal of **objc.string** is to provide a comprehensive set of string manipulation routines in a small, self-contained library with zero dependencies (there are some, but for your own good; they are described in the _Configuration_ section below). It does one thing and does it well. What it _does not_ do:

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

It's important to note, that **objc.string** does not replace the standard methods of `NSString` but complements them. Some of the methods have been overloaded to provide support for the chaining mechanism (described below). Here's what the library does do:

* provides a powerful and consistent API
* the same API is used to deal with plain strings as well as regular expressions
* embraces functional approach (treats both `NSString` and `NSMutableString` as immutable)
* (while still providing a way to modify strings "in place")
* comes with a comprehensive set of unit tests and benchmarks


## Core Concepts ##

**objc.string** has two basic principles at its core:

* All functions adhere to functional style: they return a new object, leaving the original string untouched.

* At the same time, most of the functions can be chained to efficiently perform multiple string operations in one sequence avoiding unnecessary memory allocations.

Consider the following example:

```objc
NSString *testStr = @"\tapple orange plum \n", *newStr;

newStr = [testStr trim];                          // => @"apple orange plum"
newStr = [newStr replace:@"plum" with:@"donut"];  // => @"apple orange donut"
newStr = [newStr capitalize];                     // => @"Apple orange donut"
newStr = [newStr replace:@" " with:@", "];        // => @"Apple, orange, donut"
newStr = [newStr append:@"."];                    // => @"Apple, orange, donut."
```

This code produces four intermediate strings that get thrown away. Of course, there is `NSMutableString`, but Apple decided it does not need that many methods at all, so we Cocoa developers are pretty much screwed when it comes to manipulating strings in an efficient manner. The CoreFoundation counterparts of `NSString` and `NSMutableString` (with `CFString...` functions) provide a richer set of functionality than what is available in Foundation.

**objc.string** bridges the two together by providing a uniform API and hiding all of the underlying implementation details. It _does not_ provide two sets of similar functions to support `NSString` and `NSMutableString`. Instead, it provides the ability to use the same functions that manipulate both, either purely (returning a new string) or in a more optimized way (sometimes modifying the string "in place"). This is achieved by using the `chain`/`unchain` methods:

```objc
NSString *testStr = @"\tapple orange plum \n";

NSString *newStr = [testStr chain];  // <--
newStr = [newStr trim];                           // => @"apple orange plum"
newStr = [newStr replace:@"plum" with:@"donut"];  // => @"apple orange donut"
newStr = [newStr capitalize];                     // => @"Apple orange donut"
newStr = [newStr replace:@" " with:@", "];        // => @"Apple, orange, donut"
newStr = [newStr append:@"."];                    // => @"Apple, orange, donut."
newStr = [newStr unchain];           // <--
```

Two new lines have been added, they are marked with `<--` in the code. A new string is allocated when the `chain` method is called. Successive method calls now know that `newStr` can be changed "in place" if needed (it's not always the case though), without allocating new strings. Note that the code has been formatted on multiple lines only for clarity. All of the following examples produce the same result in the end:

```objc
NSString *testStr = @"\tapple orange plum \n";

// This is an inefficient way of combining multiple string operations, resulting
// in allocation of four intermediate strings (at the minimum)
NSString *aStr =
    [[[[[testStr trim] replace:@"plum" with:@"donut"] capitalize] replace:@" " with:@", "] append:@"."];

// This is more efficient.
NSString *anotherStr = [testStr chain];  // <--
anotherStr = [[[testStr trim] replace:@"plum" with:@"donut"] capitalize];
anotherStr = [anotherStr replace:@" " with:@", "];
anotherStr = [anotherStr append:@"."];
[anotherStr unchain];                    // <--

// Same as the previous one, but automatically calls `unchain` behind the scenes.
// This is the recommended way to combine multiple string operations.
NSString *yetAnotherStr = [testStr chain:^(NSString *str) {
    [[[[[str trim] replace:@"plum" with:@"donut"] capitalize] replace:@" " with:@", "] append:@"."];
}];

// If you already have an instance of NSMutableString, you can avoid the initial copying altogether.
// Note that in this case mstr should be autoreleased prior to being passed to the chain_fast method.
// Read the explanation below for more details.
NSMutableString *mstr = ...;
NSMutableString *maybeNewStr = [mstr chain_fast:^(NSMutableString *str) {
    ...
}];
```

A few things to remember:

* While modifying a string "in place" is often more efficient than creating a new one, it is not always the case. As a consequence, you should never assume that &lt;input string&gt; == &lt;return value&gt;. Failing to do so might cause unexpected results. A scrupulous reader may have noticed that the return value of `[anotherStr unchain]` in the code above is discarded. The `unchain` method is the only exception to this rule, i.e. it is guaranteed to return a pointer to the same string it receives as input.

* The `chain` method returns an autoreleased string which should not be explicitly retained or released until it is unchained. If one of the functions decides to discard the input string and return a new one, it would cause a memory leak in the case when the input string has been retained by the caller. In other words, please don't let a chained string escape the scope it was defined in. This means that for each call to `chain` (or `chain_fast`) there should be a corresponding call to `unchain` in the same function scope. When using `chain:` and `chain_fast:` with a block argument, this invariant is kept for you automatically, so you don't need to call `unchain` yourself.

## Documentation ##

Documentation is not yet available. See the list of available functions in the _str_funs.h_ file.


## Running Tests ##

[GHUnit][3] is used for testing purposes, it is included as a git submodule. To prepare the test project, run `make test` in the project's root directory. This will fetch the submodule and build it. Once it's done, open _ObjCStringTests.xcodeproj_ in the _tests_ directory and run it.

  [3]: https://github.com/gabriel/gh-unit


## License ##

Feel free to hack on the code. I'll add a license once the library is mature and stable enough.
