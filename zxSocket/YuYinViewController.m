//
//  YuYinViewController.m
//  zxSocket
//
//  Created by 王峰 on 16/6/12.
//  Copyright © 2016年 朝夕传媒. All rights reserved.
//

#import "YuYinViewController.h"
#import "GCDAsyncSocket.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioSession.h>
#import <iflyMSC/IFlySpeechError.h>
#import "iflyMSC/IFlyContact.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "iflyMSC/IFlyUserWords.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechUnderstander.h"
#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height
//@"佳晨实业\n蜀南庭苑\n高兰路\n复联二\n李馨琪\n鹿晓雷\n张集栋\n周家莉\n叶震珂\n熊泽萌\n"
#define NAME        @"userwords"
#define USERWORDS   @"{\"userword\":[{\"name\":\"我的常用词\",\"words\":[\"前进\",\"后退\",\"左转\",\"右转\",\"停止\"]},{\"name\":\"我的好友\",\"words\":[\"亮度加\",\"亮度减\",\"向上\",\"向前\",\"向后\",\"向左\",\"向右\"]}]}"
@interface YuYinViewController ()<GCDAsyncSocketDelegate>{
    
    GCDAsyncSocket *socket;
}

@end

@implementation YuYinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSLog(@"%@=======%@",_IP,_port1);
    socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //socket.delegate = self;
    NSError *err = nil;
    if(![socket connectToHost:_IP onPort:[_port1 intValue] error:&err])
    {
        // [self addText:err.description];
    }else
    {
        NSLog(@"ok");
        //[self addText:@"打开端口"];
        
    }
    
    //创建识别对象
    //创建语音配置
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",@"57579084",@"20000"];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    _iFlySpeechUnderstander = [IFlySpeechRecognizer sharedInstance];
    _iFlySpeechUnderstander.delegate = self;
    
    _content = [[UITextField alloc]initWithFrame:CGRectMake(40, 140, WIDTH-80, 30)];
    _content.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_content];
    UIButton *next = [[UIButton alloc]initWithFrame:CGRectMake(60, HEIGHT-80, WIDTH-120, 40)];
    //next.layer.cornerRadius = 10;
    //registered.backgroundColor = [UIColor orangeColor];
    [next setTitle:@"开始监听" forState:UIControlStateNormal];
    // [next setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
    [next addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    [next addTarget:self action:@selector(understand) forControlEvents:UIControlEventTouchDown];
    
    next.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:next];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(20, 40, 60, 30)];
    but.backgroundColor = [UIColor colorWithRed:96.0/225 green:96.0/225 blue:96.0/225 alpha:0.3];
    but.titleLabel.textColor = [UIColor whiteColor];
    [but setTitle:@"返回" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(brack) forControlEvents:UIControlEventTouchUpInside];
    [but.layer setCornerRadius:10.0];
    [self.view addSubview:but];
    
    [self upWordBtnHandler];

}
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    // [self addText:[NSString stringWithFormat:@"连接到:%@",host]];
    
    NSLog(@"lll");
#pragma clang diagnostic pop
    [socket readDataWithTimeout:-1 tag:0];
    
}
/*----------------------------------------------------*/
-(void)understand1{
    
    NSLog(@"ffff");
}

-(void)finish1{
    
    NSLog(@"jjjj");
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_iFlySpeechUnderstander cancel];
    _iFlySpeechUnderstander.delegate = nil;
    //设置回非语义识别
    [_iFlySpeechUnderstander destroy];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)understand{
    bool ret = [_iFlySpeechUnderstander startListening];  //开始监听
    if (ret) {
        self.isCanceled = NO;
    }
    else{
        NSLog(@"启动识别失败!");
        UILabel  * label = [[UILabel alloc]initWithFrame:CGRectMake(100, HEIGHT/2, WIDTH-200, 40)];
        label.text = @"启动识别失败!";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithRed:21.0/255 green:191.0/255 blue:216.0/255 alpha:1];
        [self.view addSubview:label];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        label.alpha =0.0;
        [UIView commitAnimations];//5秒后消失
    }
    // [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(finish) userInfo:nil repeats:NO];
}

- (void)finish{
    [_iFlySpeechUnderstander stopListening];   //结束监听，并开始识别
}

#pragma mark - IFlySpeechRecognizerDelegate
/**
 61  * @fn      onVolumeChanged
 62  * @brief   音量变化回调
 63  * @param   volume      -[in] 录音的音量，音量范围1~100
 64  * @see
 65  */
- (void) onVolumeChanged: (int)volume
{
    UILabel  * label = [[UILabel alloc]initWithFrame:CGRectMake(100, HEIGHT/2, WIDTH-200, 40)];
    label.text = [NSString stringWithFormat:@"音量：%d",volume];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithRed:21.0/255 green:191.0/255 blue:216.0/255 alpha:1];
    [self.view addSubview:label];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    label.alpha =0.0;
    [UIView commitAnimations];//5秒后消失
}

/**
 72  * @fn      onBeginOfSpeech
 73  * @brief   开始识别回调
 74  * @see
 75  */
- (void) onBeginOfSpeech
{
    
    UILabel  * label = [[UILabel alloc]initWithFrame:CGRectMake(100, HEIGHT/2, WIDTH-200, 40)];
    label.text = @"开始识别回调";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithRed:21.0/255 green:191.0/255 blue:216.0/255 alpha:1];
    [self.view addSubview:label];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    label.alpha =0.0;
    [UIView commitAnimations];//5秒后消失
    
}

/**
 82  * @fn      onEndOfSpeech
 83  * @brief   停止录音回调
 84  * @see
 85  */
- (void) onEndOfSpeech
{
    //    UILabel  * label = [[UILabel alloc]initWithFrame:CGRectMake(100, HEIGHT/2, WIDTH-200, 40)];
    //    label.text = @"停止录音回调";
    //    label.textAlignment = NSTextAlignmentCenter;
    //    label.backgroundColor = [UIColor colorWithRed:21.0/255 green:191.0/255 blue:216.0/255 alpha:1];
    //    [self.view addSubview:label];
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    //    [UIView setAnimationDuration:1.0];
    //    [UIView setAnimationDelegate:self];
    //    label.alpha =0.0;
    //    [UIView commitAnimations];//5秒后消失
    
}

/**
 92  * @fn      onError
 93  * @brief   识别结束回调
 94  * @param   errorCode   -[out] 错误类，具体用法见IFlySpeechError
 95  */
- (void) onError:(IFlySpeechError *) error
{
    NSString *text ;
    if (self.isCanceled) {
        text = @"识别取消";
    }
    else if (error.errorCode ==0 ) {
        if (_result.length==0) {
            text = @"无识别结果";
            UILabel  * label = [[UILabel alloc]initWithFrame:CGRectMake(100, HEIGHT/2, WIDTH-200, 40)];
            label.text = @"无识别结果";
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor colorWithRed:21.0/255 green:191.0/255 blue:216.0/255 alpha:1];
            [self.view addSubview:label];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationDelegate:self];
            label.alpha =0.0;
            [UIView commitAnimations];//5秒后消失
        }
        else{
            text = @"识别成功";
        }
    }
    else{
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
        NSLog(@"%@",text);
        UILabel  * label = [[UILabel alloc]initWithFrame:CGRectMake(100, HEIGHT/2, WIDTH-200, 40)];
        label.text = text;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithRed:21.0/255 green:191.0/255 blue:216.0/255 alpha:1];
        [self.view addSubview:label];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        label.alpha =0.0;
        [UIView commitAnimations];//5秒后消失
    }
}

/**
 * @fn      onResults
 * @brief   识别结果回调
 * @param   result      -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度
 * @see
 */
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSArray * temp = [[NSArray alloc]init];
    NSString * str = [[NSString alloc]init];
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
        
    }
    NSLog(@"听写结果：%@",result);
    //---------讯飞语音识别JSON数据解析---------//
    NSError * error;
    NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"data: %@",data);
    NSDictionary * dic_result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSArray * array_ws = [dic_result objectForKey:@"ws"];
    //遍历识别结果的每一个单词
    for (int i=0; i<array_ws.count; i++) {
        temp = [[array_ws objectAtIndex:i] objectForKey:@"cw"];
        NSDictionary * dic_cw = [temp objectAtIndex:0];
        str = [str  stringByAppendingString:[dic_cw objectForKey:@"w"]];
        NSLog(@"识别结果:%@",[dic_cw objectForKey:@"w"]);
    }
    NSLog(@"最终的识别结果:%@",str);
    //去掉识别结果最后的标点符号
    if ([str isEqualToString:@"。"] || [str isEqualToString:@"？"] || [str isEqualToString:@"！"]) {
        NSLog(@"末尾标点符号：%@",str);
    }
    else{
        self.content.text = str;
        //{\"userword\":[{\"name\":\"我的常用词\",\"words\":[\"前进\",\"后退\",\"左转\",\"右转\",\"停止\"]},{\"name\":\"我的好友\",\"words\":[\"亮度加\",\"亮度减\",\"向上\",\"向前\",\"向后\",\"向左\",\"向右\"]}]}"
        NSArray *array = @[@"前进",@"后退",@"左转",@"右转",@"停止",@"亮度加",@"亮度减"];
        NSArray *arr = @[@"Q",@"H",@"Z",@"Y",@"E",@"L",@"J"];
        NSInteger index = [array indexOfObject:str];//获取指定元素的索引
        
        NSLog(@"__=======================================_%ld",(long)index);
        if (index >= 0 && index<=6) {
            [socket readDataWithTimeout:-1 tag:0];
            [socket writeData:[arr[index] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
        } else {
            //NSLog(<#NSString * _Nonnull format, ...#>)
        }
    }
    _result = str;
}

#pragma mark - IFlyDataUploaderDelegate

/**
 上传联系人和词表的结果回调
 error ，错误码
 ****/
- (void) onUploadFinished:(IFlySpeechError *)error
{
    NSLog(@"%d",[error errorCode]);
    
    if ([error errorCode] == 0) {
        //  [_popUpView showText: @"上传成功"];
        UILabel  * label = [[UILabel alloc]initWithFrame:CGRectMake(100, HEIGHT/2, WIDTH-200, 40)];
        label.text = @"上传成功";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithRed:21.0/255 green:191.0/255 blue:216.0/255 alpha:1];
        [self.view addSubview:label];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:2.0];
        [UIView setAnimationDelegate:self];
        label.alpha =0.0;
        [UIView commitAnimations];//5秒后消失
        
    }
    else {
        //[_popUpView showText: [NSString stringWithFormat:@"上传失败，错误码:%d",error.errorCode]];
        UILabel  * label = [[UILabel alloc]initWithFrame:CGRectMake(100, HEIGHT/2, WIDTH-200, 40)];
        label.text = @"上传失败";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithRed:21.0/255 green:191.0/255 blue:216.0/255 alpha:1];
        [self.view addSubview:label];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:2.0];
        [UIView setAnimationDelegate:self];
        label.alpha =0.0;
        [UIView commitAnimations];//5秒后消失
        
    }
}



- (void)upWordBtnHandler{
    
    //创建上传对象
    _uploader = [[IFlyDataUploader alloc] init];
    //生成用户词表对象
    //用户词表
    //#define USERWORDS   @"{\"userword\":[{\"name\":\"iflytek\",\"words\":[\"德国盐猪手\",\"1912酒吧街\",\"清蒸鲈鱼\",\"挪威三文鱼\",\"黄埔军校\",\"横沙牌坊\",\"科大讯飞\"]}]}"
    IFlyUserWords *iFlyUserWords = [[IFlyUserWords alloc] initWithJson:USERWORDS ];
    //#define NAME @"userwords"
    //设置参数
    [_uploader setParameter:@"iat" forKey:@"sub"];
    [_uploader setParameter:@"userword" forKey:@"dtt"];
    //上传词表
    [_uploader uploadDataWithCompletionHandler:^(NSString * grammerID, IFlySpeechError *error)
     {
         [self onUploadFinished:error];
         
         if (error.errorCode == 0) {
             
         }
         
     } name:NAME data:[iFlyUserWords toString]];
}

-(void)brack{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
