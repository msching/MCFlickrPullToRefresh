//
//  ViewController.m
//  FlickrPullToRefresh
//
//  Created by Chengyin on 16/3/17.
//  Copyright © 2016年 Chengyin. All rights reserved.
//

#import "ViewController.h"
#import "FlickrHeaderView.h"

@implementation ViewController
{
    BOOL _loading;
    FlickrHeaderView *_headerView;
}

#pragma mark - views
- (void)loadView
{
    [super loadView];
    
    __weak typeof(self)weakSelf = self;
    _headerView = [[FlickrHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 200)];
    _headerView.scrollView = self.tableView;
    [_headerView setTriggerLoadBlock:^BOOL{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf startLoading];
        return YES;
    }];
    [_headerView setLoadFinishBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf finishLoad];
    }];
    [self reset];
    self.tableView.tableHeaderView = _headerView;
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor grayColor];
    self.tableView.backgroundView = backgroundView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"FlickrRefresh";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"reset" style:UIBarButtonItemStylePlain target:self action:@selector(reset)];
}

- (void)reset
{
    _headerView.image = [UIImage imageNamed:@"1.gif"];
}

- (void)startLoading
{
    NSLog(@"start loading data...");
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loadDataFinished) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)loadDataFinished
{
    NSLog(@"load data finsihed.");
    _headerView.image = [UIImage imageNamed:@"avatar"];
    [_headerView setFinishLoad];
}

- (void)finishLoad
{
    NSLog(@"animation finished.");
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"defaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [@(indexPath.row) stringValue];
    return cell;
}

@end
