//
//  ZCRegisterViewController.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/8.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCRegisterViewController.h"

@interface ZCRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *studentNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation ZCRegisterViewController

- (IBAction)notRegister:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    DLog(@"notRegisterButtonClicked");
}

- (IBAction)confirmRegister:(UIButton *)sender {
    AVUser *user = [AVUser user];
    user.username = self.studentNumberTextField.text;
    user.password =  self.pwdTextField.text;
    [user setObject:self.realNameTextField.text forKey:@"realname"];
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:SU_APP_VERSION];
    [user setObject:lastVersion forKey:@"lastVersion"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // 注册成功
            [MBProgressHUD showCheckmarkHudAddTo:[UIApplication sharedApplication].keyWindow animated:YES text:@"帐号注册成功"];
            [self dismissViewControllerAnimated:YES completion:^{
                [AVUser logOut];
            }];
        } else {
            // 失败的原因可能有多种，常见的是用户名已经存在。
            ULog(@"%@", error.description);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
