//
//  ViewController.m
//  Sinner_Scan
//
//  Created by 刘达浮云 on 2016/9/6.
//  Copyright © 2016年 刘达浮云. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "BuildScanImgController.h"


#define  SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height//获取屏幕高度
#define  SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width//获取屏幕宽度

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
///扫描框体
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
///用于链接输入和输出流的管道
@property (strong,nonatomic)AVCaptureSession * session;
///用于把输出流显示在界面上的view
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
///线
@property (strong,nonatomic)UIImageView *imgView;
///框
@property (strong,nonatomic)UIView *scanView;
///是否到底
@property (assign,nonatomic)BOOL up;
///计时器
@property(strong,nonatomic)CADisplayLink * link;
@property(assign,nonatomic)CGFloat yyy;
@end

@implementation ViewController{
    int i;
}

/// 重写 imgView的frame。 yyy不是常量，是一个属性
-(void)setYyy:(CGFloat)yyy{
    _yyy= yyy;
    CGRect frame = CGRectMake(self.imgView.frame.origin.x, yyy, self.imgView.frame.size.width, self.imgView.frame.size.height);
    self.imgView.frame = frame;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    i=1;
    _yyy = self.imgView.frame.origin.y;
    
    
    [self scan];
    [self creatLayout];
    
    
    
    
}

//界面
-(void)creatLayout{
    
    //扫描框体
    self.scanView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-100, 200, 200)];
    self.scanView.backgroundColor = [UIColor clearColor];
    CGFloat borderWidth = 2.0f;
    self.scanView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.scanView.layer.borderWidth = borderWidth;
    [self.view addSubview:self.scanView];
    
    //时间计时器开始
    CADisplayLink * link=[CADisplayLink displayLinkWithTarget:self selector:@selector(move)];
    self.link=link;
    [self.scanView addSubview:self.imgView];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    UIButton *buildBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buildBtn.frame = CGRectMake(20, CGRectGetMaxY(self.scanView.frame)+40, SCREEN_WIDTH-40, 30);
    buildBtn.titleLabel.textAlignment = 1;
    buildBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [buildBtn setTitle:@"生成二维码" forState:UIControlStateNormal];
    [buildBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buildBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buildBtn];
    
    [self addArc];
}

//使用贝塞尔画中间镂空
- (void)addArc {
    //中间镂空的矩形框
    CGRect myRect =CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-100, 200, 200);
    
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:[UIScreen mainScreen].bounds cornerRadius:0];
    //镂空            bezierPathWithOvalInRect这个是画圆
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRect:myRect];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.5;
    [self.view.layer addSublayer:fillLayer];
    
}


//生成二维码
-(void)click{
    [self presentViewController:[[BuildScanImgController alloc]init] animated:YES completion:nil];
}


//线的移动范围
-(void)move{
    if (self.up == YES) {
        self.yyy += 2;
        if (self.yyy >= self.scanView.frame.size.height - 10) {
            self.up = NO;
        }
    }else{
        self.yyy -= 2;
        if (self.yyy <= 10) {
            self.up = YES;
        }
    }
}


//线的frame
-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 200, 2)];
        _imgView.backgroundColor = [UIColor whiteColor];
    }
    return _imgView;
}


//扫描模块
-(void)scan{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //限制扫描区域 位置很诡异，要注意
    double width = 200/SCREEN_WIDTH;
    double height = 200/SCREEN_HEIGHT;
    double left = (0.5-(height/2));
    double right = (0.5-(width/2));
    [ _output setRectOfInterest : CGRectMake (left ,right ,height ,width)];
    
    
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode  还有N多种，可以以数组形式同时存在
    [_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, nil]];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    // Start
    [_session startRunning];
}


#pragma mark AVCaptureMetadataOutputObjectsDelegate  扫描结果
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    i++;
    if ([metadataObjects count] >0)
    {
        //停止扫描
        //[_session stopRunning];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        NSLog(@"%@-%d",stringValue,i);
        
    } else {
        NSLog(@"无扫描信息");
        return;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
