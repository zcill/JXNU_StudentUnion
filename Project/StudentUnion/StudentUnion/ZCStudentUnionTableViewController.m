//
//  ZCStudentUnionTableViewController.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/8.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCStudentUnionTableViewController.h"
#import "ZCWorkNewsCell.h"
#import "ZCWorkNewsModel.h"
#import "ZCNewsDetailTableViewController.h"
#import "ZCTeamTableViewController.h"
#import "ZCQRCodeViewController.h"

@interface ZCStudentUnionTableViewController ()<ZCQRCodeViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ZCStudentUnionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    [self fetchNewsData];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.refreshControl addTarget:self action:@selector(fetchStudentWorkingNews:) forControlEvents:UIControlEventValueChanged];
}

- (void)fetchStudentWorkingNews:(id)sender {
    [self fetchNewsData];
}

- (void)fetchNewsData {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];

    AVQuery *query = [AVQuery queryWithClassName:@"StudentWorkNews"];
    [query includeKey:@"title"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (AVObject *object in objects) {
                [tmpArray addObject:object];
            }
            self.dataSource = tmpArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [self.refreshControl endRefreshing];
            });
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender {
    
    if ([segue.identifier isEqualToString:@"pushToNews"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ZCNewsDetailTableViewController *vc = (ZCNewsDetailTableViewController *)[segue destinationViewController];
        AVObject *newsObject = _dataSource[indexPath.row];
        vc.objectId = newsObject.objectId;
    } else if ([segue.identifier isEqualToString:@"presentToQRCodeReader"]) {
        
        ZCQRCodeViewController *QRCodeVC = [segue destinationViewController];
        QRCodeVC.delegate = self;
        
    } else {
        
        ZCTeamTableViewController *team = (ZCTeamTableViewController *)[segue destinationViewController];
        team.teamName = sender.currentTitle;
        
    }
}

#pragma mark - QRReaderViewControllerDelegate

- (void)didFinishedReadingQR:(NSString *)string {
    
    ZCTeamTableViewController *team = [self.storyboard instantiateViewControllerWithIdentifier:@"ZCTeamTableViewController"];
//    team.teamName = string;
    team.objectId = string;
    [self.navigationController pushViewController:team animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCWorkNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentNewsCell" forIndexPath:indexPath];
    
    AVObject *object = self.dataSource[indexPath.row];
    cell.model = [ZCWorkNewsModel modelWithAVObject:object];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
