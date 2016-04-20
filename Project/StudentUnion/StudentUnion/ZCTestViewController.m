//
//  ZCTestViewController.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/6.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

/// 测试用ViewController

#import "ZCTestViewController.h"

#import <Wilddog/Wilddog.h>

@interface ZCTestViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsNumberTextField;

@end

static NSString *wildDogUrl = @"https://student-union.wilddogio.com/zcill/";

@implementation ZCTestViewController

- (IBAction)wildDogRead:(UIButton *)sender {
    Wilddog *myRootRef = [[Wilddog alloc] initWithUrl:wildDogUrl];
    [myRootRef observeEventType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
        NSLog(@"%@ -> %@", snapshot.key, snapshot.value);
    }];
}

- (IBAction)wildDogWrite:(UIButton *)sender {
    Wilddog *myRootRef = [[Wilddog alloc] initWithUrl:wildDogUrl];
    [myRootRef setValue:@"try" withCompletionBlock:^(NSError *error, Wilddog *ref) {
        if (!error) {
            NSLog(@"ref: %@", ref);
            NSLog(@"write succeeded !");
        } else {
            NSLog(@"error: %@", error);
        }
    }];
}

- (IBAction)registerButtonClick:(UIButton *)sender {
    
    [AVUser verifyMobilePhone:self.smsNumberTextField.text withBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"verify succeeded");
        } else {
            NSLog(@"error: %@", error);
        }
    }];
    
}

- (IBAction)sendSmsButtonClick:(UIButton *)sender {
    
    [AVUser requestMobilePhoneVerify:self.phoneNumberTextField.text withBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"send succeeded");
        } else {
            NSLog(@"error: %@", error);
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)userLoginButtonClick {
    
}

@end
