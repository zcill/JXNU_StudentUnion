//
//  ZCStudentNotiTableViewController.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/5/10.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCStudentNotiTableViewController.h"
#import "ZCStudentNotiCell.h"
#import "ZCNewsDetailTableViewController.h"

@interface ZCStudentNotiTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ZCStudentNotiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchNewData];
    [self setupTableViewUI];
    
}


- (void)setupTableViewUI {
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.estimatedRowHeight = self.tableView.rowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.tableFooterView = [[UIView alloc] init];

}

- (void)refreshTableView:(id)sender {
    
    [self fetchNewData];
    
}

- (void)fetchNewData {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];

    AVQuery *query = [AVQuery queryWithClassName:@"StudentWorkNews"];
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCStudentNotiCell *cell = (ZCStudentNotiCell *)[tableView dequeueReusableCellWithIdentifier:@"ZCStudentNotiCell" forIndexPath:indexPath];

    cell.model = [self.dataSource objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZCNewsDetailTableViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"ZCNewsDetailTableViewController"];
    AVObject *object = [self.dataSource objectAtIndex:indexPath.row];
    detail.objectId = object.objectId;
    [self.navigationController pushViewController:detail animated:YES];
    
}

@end
