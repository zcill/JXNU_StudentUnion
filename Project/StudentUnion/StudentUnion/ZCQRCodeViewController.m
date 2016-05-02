//
//  ZCQRCodeViewController.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/5/2.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

@interface ZCQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *scanView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) UIImageView *scanLineImageView;
@property (nonatomic, strong) NSTimer *scanLineTimer;

@end

@implementation ZCQRCodeViewController

- (void)initViewAndSubViews {
    
    CGRect mainBounds = [[UIScreen mainScreen] bounds];
    self.view.frame = mainBounds;
    
    CGRect readerFrame = self.view.frame;
    CGSize viewFinderSize = CGSizeMake(readerFrame.size.width - 80, readerFrame.size.width - 80);
    /**********************************摄像头开始**********************************/
    // 1 实例化摄像头设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // An AVCaptureDevice object abstracts a physical capture device that provides input data (such as audio or video) to an AVCaptureSession object.
    
    // 2 设置输入,把摄像头作为输入设备
    // 因为模拟器是没有摄像头的，因此在此最好做个判断
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        [MBProgressHUD showErrorHudAddTo:self.view animated:YES text:@"没有摄像头"];
        NSLog(@"没有摄像头%@", error.localizedDescription);
        return;
    }
    
    // 3 设置输出(Metadata元数据)
    AVCaptureMetadataOutput *outPut = [[AVCaptureMetadataOutput alloc] init];
    CGRect scanCrop =
    CGRectMake((readerFrame.size.width - viewFinderSize.width)/2,
               (readerFrame.size.height - viewFinderSize.height)/2,
               viewFinderSize.width,
               viewFinderSize.height);
    
    outPut.rectOfInterest =
    CGRectMake(scanCrop.origin.y/readerFrame.size.height,
               scanCrop.origin.x/readerFrame.size.width,
               scanCrop.size.height/readerFrame.size.height,
               scanCrop.size.width/readerFrame.size.width
               );
    
    // 3.1 设置输出的代理
    // 使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验。
    [outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 4 拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    session.sessionPreset = AVCaptureSessionPreset640x480;
    // 添加session的输入和输出
    [session addInput:input];
    [session addOutput:outPut];
    // 4.1 设置输出的格式
    [outPut setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // 5 设置预览图层(用来让用户能够看到扫描情况)
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    // AVCaptureVideoPreviewLayer -- to show the user what a camera is recording
    // 5.1 设置preview图层的属性
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    // 5.2设置preview图层的大小
    
    [preview setFrame:self.view.bounds];
    //5.3将图层添加到视图的图层
    [self.view.layer insertSublayer:preview atIndex:0];
    self.previewLayer = preview;
    
    self.session = session;
    /**********************************摄像头结束**********************************/
    
    self.scanLineImageView =
    [[UIImageView alloc] initWithFrame:CGRectMake((readerFrame.size.width - 230)/2,
                                                  (readerFrame.size.height - viewFinderSize.height)/2,
                                                  230, 10)];
    self.scanLineImageView.image = [UIImage imageNamed:@"qr_scan_line"];
    [self.view addSubview:self.scanLineImageView];
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated {

    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [super viewWillAppear:animated];
    
    //6.启动会话
    [self.session startRunning];
}

- (void)viewDidAppear:(BOOL)animated {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        NSLog(@"没有摄像头%@", error.localizedDescription);
        input = nil;
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (self.scanLineTimer == nil) {
        [self moveUpAndDownLine];
        [self createTimer];
    }
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    UIApplication *application = [UIApplication sharedApplication];
    [application setStatusBarHidden:NO];
    
    [super viewWillDisappear:animated];
}

#define LINE_SCAN_TIME  3.0     // 扫描线从上到下扫描所历时间（s）

- (void)createTimer {
    self.scanLineTimer =
    [NSTimer scheduledTimerWithTimeInterval:LINE_SCAN_TIME
                                     target:self
                                   selector:@selector(moveUpAndDownLine)
                                   userInfo:nil
                                    repeats:YES];
}

// 扫描条上下滚动
- (void)moveUpAndDownLine {
    CGRect readerFrame = self.view.frame;
    CGSize viewFinderSize = CGSizeMake(self.view.frame.size.width - 80, self.view.frame.size.width - 80);
    
    CGRect scanLineframe = self.scanLineImageView.frame;
    scanLineframe.origin.y =
    (readerFrame.size.height - viewFinderSize.height)/2;
    self.scanLineImageView.frame = scanLineframe;
    self.scanLineImageView.hidden = NO;
    
    __weak __typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:LINE_SCAN_TIME - 0.05
                     animations:^{
                         CGRect scanLineframe = weakSelf.scanLineImageView.frame;
                         scanLineframe.origin.y =
                         (readerFrame.size.height + viewFinderSize.height)/2 -
                         weakSelf.scanLineImageView.frame.size.height;
                         
                         weakSelf.scanLineImageView.frame = scanLineframe;
                     }
                     completion:^(BOOL finished) {
                         weakSelf.scanLineImageView.hidden = YES;
                     }];
}

- (IBAction)dismissButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)flashButton:(UIButton *)sender {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    if (device.hasTorch) {  // 判断设备是否有闪光灯
        BOOL b = [device lockForConfiguration:&error];
        if (!b) {
            if (error) {
                NSLog(@"lock torch configuration error:%@", error.localizedDescription);
            }
            return;
        }
        device.torchMode =
        (device.torchMode == AVCaptureTorchModeOff ? AVCaptureTorchModeOn : AVCaptureTorchModeOff);
        [device unlockForConfiguration];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViewAndSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

//此方法是在识别到QRCode并且完成转换，如果QRCode的内容越大，转换需要的时间就越长。
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // 会频繁的扫描，调用代理方法
    // 1如果扫描完成，停止会话
    [self.session stopRunning];
    //2删除预览图层
    [self.previewLayer removeFromSuperlayer];
    //设置界面显示扫描结果
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        if ([self.delegate respondsToSelector:@selector(didFinishedReadingQR:)]) {
            [self.delegate didFinishedReadingQR:obj.stringValue];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
