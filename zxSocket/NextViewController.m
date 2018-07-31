//
//  NextViewController.m
//  zxSocket
//
//  Created by 王峰 on 16/4/4.
//  Copyright © 2016年 朝夕传媒. All rights reserved.
//

#import "NextViewController.h"
#import "ZMRocker.h"
@interface NextViewController ()<GCDAsyncSocketDelegate,ZMRockerDelegate>{
    GCDAsyncSocket *socket;
    ZMRocker *rocker;
    UILabel *Label;
    UISlider *slider;
}
@end

@implementation NextViewController
#pragma mark - 强制横屏代码
- (BOOL)shouldAutorotate
{
    //是否支持转屏
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //支持哪些转屏方向
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

//摇杆
    rocker = [[ZMRocker alloc]initWithFrame:CGRectMake(60-13, 100-13, 144, 144)];
    [self.view addSubview:rocker];
    rocker.delegate = self;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    Label = [[UILabel alloc]initWithFrame:CGRectMake(230, 40, 60, 30)];
    Label.backgroundColor = [UIColor whiteColor];
    Label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:Label];
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(170, 260, 200, 20)];
    slider.minimumValue = 0;
    slider.maximumValue = 100;
    slider.value = 50;
    [slider addTarget:self action:@selector(updateValue) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    
    
    UIButton *but1 = [[UIButton alloc]initWithFrame:CGRectMake(140+200, 33+65, 40, 40)];
    but1.backgroundColor = [UIColor colorWithRed:61.0/225 green:192.0/225 blue:172.0/225 alpha:1];
    but1.titleLabel.textColor = [UIColor whiteColor];
    [but1 setImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    [but1 addTarget:self action:@selector(cha:) forControlEvents:UIControlEventTouchUpInside];
    [but1.layer setCornerRadius:10.0];
    but1.tag =1;
    [self.view addSubview:but1];
    
    UIButton *but2 = [[UIButton alloc]initWithFrame:CGRectMake(230+200, 98, 40, 40)];
    but2.backgroundColor = [UIColor colorWithRed:61.0/225 green:192.0/225 blue:172.0/225 alpha:1];
    but2.titleLabel.textColor = [UIColor whiteColor];
    [but2 setImage:[UIImage imageNamed:@"3"] forState:UIControlStateNormal];
    [but2 addTarget:self action:@selector(cha:) forControlEvents:UIControlEventTouchUpInside];
    [but2.layer setCornerRadius:10.0];
    but2.tag =2;
    [self.view addSubview:but2];
    
    UIButton *but3 = [[UIButton alloc]initWithFrame:CGRectMake(140+200, 180, 40, 40)];
    but3.backgroundColor = [UIColor colorWithRed:61.0/225 green:192.0/225 blue:172.0/225 alpha:1];
    but3.titleLabel.textColor = [UIColor whiteColor];
    [but3 setImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
    [but3 addTarget:self action:@selector(cha:) forControlEvents:UIControlEventTouchUpInside];
    [but3.layer setCornerRadius:10.0];
    but3.tag =3;
    [self.view addSubview:but3];
    
    UIButton *but4 = [[UIButton alloc]initWithFrame:CGRectMake(230+200, 180, 40, 40)];
    but4.backgroundColor = [UIColor colorWithRed:61.0/225 green:192.0/225 blue:172.0/225 alpha:1];
    but4.titleLabel.textColor = [UIColor whiteColor];
    [but4 setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [but4 addTarget:self action:@selector(cha:) forControlEvents:UIControlEventTouchUpInside];
    [but4.layer setCornerRadius:10.0];
    but4.tag =4;
    [self.view addSubview:but4];
    
    
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(470, 20, 60, 30)];
    but.backgroundColor = [UIColor colorWithRed:96.0/225 green:96.0/225 blue:96.0/225 alpha:0.3];
    but.titleLabel.textColor = [UIColor whiteColor];
    [but setTitle:@"返回" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(brack) forControlEvents:UIControlEventTouchUpInside];
    [but.layer setCornerRadius:10.0];
    [self.view addSubview:but];
    
    //socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
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
}

-(void)updateValue{
    
     float f = slider.value; //读取滑块的值
    Label.text = [NSString stringWithFormat:@"%.1f",f];

}
- (void)rockerDidChangeDirection:(ZMRocker *)rocker1
{
    NSLog(@"Direction : %ld",(long)rocker1.direction);
    
    NSArray *directios = @[@"左",@"上",@"右",@"下",@"停止"];
    
     NSArray *arr = @[@"Z",@"Q",@"Y",@"H",@"E"];
   Label.text = directios[rocker1.direction];
    [socket readDataWithTimeout:-1 tag:0];
    [socket writeData:[arr[rocker1.direction] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    
}

-(void)cha:(UIButton *)button{
    NSArray *arr = @[@"L",@"O",@"J",@"P"];
    NSInteger i = button.tag;
   
    [socket readDataWithTimeout:-1 tag:0];
    [socket writeData:[arr[i-1] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];


   NSLog(@"%@-----%ld",arr[i-1],(long)i);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    return toInterfaceOrientation == UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}
-(void)brack{

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
