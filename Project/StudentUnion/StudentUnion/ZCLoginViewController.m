//
//  ZCLoginViewController.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/7.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCLoginViewController.h"
#import "ZCRegisterViewController.h"
#import "ZCTabBarController.h"
#import "AppDelegate.h"

@interface ZCLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation ZCLoginViewController

- (IBAction)loginButtonClicked:(UIButton *)sender {
    [AVUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(AVUser *user, NSError *error) {
        if (!error) {
            [self zc_resignFirsetResponder];
            
            // 设置rootVC
            [self setupRootViewController];
        } else {
            DLog(@"%@", error.description);
        }
    }];
}

- (void)setupRootViewController {
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    if ([appdelegate.window.rootViewController isKindOfClass:[ZCLoginViewController class]]) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        ZCTabBarController *tabBar = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ZCTabBarController"];
        [appDelegate.window setRootViewController:tabBar];
        [appDelegate.window makeKeyAndVisible];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)registerButtonClicked:(UIButton *)sender {
    ZCRegisterViewController *registerVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ZCRegisterViewController"];
    registerVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:registerVC animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self zc_resignFirsetResponder];
}

- (void)zc_resignFirsetResponder {
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

@end
