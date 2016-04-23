//
//  ZCCommitViewController.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/23.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ZCCommitViewController.h"
#import "ZCTeamTableViewController.h"

@interface ZCCommitViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *classTextField;
@property (weak, nonatomic) IBOutlet UITextField *telNumberTextField;
@property (weak, nonatomic) IBOutlet UISwitch *followSwitch;
@property (weak, nonatomic) IBOutlet UITextView *introTextView;
@property (weak, nonatomic) IBOutlet UITextView *ideaTextView;

@end

@implementation ZCCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"报名表";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(commitResume:)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)commitResume:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要提交报名表吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self commitResumeToLeancloud];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)commitResumeToLeancloud {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在上传简历";
    
    AVObject *resume = [AVObject objectWithClassName:@"Resume"];
    [self setKeyValueWithResumeObject:resume];
    
    [resume saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                [MBProgressHUD showCheckmarkHudAddTo:self.view animated:YES text:@"简历发送成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            });
        } else if (error.code == 400) {
            [hud hide:YES];
            [MBProgressHUD showErrorHudAddTo:self.view animated:YES text:@"请上传照片后再提交"];
        } else {
            [hud hide:YES];
            [MBProgressHUD showErrorHudAddTo:self.view animated:YES text:@"上传失败"];
        }
    }];

}

- (void)setKeyValueWithResumeObject:(AVObject *)resume {
    
    UIImage *img = self.photoImageView.image;
    NSData *imgData = UIImageJPEGRepresentation(img, 0.8);
    AVFile *file = [AVFile fileWithData:imgData];
    [file.metaData setObject:@(img.size.height) forKey:@"height"];
    [file.metaData setObject:@(img.size.width) forKey:@"width"];
    
    [resume setObject:file forKey:@"photo"];
    [resume setObject:self.nameTextField.text forKey:@"name"];
    [resume setObject:self.classTextField.text forKey:@"class"];
    [resume setObject:self.telNumberTextField.text forKey:@"telephoneNumber"];
    [resume setObject:self.introTextView.text forKey:@"introduction"];
    [resume setObject:@(self.followSwitch.on) forKey:@"followSwitch"];
    [resume setObject:[AVUser currentUser] forKey:@"user"];
    [resume setObject:self.ideaTextView.text forKey:@"ideas"];
    
}

- (IBAction)postImageButton:(UIButton *)sender {
    UIAlertController *actionController = [UIAlertController alertControllerWithTitle:nil message:@"照片如果显示不正常，不用担心，后台会收到正常的照片" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self haveTakePhotoAccess]) {
            [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        } else {
            [self showConfirmButtonAlertWithTitle:@"提示" message:@"师大助手没有权限使用您的相机，请在设置-隐私中打开权限"];
        }
    }];
    UIAlertAction *selectImage = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionController addAction:takePhoto];
    [actionController addAction:selectImage];
    [actionController addAction:cancel];
    [self presentViewController:actionController animated:YES completion:nil];
}

- (void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    
    if([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    
}

- (BOOL)haveTakePhotoAccess {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == kCLAuthorizationStatusDenied) {
            return NO;
        }
        return YES;
    }
    return YES;
}

- (void)showConfirmButtonAlertWithTitle:(NSString *)title message:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self.photoImageView setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
