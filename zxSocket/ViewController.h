//
//  ViewController.h
//  zxSocket
//
//  Created by 王峰 on 16/4/4.
//  Copyright © 2016年 朝夕传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"


@interface ViewController : UIViewController<GCDAsyncSocketDelegate,UITextFieldDelegate>
{
    GCDAsyncSocket *socket;
}

@property(strong)  GCDAsyncSocket *socket;

@property (strong, nonatomic) IBOutlet UITextField *host;
@property (strong, nonatomic) IBOutlet UITextField *message;
@property (strong, nonatomic) IBOutlet UITextField *port;
@property (strong, nonatomic) IBOutlet UITextView *status;

- (IBAction)connect:(id)sender;
- (IBAction)send:(id)sender;
@end
