//
//  ViewController.m
//  zxSocket
//
//  Created by 王峰 on 16/4/4.
//  Copyright © 2016年 朝夕传媒. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"
#import "YuYinViewController.h"
@implementation ViewController
@synthesize socket;
@synthesize host;
@synthesize message;
@synthesize port;
@synthesize status;

- (IBAction)clearText:(UIButton *)sender {
    self.status.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)addText:(NSString *)str
{
    status.text = [status.text stringByAppendingFormat:@"%@\n",str];
}
#pragma mark - 强制横屏代码
- (BOOL)shouldAutorotate{
    //是否允许转屏
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //viewController所支持的全部旋转方向
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //viewController初始显示的方向
    return UIInterfaceOrientationPortrait;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    host.text = @"192.168.4.1";
    port.text = @"5000";
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *but1 = [[UIButton alloc]initWithFrame:CGRectMake(60, 460, 80, 40)];
    but1.backgroundColor = [UIColor colorWithRed:96.0/225 green:96.0/225 blue:96.0/225 alpha:0.3];
    but1.titleLabel.textColor = [UIColor whiteColor];
    [but1 setTitle:@"下一步" forState:UIControlStateNormal];
    [but1 addTarget:self action:@selector(cha) forControlEvents:UIControlEventTouchUpInside];
    [but1.layer setCornerRadius:10.0];

    [self.view addSubview:but1];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(180, 460, 80, 40)];
    but.backgroundColor = [UIColor colorWithRed:96.0/225 green:96.0/225 blue:96.0/225 alpha:0.3];
    but.titleLabel.textColor = [UIColor whiteColor];
    [but setTitle:@"语音控制" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(yuying) forControlEvents:UIControlEventTouchUpInside];
    [but.layer setCornerRadius:10.0];
    
    [self.view addSubview:but];
}
-(void)cha{
    
    NextViewController *next = [[NextViewController alloc]init];
    next.IP = host.text;
    next.port1 = port.text;
   [self presentViewController:next animated:YES completion:nil];
}

-(void)yuying{
    
    YuYinViewController *yuYin = [[YuYinViewController alloc]init];
    yuYin.IP = host.text;
    yuYin.port1 = port.text;
    [self presentViewController:yuYin animated:YES completion:nil];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidUnload
{
    [self setHost:nil];
    [self setMessage:nil];
    [self setStatus:nil];
    [self setPort:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)connect:(id)sender {
    socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()]; 
    //socket.delegate = self;
    NSError *err = nil; 
    if(![socket connectToHost:host.text onPort:[port.text intValue] error:&err]) 
    { 
        [self addText:err.description];
    }else
    {
        NSLog(@"ok");
        [self addText:@"打开端口"];
        
    }
   
}
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored"-Wdeprecated-declarations"
    [self addText:[NSString stringWithFormat:@"连接到:%@",host]];
    #pragma clang diagnostic pop
    [socket readDataWithTimeout:-1 tag:0];
    
}


//- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
//{
//}
- (IBAction)send:(id)sender {
    [socket writeData:[message.text dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    
    [self addText:[NSString stringWithFormat:@"我:%@",message.text]];
    [message resignFirstResponder];
    [socket readDataWithTimeout:-1 tag:0];
    
   
}
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [self addText:[NSString stringWithFormat:@"%@:%@",sock.connectedHost,newMessage]];
    //[socket readDataWithTimeout:-1 tag:0];
}



@end
