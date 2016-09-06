//
//  BuildScanImgClass.h
//  Sinner_Scan
//
//  Created by 刘达浮云 on 2016/9/6.
//  Copyright © 2016年 刘达浮云. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BuildScanImgClass : NSObject
/**
 *  生成二维码图片
 *
 *  @param QRString  二维码内容
 *  @param sizeWidth 图片size（正方形）
 *  @param color     填充色
 *
 *  @return  二维码图片
 */
+(UIImage *)createQRimageString:(NSString *)QRString sizeWidth:(CGFloat)sizeWidth fillColor:(UIColor *)color;

/**
 *  读取图片中二维码信息
 *
 *  @param image 图片
 *
 *  @return 二维码内容
 */
+(NSString *)readQRCodeFromImage:(UIImage *)image;
@end
