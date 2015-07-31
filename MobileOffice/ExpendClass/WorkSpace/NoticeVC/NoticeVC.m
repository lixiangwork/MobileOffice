//
//  NoticeVC.m
//  MobileOffice
//
//  Created by houjing on 15/6/11.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "NoticeVC.h"
#import "NoticeVCCell.h"
#import "NoticeDetailVC.h"

@interface NoticeVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableList;

@end

@implementation NoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"公告列表";
    
    self.tableList = [NSMutableArray array];
    
    [self setupRefresh:@"table"];
}

- (void)initUI{
    
    [super initUI];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MJRefresh
/**
 *  集成刷新控件
 */
- (void)setupRefresh:(NSString *)dateKey
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:dateKey];
    //#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新";
    self.tableView.headerRefreshingText = @"正在努力帮您刷新中,不客气";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据";
    self.tableView.footerRefreshingText = @"正在努力帮您加载中,不客气";
}

- (void)headerRereshing
{
    [self getNewNoticeFromClound];
    // 刷新表格
    //[self.tableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    //[self.tableView headerEndRefreshing];
    
}

- (void)footerRereshing
{
    [self gethistoryNoticeFromClound];
}


#pragma mark - getNoticeFromClound
- (void)getNewNoticeFromClound {
    
    //NSString *condition = [NSString stringWithFormat:@" 1 = 1 order by news_createtime DESC fetch first 10 rows only"];
    NSString *startTime;
    if (_tableList.count == 0) {
        startTime = @"2015-01-01 00:00:00";
        NSLog(@"startTime:%@",startTime);
    }
    else{
        ContentItems *item = [_tableList objectAtIndex:0];
        startTime=[item.Properties objectForKey:@"news_createtime"];
        NSLog(@"startTime:%@",startTime);
        
    }
    
    NSString *endTime = @"2020-02-14 15:54:22";
    NSLog(@"endTime:%@",endTime);
    
    NSString *condition = [NSString stringWithFormat:@" news_createtime &gt; '%@' and news_createtime &lt; '%@' order by news_createtime DESC fetch first 10 rows only",startTime,endTime];

    
    [[CloudService sharedInstance] sqlSearch:@"notice" andCondition:condition withBlock:^(NSMutableArray *result, NSError *error) {
        if (!error) {
            if (result.count > 0) {
                
                _tableList = [[result arrayByAddingObjectsFromArray:_tableList] mutableCopy];
                
                
                [self.tableView reloadData];
            }
            else {
                [self showHudOnlyMsg:@"没有新的通知"];
            }
        }
        else{
            
        }
        [self.tableView headerEndRefreshing];
    }];
}

- (void)gethistoryNoticeFromClound {
    NSString *startTime = @"2001-01-01 15:54:22";
    NSLog(@"startTime:%@",startTime);
    
    NSString *endTime;
    if (_tableList.count == 0) {
        endTime = @"2020-01-01 15:54:22.0";
    }
    else{
        ContentItems *item = [_tableList lastObject];
        endTime=[item.Properties objectForKey:@"news_createtime"];
        
    }
    NSLog(@"LatestNews_endTime:%@",endTime);
    
    NSString *condition = [NSString stringWithFormat:@" news_createtime &gt; '%@' and news_createtime &lt; '%@'  order by news_createtime DESC fetch first 10 rows only",startTime,endTime];

    [[CloudService sharedInstance] sqlSearch:@"notice" andCondition:condition withBlock:^(NSMutableArray *result, NSError *error) {
        if (!error) {
            if (result.count > 0) {
                
                _tableList = [[_tableList arrayByAddingObjectsFromArray:result] mutableCopy];
                
                [self.tableView reloadData];
            }
            else {
                [self showHudOnlyMsg:@"没有了"];
            }
        }
        else{
            
        }
        [self.tableView footerEndRefreshing];
    }];

}

#pragma mark - UITableView DataSource
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _tableList.count;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuse = @"NoticeCell";
    
    [tableView registerNib:[UINib nibWithNibName:@"NoticeVCCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuse];
    
    NoticeVCCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    
    if (cell == nil) {
        cell = [[NoticeVCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    cell.cellEdge = 10;
    cell.contentItem = [_tableList objectAtIndex:indexPath.section];
    
    return cell;
    
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NoticeDetailVC *detailVC = [[NoticeDetailVC alloc] initWithNibName:@"NoticeDetailVC" bundle:nil];
    detailVC.contentItem = [_tableList objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 106.0f;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 8.0f;
    }
    else{
        return 3.0f;
    }
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 3.0f;
}



@end
