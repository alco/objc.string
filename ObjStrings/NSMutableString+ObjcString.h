//
//  NSMutableString+ObjcString.h
//  ObjStrings
//
//  Created by alco on 24.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (ObjcString)
- (NSMutableString *)chain_fast;
- (NSMutableString *)chain_fast:(void (^)(NSMutableString *s))block;
@end
