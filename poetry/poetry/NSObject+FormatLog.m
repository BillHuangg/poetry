//
//  NSObject+FormatLog.m
//  poetry
//
//  Created by bill on 17/2/9.
//  Copyright © 2017年 bill. All rights reserved.
//

#import "NSObject+FormatLog.h"

@implementation NSObject(FormatLog)

- (void) FormatLogWithClassNameAndMessage:(NSString*)message {
    
    NSLog(@"[%@]: %@", NSStringFromClass([self class]), message);
}

@end
