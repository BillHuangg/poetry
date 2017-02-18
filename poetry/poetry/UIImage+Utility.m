//
//  UIImage+UIImage_Utility.m
//  poetry
//
//  Created by bill on 17/2/18.
//  Copyright © 2017年 bill. All rights reserved.
//

#import "UIImage+Utility.h"

@implementation UIImage (Utility)

- (UIImage*)clip:(CGRect) rect {
    
    NSAssert(!(self.size.height < rect.size.height || self.size.width < rect.size.width) , @"Original Image size must be larger than new one");
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width, rect.size.height), YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context,
                       CGRectMake(
                                  -rect.origin.x,
                                  -rect.origin.y,
                                  self.size.width,
                                  self.size.height),
                       self.CGImage);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

@end
