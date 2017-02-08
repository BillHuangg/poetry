//
//  CameraViewController.m
//  poetry
//
//  Created by bill on 17/2/8.
//  Copyright © 2017年 bill. All rights reserved.
//

#import "CameraViewController.h"
#import "NSObject+FormatLog.h"
#import "GPUImage.h"

#define CameraViewMarginTop 44

typedef enum {
    CAMERA_VIEW_RECT_VIEW_11,
    CAMERA_VIEW_RECT_VIEW_34
} CameraViewRectType;

@interface CameraViewController () {
    GPUImageVideoCamera *_videoCamera;
    GPUImageOutput<GPUImageInput> *_filter;
    GPUImageView *_cameraView;
    
    UIButton *_toggleCameraRectButton;
    UIButton *_toggleCameraRotationButton;
    
    CameraViewRectType _currentCameraViewRectType;
}
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCameraView];
    [self setupButtons];
    [self setupCamera];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupCameraView {
    
    // init as CAMERA_VIEW_RECT_VIEW_11
    _currentCameraViewRectType = CAMERA_VIEW_RECT_VIEW_11;
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rect = CGRectMake(0, CameraViewMarginTop + rectStatus.size.height, self.view.frame.size.width, self.view.frame.size.width);
    _cameraView = [[GPUImageView alloc] initWithFrame:rect];
    _cameraView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;

    [self.view addSubview:_cameraView];
}

- (void)setupButtons {
    
    _toggleCameraRectButton = [self generateButton:@"rect" rect:CGRectMake(20, 20, 60, 40) action:@selector(toggleCameraRectEvent)];
    [self.view addSubview:_toggleCameraRectButton];
    
    _toggleCameraRotationButton = [self generateButton:@"rotation" rect:CGRectMake(100, 20, 60, 40) action:@selector(toggleCameraRotationEvent)];
    [self.view addSubview:_toggleCameraRotationButton];
}

- (void)setupCamera {
    
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
    
    _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    _videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    _videoCamera.horizontallyMirrorRearFacingCamera = NO;
    
    [_videoCamera addTarget:_cameraView];
    [_videoCamera startCameraCapture];
}

- (UIButton*)generateButton:(NSString*) name rect:(CGRect) rect action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button.frame = rect;
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:name forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = YES;
    button.showsTouchWhenHighlighted = YES;
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)toggleCameraRectEvent {
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rect;
    if (_currentCameraViewRectType == CAMERA_VIEW_RECT_VIEW_11) {
        
        _currentCameraViewRectType = CAMERA_VIEW_RECT_VIEW_34;
        rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width / 3 * 4);
        
    } else if (_currentCameraViewRectType == CAMERA_VIEW_RECT_VIEW_34) {
        
        _currentCameraViewRectType = CAMERA_VIEW_RECT_VIEW_11;
        rect = CGRectMake(0, CameraViewMarginTop + rectStatus.size.height, self.view.frame.size.width, self.view.frame.size.width);
    }
    
    // change view
    _cameraView.frame = rect;
    
    [self FormatLogWithClassNameAndMessage:@"toggleCameraRectEvent"];
}

- (void)toggleCameraRotationEvent {
    
    [_videoCamera rotateCamera];
    
    [self FormatLogWithClassNameAndMessage:@"toggleCameraRotationEvent"];
}

@end
