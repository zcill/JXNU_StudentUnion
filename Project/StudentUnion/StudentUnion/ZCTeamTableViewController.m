//
//  ZCTeamTableViewController.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/20.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCTeamTableViewController.h"
#import "ZCCommitViewController.h"
#import "ZCTeamDetailModel.h"
#import "ZCTeamNameCell.h"
#import "ZCTeamIntroCell.h"
#import "ZCTeamSelectCell.h"

@interface ZCTeamTableViewController ()

@property (nonatomic, strong) ZCTeamDetailModel *model;

@end

@implementation ZCTeamTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupToolBar];
    
    self.tableView.estimatedRowHeight = self.tableView.rowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self fetchNewData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ZCCommitViewController *commit = [segue destinationViewController];
    commit.commitTeam = self.teamName;
}

#pragma mark - Data
- (void)fetchNewData {
    
    AVQuery *query = [AVQuery queryWithClassName:@"TeamDetail"];
    [query whereKey:@"teamName" equalTo:self.teamName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (!error) {
            for (AVObject *object in objects) {
                ZCTeamDetailModel *model = [ZCTeamDetailModel modelWithAVObject:object];
                self.model = model;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }

    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ZCTeamNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCTeamNameCell"];
        cell.model = _model;
        return cell;
    } else if (indexPath.row == 1) {
        ZCTeamIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCTeamIntroCell"];
        cell.model = _model;
        return cell;
    } else if (indexPath.row == 2) {
        ZCTeamSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCTeamSelectCell"];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)setupToolBar {
    
    UIToolbar *toolBar = self.navigationController.toolbar;
    
    toolBar.barTintColor = [UIColor whiteColor];
    toolBar.tintColor = [UIColor grayColor];
    
    // 间距
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 20;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    // 按钮
    UIBarButtonItem *backItem = [self barButtonItemWithImageNamed:@"toolbar_back" action:@selector(backToLastViewController:) width:25 height:25];
    UIBarButtonItem *wechatItem = [self barButtonItemWithImageNamed:@"toolbar_wechat" action:nil width:29.6 height:25];
    UIBarButtonItem *pengyouquanItem = [self barButtonItemWithImageNamed:@"toolbar_pengyouquan" action:nil width:25 height:25];
    UIBarButtonItem *weiboItem = [self barButtonItemWithImageNamed:@"toolbar_weibo" action:nil width:29.5 height:25];
    UIBarButtonItem *moreItem = [self barButtonItemWithImageNamed:@"toolbar_more" action:nil width:25 height:25];
    
    self.toolbarItems = @[fixedSpace, backItem, flexibleSpace, wechatItem, flexibleSpace, pengyouquanItem, flexibleSpace, weiboItem, flexibleSpace, moreItem, fixedSpace];
}

- (UIBarButtonItem *)barButtonItemWithImageNamed:(NSString *)imageName action:(SEL)action width:(CGFloat)width height:(CGFloat)height {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, width, height)];
    [button setImage:[UIImage imageWithOriginalImageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

- (void)backToLastViewController:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
