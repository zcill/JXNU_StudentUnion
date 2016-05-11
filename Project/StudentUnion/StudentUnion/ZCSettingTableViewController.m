//
//  ZCSettingTableViewController.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/26.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCSettingTableViewController.h"
#import "ZCLoginViewController.h"
#import "ZCCommitViewController.h"
#import <ShareSDK3/WXApi.h>

@interface ZCSettingTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation ZCSettingTableViewController

- (IBAction)logoutButtonClicked:(UIButton *)sender {

    // 登出帐号
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定要退出帐号吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"退出帐号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [AVUser logOut];

        ZCLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZCLoginViewController"];
        [self presentViewController:loginVC animated:YES completion:nil];

    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGFloat cache = [[SDImageCache sharedImageCache] getSize];
    self.cacheLabel.text = [NSString stringWithFormat:@"(%.2f MB)", cache/(1024*1024)];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:@"http://7xrf6x.com1.z0.glb.clouddn.com/StudentUnion/Test/1.pic_hd.jpg"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - talbeView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {

        if (indexPath.row == 0) {
            // 我的简历
//            ZCCommitViewController *commitVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZCCommitViewController"];

//            [self.navigationController pushViewController:commitVC animated:YES];

        } else {
            // 我的收藏
        }
    } else if (indexPath.section == 1) {
        
        [self.activityView startAnimating];
        
        // 清理缓存
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                CGFloat cache = [[SDImageCache sharedImageCache] getSize];
                self.cacheLabel.text = [NSString stringWithFormat:@"(%.2f MB)", cache *(1024*1024)];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.activityView stopAnimating];
                });
            });
        }];

    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            // 把软件分享给朋友
            WXWebpageObject *object = [WXWebpageObject object];
            object.webpageUrl = @"https://zcill.com";

            WXMediaMessage *message = [WXMediaMessage message];
            message.title = @"师大助手";
            message.description = @"向你分享这个软件";
            message.mediaObject = object;

            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            [WXApi sendReq:req];

        } else if (indexPath.row == 1) {
            // 给软件评个分
        }
    } else if (indexPath.section == 3) {
        // 意见反馈 开源协议 关于开发者
    }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
