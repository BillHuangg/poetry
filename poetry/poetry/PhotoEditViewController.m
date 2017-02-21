//
//  PhotoEditViewController.m
//  poetry
//
//  Created by bill on 17/2/20.
//  Copyright © 2017年 bill. All rights reserved.
//

#import "PhotoEditViewController.h"

@interface PhotoEditViewController () {
    UIImage *_originalImage;
    UIImage *_editedImage;
    ImageSourceType _imageSourceType;
}

@end

@implementation PhotoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagePreview.image = _originalImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma mark - Setup Data Functions
- (void) setupOriginalImage:(UIImage *)image From:(ImageSourceType) type {
    
    _originalImage = image;
    _imageSourceType = type;
    
}

@end
