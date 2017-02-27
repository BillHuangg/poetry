//
//  PhotoEditViewController.h
//  poetry
//
//  Created by bill on 17/2/20.
//  Copyright © 2017年 bill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enum.h"

@interface PhotoEditViewController : UIViewController


@property(nonatomic, weak) IBOutlet UIImageView *imagePreview;

- (void) setupOriginalImage:(UIImage *)image From:(ImageSourceType) type;

@end
