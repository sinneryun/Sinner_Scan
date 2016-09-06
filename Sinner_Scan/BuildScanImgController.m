//
//  BuildScanImgController.m
//  Sinner_Scan
//
//  Created by 刘达浮云 on 2016/9/6.
//  Copyright © 2016年 刘达浮云. All rights reserved.
//

#import "BuildScanImgController.h"
#import "BuildScanImgClass.h"


@interface BuildScanImgController (){
    UITextField *textField;
}

@end

@implementation BuildScanImgController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 100, [[UIScreen mainScreen] bounds].size.width-40,40)];
    textField.backgroundColor = [UIColor blueColor];
    [self.view addSubview:textField];
    
    UIButton *buildBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buildBtn.frame = CGRectMake(20, CGRectGetMaxY(textField.frame)+40, 100, 30);
    buildBtn.titleLabel.textAlignment = 1;
    buildBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [buildBtn setTitle:@"生成二维码" forState:UIControlStateNormal];
    [buildBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buildBtn addTarget:self action:@selector(buildClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buildBtn];
    
    
}

-(void)buildClick{
    NSLog(@"1231231");
    UIImageView *img = [[UIImageView alloc]initWithImage:[BuildScanImgClass createQRimageString:textField.text sizeWidth:100 fillColor:[UIColor blackColor]]];
    img.frame = CGRectMake(50, 250, 200, 200);
    [self.view addSubview:img];
    
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
