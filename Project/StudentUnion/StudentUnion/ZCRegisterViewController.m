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
    
    if (![self isValidPassword:self.pwdTextField.text]) {
        [MBProgressHUD showErrorHudAddTo:self.view animated:YES text:@"密码格式不正确"];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"注册中...";
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.alpha = 0.8;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // 注册成功
            [hud hide:YES];
            
            [MBProgressHUD showCheckmarkHudAddTo:[UIApplication sharedApplication].keyWindow animated:YES text:@"帐号注册成功"];
            [self dismissViewControllerAnimated:YES completion:^{
                [AVUser logOut];
            }];
        } else {
            [hud hide:YES];
            
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

// 密码需要是6-18位的数字字母组合
-(BOOL)isValidPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

@end
