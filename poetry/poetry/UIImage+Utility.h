//
//  UIImage+UIImage_Utility.h
//  poetry
//
//  Created by bill on 17/2/18.
//  Copyright © 2017年 bill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utility)


/*
 * Clip Image to a small rect
 * Original size must be larger than new one
 @param rect new size
 @return ClipedImage
 */
- (UIImage*)clip:(CGRect) rect;

@end
