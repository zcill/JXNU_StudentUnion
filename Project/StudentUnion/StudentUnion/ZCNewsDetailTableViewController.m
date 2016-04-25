//
//  ZCNewsDetailTableViewController.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/10.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCNewsDetailTableViewController.h"
#import "ZCNewsDetailCell.h"
#import "ZCWorkNewsModel.h"

@interface ZCNewsDetailTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ZCWorkNewsModel *tmpModel;

@end

@implementation ZCNewsDetailTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupToolBar];
    
    self.tableView.estimatedRowHeight = self.tableView.rowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tmpModel = [[ZCWorkNewsModel alloc] init];
    
    [self fetchWorkNewsData];
}

- (void)popToLastViewController:(id)sender {
    NSLog(@"adffa");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)fetchWorkNewsData {
    
    AVQuery *query = [AVQuery queryWithClassName:@"StudentWorkNews"];
    [query getObjectInBackgroundWithId:self.objectId block:^(AVObject *object, NSError *error) {
        if (!error) {
            
            self.tmpModel = [ZCWorkNewsModel modelWithAVObject:object];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        } else {
            DLog(@"%@", error.description);
        }
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCNewsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCNewsDetailCell" forIndexPath:indexPath];
    
    cell.model = _tmpModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - UI界面
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

@end
