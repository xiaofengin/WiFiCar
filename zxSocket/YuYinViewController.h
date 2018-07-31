//
//  YuYinViewController.h
//  zxSocket
//
//  Created by 王峰 on 16/6/12.
//  Copyright © 2016年 朝夕传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "iflyMSC/iflyMSC.h"
//引入语音识别类
@class IFlyDataUploader;
@class IFlySpeechUnderstander;

@interface YuYinViewController : UIViewController<IFlySpeechRecognizerDelegate>
@property (nonatomic,strong) IFlySpeechRecognizer *iFlySpeechUnderstander;
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@property (nonatomic, strong) IFlyDataUploader *uploader;//数据上传对象
@property (strong, nonatomic) UITextField *content;
@property (nonatomic,strong) NSString               *result;
@property (nonatomic,strong) NSString               *str_result;
@property (nonatomic)         BOOL                  isCanceled;
@property(nonatomic,strong)NSString *IP;
@property(nonatomic,strong)NSString *port1;
- (void)understand;
- (void)finish;
@end
