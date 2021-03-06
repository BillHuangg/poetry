//
//  CameraViewController.m
//  poetry
//
//  Created by bill on 17/2/8.
//  Copyright © 2017年 bill. All rights reserved.
//

#import "CameraViewController.h"
#import "NSObject+FormatLog.h"
#import "UIImage+Utility.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "GPUImage.h"
#import "Enum.h"
#import "PhotoEditViewController.h"

#define CameraViewMarginTop 44

@interface CameraViewController () {
    GPUImageVideoCamera *_videoCamera;
    GPUImageOutput<GPUImageInput> *_filter;
    GPUImageView *_cameraView;
    
    UIButton *_toggleCameraRectButton;
    UIButton *_toggleCameraRotationButton;
    UIButton *_toggleCameraFlashButton;
    
    UIButton *_photoCaptureButton;
    UIButton *_albumButton;
    UIButton *_filterButton;

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

# pragma mark - Camera Setup
- (void)setupCameraView {
    
    // init as CAMERA_VIEW_RECT_VIEW_11
    _currentCameraViewRectType = CAMERA_VIEW_RECT_VIEW_11;
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width / 3 * 4);
    _cameraView = [[GPUImageView alloc] initWithFrame:rect];
    _cameraView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;

    // mask
    CALayer *renderRectMaskLayer = [CALayer layer];
    renderRectMaskLayer.frame = CGRectMake(0, CameraViewMarginTop + rectStatus.size.height, self.view.frame.size.width, self.view.frame.size.width);
    renderRectMaskLayer.backgroundColor = [UIColor blackColor].CGColor;
    _cameraView.layer.mask = renderRectMaskLayer;
    _cameraView.layer.masksToBounds = YES;
    
    [self.view addSubview:_cameraView];
}

- (void)setupCamera {
    
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
    
    _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    _videoCamera.horizontallyMirrorRearFacingCamera = NO;
    
    _filter = [[GPUImageFilter alloc] init];
    [_filter addTarget:_cameraView];
    
    [_videoCamera addTarget:_filter];
    [_videoCamera startCameraCapture];
}

# pragma mark - View And Animation Setup
- (void)setupButtons {
    
    [self setupTopButtons];
    [self setupBottomButtons];
}

- (void) setupTopButtons {
    
    // toggle camera rect
    _toggleCameraRectButton = [self generateButton:@"rect" rect:CGRectMake(20, 20, 60, 40) action:@selector(toggleCameraRectEvent)];
    [self.view addSubview:_toggleCameraRectButton];
    
    // toggle camera rotation
    _toggleCameraRotationButton = [self generateButton:@"rotation" rect:CGRectMake(100, 20, 60, 40) action:@selector(toggleCameraRotationEvent)];
    [self.view addSubview:_toggleCameraRotationButton];

    // toggle flash
    _toggleCameraFlashButton = [self generateButton:@"flash" rect:CGRectMake(180, 20, 60, 40) action:@selector(toggleCameraFlashEvent)];
    [self.view addSubview:_toggleCameraFlashButton];
}

- (void) setupBottomButtons {
    
    float x = ScreenWidth / 2 - 40;
    float y = (ScreenHeight + _cameraView.frame.size.height) / 2 - 40;
    
    // open album
    _albumButton = [self generateButton:@"album" rect:CGRectMake(x - 100, y, 80, 80) action:@selector(albumOpenEvent)];
    [self.view addSubview:_albumButton];
    
    // take picture
    _photoCaptureButton = [self generateButton:@"" rect:CGRectMake(x, y, 80, 80) action:@selector(photoCaptureEvent)];
    _photoCaptureButton.backgroundColor = [UIColor blackColor];
    _photoCaptureButton.layer.cornerRadius = 40;
    [self.view addSubview:_photoCaptureButton];
    
    // filter view
    _filterButton = [self generateButton:@"filter" rect:CGRectMake(x + 100, y, 80, 80) action:@selector(filterOpenEvent)];
    [self.view addSubview:_filterButton];
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

# pragma mark - Button Event
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
    [self viewRectAnimation:_cameraView ToRect:rect];
    
    [self FormatLogWithClassNameAndMessage:@"toggleCameraRectEvent"];
}

- (void)toggleCameraRotationEvent {
    
    [_videoCamera rotateCamera];
    [self FormatLogWithClassNameAndMessage:@"toggleCameraRotationEvent"];
}

- (void)toggleCameraFlashEvent {
    
    [self FormatLogWithClassNameAndMessage:@"toggleCameraFlashEvent"];
}

- (void)photoCaptureEvent {
    
    [self FormatLogWithClassNameAndMessage:@"photoCaptureEvent"];
    
    [_filter useNextFrameForImageCapture];
    UIImage *captureImage = _filter.imageFromCurrentFramebuffer;
    if (_currentCameraViewRectType == CAMERA_VIEW_RECT_VIEW_11) {
        // resize image
        captureImage = [captureImage clip:CGRectMake(0, (captureImage.size.height - captureImage.size.width) / 2, captureImage.size.width, captureImage.size.width)];
    }
    
    [self jumpToEditViewControllerWithImage:captureImage From:IMAGE_FROM_CAPTURE];
    
}

- (void)albumOpenEvent {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
    [self FormatLogWithClassNameAndMessage:@"albumOpenEvent"];
}

- (void)filterOpenEvent {
    
    [self FormatLogWithClassNameAndMessage:@"filterOpenEvent"];
}

# pragma mark - Logic
- (void) jumpToEditViewControllerWithImage:(UIImage *) image From:(ImageSourceType) type {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PhotoEditViewController *tempController = (PhotoEditViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"PhotoEditViewControllerID"];
        [tempController setupOriginalImage:image From:type];
        [self presentViewController:tempController animated:YES completion:nil];
    });
}
# pragma mark - Functions

# pragma mark - UIImagePickerController Delegate
- (void)saveCameraPhotoToAlbum:(UIImage *)image {
    
    if(IsNilOrNull(image)) {
        [self FormatLogWithClassNameAndMessage:@"Image is nil, can't be saved"];
        return;
    }
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image: (UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSString *message = IsNilOrNull(error) ? @"保存成功" : @"保存失败";
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5f];
}

# pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self FormatLogWithClassNameAndMessage:__String(@"Get Image, name: %@", image.description)];
    
    // go to photo edit view
    [self jumpToEditViewControllerWithImage:image From:IMAGE_FROM_CAPTURE];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];

    [self FormatLogWithClassNameAndMessage:@"imagePickerControllerDidCancel"];
}

# pragma mark - View Animations
- (void) viewRectAnimation:(UIView*) view ToRect:(CGRect) toRect {
        
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration: 0.3f
                          delay: 0
                        options: UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         _cameraView.layer.mask.frame = toRect;
                     }
                     completion: ^(BOOL finish){
                         self.view.userInteractionEnabled = YES;
                     }];
}

# pragma mark - Utility


@end
