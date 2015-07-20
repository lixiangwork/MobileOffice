//
//  FileDealedVC.m
//  MobileOffice
//
//  Created by MacAir2 on 15/6/18.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "FileDealedVC.h"
#import "WSUploadCell.h"
#import "FileDetailVC.h"
#import "GuidangFileDetailVC.h"

@interface FileDealedVC ()<UITableViewDataSource, UITableViewDelegate, FileDetailVCDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableList;

@end

@implementation FileDealedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"已处理文件";
    
     [self setupRefresh:@"table"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Clound
- (void)getDocumentDealed {
    NSString *uName = [[[User sharedUser] getUserGlobalDic] objectForKey:uUserName];
    NSString *temp = @"%";
    
    NSString *condition = [NSString stringWithFormat:@"ProcessedUser like '%@%@%@' ", temp, uName, temp];
    [[CloudService sharedInstance] sqlSearch:@"test_table_1" andCondition:condition withBlock:^(NSMutableArray *result, NSError *error) {
        
        if (!error) {
            if (result.count > 0) {
                //_tableList = result;
                _tableList = [NSMutableArray arrayWithArray:[result sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    NSString *time1 = ((ContentItems *)obj1).LastChangedTime;
                    NSString *time2 = ((ContentItems *)obj2).LastChangedTime;
                    
                    return [time2 compare:time1];
                }]] ;
                [self.tableView reloadData];
                
            }
            else {
                [self showHudOnlyMsg:@"没有内容"];
            }
        }
        else {
            //[UIFactory showAlert:@"网络错误"];
        }
        [self.tableView headerEndRefreshing];
    }];
}


#pragma mark -
#pragma mark - MJRefresh
/**
 *  集成刷新控件
 */
- (void)setupRefresh:(NSString *)dateKey
{
   
        // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
        // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
        [_tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:dateKey];
        //#warning 自动刷新(一进入程序就下拉刷新)
        [_tableView headerBeginRefreshing];
        
        // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
        //[self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
        
        // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
        _tableView.headerPullToRefreshText = @"下拉可以刷新";
        _tableView.headerReleaseToRefreshText = @"松开马上刷新";
        _tableView.headerRefreshingText = @"正在努力帮您刷新中,不客气";
        
        //    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据";
        //    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据";
        //    self.tableView.footerRefreshingText = @"正在努力帮您加载中,不客气";
  }

- (void)headerRereshing
{
    [self getDocumentDealed];
}


#pragma mark - UITableView DataSource

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _tableList.count;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuse = @"WorkSpaceUploadCell";
    
    [tableView registerNib:[UINib nibWithNibName:@"WSUploadCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuse];
    
    WSUploadCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    
    if (cell == nil) {
        cell = [[WSUploadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    cell.cellEdge = 10;
    
    
    
    cell.contentItem = [_tableList objectAtIndex:indexPath.section];
        
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /*FileDetailVC *detailVC = [[FileDetailVC alloc] initWithNibName:@"FileDetailVC" bundle:nil];
    
    detailVC.contentItem = [_tableList objectAtIndex:indexPath.section];
        
    
    [self.navigationController pushViewController:detailVC animated:YES];*/
    
    GuidangFileDetailVC *detailVC = [[GuidangFileDetailVC alloc] initWithNibName:@"GuidangFileDetailVC" bundle:nil];
    detailVC.delegate = self;
    
    detailVC.contentItem = [_tableList objectAtIndex:indexPath.section];
    
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.0f;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 8.0f;
    }
    else{
        return 2.0f;
    }
}


- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 3.0f;
}

#pragma mark - FileDetailVC delegate
- (void)alterCommentSuccess {
    
    [self setupRefresh:@"table"];
}

@end
