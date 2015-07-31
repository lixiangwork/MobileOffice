//
//  WorkSpaceVC.m
//  MobileOffice
//
//  Created by MacAir2 on 15/5/27.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "WorkSpaceVC.h"
#import "LXSegmentView.h"
#import "WSUploadCell.h"

#import "NoticeVC.h"
#import "LocalFileVC.h"
#import "FileDetailVC.h"
#import "FileDealedVC.h"
//#import "GuidangFileDetailVC.h"

@interface WorkSpaceVC ()<UITableViewDataSource,UITableViewDelegate, LXSegmentViewDelegate, FileDetailVCDelegate>

@property (nonatomic, strong) LXSegmentView *mySegmentView;
@property (nonatomic, strong) UITableView *tableView1;
@property (strong, nonatomic) UITableView *tableView2;
@property (strong, nonatomic) UITableView *tableView3;

@property (strong, nonatomic) NSMutableArray *tableList1;
@property (strong, nonatomic) NSMutableArray *tableList2;
@property (strong, nonatomic) NSMutableArray *tableList3;

@property (nonatomic) NSInteger currentIndex;

@property (nonatomic) BOOL isUploadSuccess;
@property (nonatomic) BOOL isGuidangSuccess1;
@property (nonatomic) BOOL isGuidangSuccess2;
@property (nonatomic) BOOL isGuidangSuccess3;

//@property (nonatomic) BOOL isShareSuccess;

@end

@implementation WorkSpaceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的文档";
    
    _currentIndex = 0;
    _isUploadSuccess = NO;
    _isGuidangSuccess1 = NO;
    _isGuidangSuccess2 = NO;
    _isGuidangSuccess3 = NO;
    
    [self setupRefresh:@"table1"];
    
    [kNotificationCenter addObserver:self selector:@selector(updateMyCreateDocument) name:NoticeUploadFileSuccess object:nil];
    
}

- (void)initUI{
    
    [super initUI];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.mySegmentView = [[LXSegmentView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49)];
    self.mySegmentView.tabBgImageView.image = [UIImage imageNamed:@"bg_tab_selected.png"];
    self.mySegmentView.tabButtonSeclectImageView.image = [UIImage imageNamed:@"select_flag.png"];
    self.mySegmentView.tabButtonColor = [UIColor blackColor];
    self.mySegmentView.tabButtonSelectCorlor = [UIColor redColor];
    [self.mySegmentView setTabButton1Title:@"我上传的" andButton2Title:@"我分享的" andButton3Title:@"分享给我的"];
    self.mySegmentView.delegate = self;
    [self.view addSubview:self.mySegmentView];
    
    ///tableView1
    self.tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.mySegmentView.mainScrollView.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    [self.mySegmentView.mainScrollView addSubview:self.tableView1];
    
    ///tableView2
    self.tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, self.mySegmentView.mainScrollView.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    [self.mySegmentView.mainScrollView addSubview:self.tableView2];
    
    ///tableView3
    self.tableView3 = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, self.mySegmentView.mainScrollView.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView3.delegate = self;
    self.tableView3.dataSource = self;
    [self.mySegmentView.mainScrollView addSubview:self.tableView3];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(10, 0, 44, 44)];
    //[leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[leftBtn setTitle:@"公告列表" forState:UIControlStateNormal];
    //[leftBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [leftBtn setImage:[UIImage imageNamed:@"localfile.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(LeftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(kScreenWidth-90, 2, 40, 40)];
    //[rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[rightBtn setTitle:@"本地文件" forState:UIControlStateNormal];
    //[rightBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [rightBtn setImage:[UIImage imageNamed:@"menu_dealed.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(RightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_currentIndex == 0 && _isUploadSuccess) {
        _isUploadSuccess = NO;
        [self setupRefresh:@"table1"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - notifcation
- (void)updateMyCreateDocument {
    _isUploadSuccess = YES;
}

#pragma mark - My Action
- (void)LeftBtnAction{
    
//    NoticeVC *vc = [[NoticeVC alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    LocalFileVC *vc = [[LocalFileVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)RightBtnAction{
    
    FileDealedVC *vc = [[FileDealedVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Clound Request
- (void)getMyCreateDocument {
    
    //order by 'LASTCHANGEDDATE' DESC fetch first 10 rows only
    NSString *uName = [[[User sharedUser] getUserGlobalDic] objectForKey:uUserName];
    NSString *temp = @"%";
    NSString *condition = [NSString stringWithFormat:@" creater = '%@' and (ProcessedUser not  like '%@%@%@' or ProcessedUser is NULL )",uName, temp, uName, temp];
    [[CloudService sharedInstance] sqlSearch:@"test_table_1" andCondition:condition withBlock:^(NSMutableArray *result, NSError *error) {
        
        if (!error) {
            if (result.count > 0) {
                
                _tableList1 = [NSMutableArray arrayWithArray:[result sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    NSString *time1 = ((ContentItems *)obj1).LastChangedTime;
                    NSString *time2 = ((ContentItems *)obj2).LastChangedTime;
                    
                    return [time2 compare:time1];
                }]] ;
                //_tableList1 = result;
                [self.tableView1 reloadData];
                
            }
            else {
                [self showHudOnlyMsg:@"没有内容"];
            }
        }
        else {
            //[UIFactory showAlert:@"网络错误"];
        }
        
        [self.tableView1 headerEndRefreshing];
    }];
    //LASTCHANGEDDATE DESC
    /*[[CloudService sharedInstance] SQLSearch2:@"upload_table" andCondition:condition andSize:@"10" andOrderby:@" 'LASTCHANGEDDATE' DESC" andColumnlist:@"" withBlock:^(NSMutableArray *result, NSError *error) {
        if (!error) {
            if (result.count > 0) {
                _tableList1 = result;
                [self.tableView1 reloadData];
            }
            else {
                
            }
        }
        else {
            //[UIFactory showAlert:@"网络错误"];
        }

    }];*/
}

/////////getMyshare

- (void)getMySharedDocument {
    
    NSString *uName = [[[User sharedUser] getUserGlobalDic] objectForKey:uUserName];
    NSString *temp = @"%";
    
    NSString *condition = [NSString stringWithFormat:@"shares_from like '%@%@%@' and (ProcessedUser not  like '%@%@%@' or ProcessedUser is NULL )",temp, uName, temp, temp, uName, temp];
    [[CloudService sharedInstance] sqlSearch:@"test_table_1" andCondition:condition withBlock:^(NSMutableArray *result, NSError *error) {
        
        if (!error) {
            if (result.count > 0) {
                //_tableList2 = result;
                _tableList2 = [NSMutableArray arrayWithArray:[result sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    NSString *time1 = ((ContentItems *)obj1).LastChangedTime;
                    NSString *time2 = ((ContentItems *)obj2).LastChangedTime;
                    
                    return [time2 compare:time1];
                }]] ;

                [self.tableView2 reloadData];
               
            }
            else {
                [self showHudOnlyMsg:@"没有内容"];
            }
        }
        else {
            //[UIFactory showAlert:@"网络错误"];
        }
         [self.tableView2 headerEndRefreshing];
    }];

}

- (void)getDocumentSharedToMe {
    NSString *uName = [[[User sharedUser] getUserGlobalDic] objectForKey:uUserName];
    NSString *temp = @"%";
    
    NSString *condition = [NSString stringWithFormat:@"shares like '%@%@%@' and (ProcessedUser not  like '%@%@%@' or ProcessedUser is NULL )", temp, uName, temp, temp, uName, temp];
    [[CloudService sharedInstance] sqlSearch:@"test_table_1" andCondition:condition withBlock:^(NSMutableArray *result, NSError *error) {
        
        if (!error) {
            if (result.count > 0) {
                //_tableList3 = result;
                _tableList3 = [NSMutableArray arrayWithArray:[result sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    NSString *time1 = ((ContentItems *)obj1).LastChangedTime;
                    NSString *time2 = ((ContentItems *)obj2).LastChangedTime;
                    
                    return [time2 compare:time1];
                }]] ;

                [self.tableView3 reloadData];
                
            }
            else {
                [self showHudOnlyMsg:@"没有内容"];
            }
        }
        else {
            //[UIFactory showAlert:@"网络错误"];
        }
        [self.tableView3 headerEndRefreshing];
    }];
}


#pragma mark - LXSegmentView delegate
- (void)lxSegmentViewTurnTabWithCurrentIndex:(NSInteger)currentIndex {
    
    _currentIndex = currentIndex;
    
    if (currentIndex == 0) {
        
        if (_tableList1.count == 0 || _isUploadSuccess || _isGuidangSuccess1) {
            _isUploadSuccess = NO;
            _isGuidangSuccess1 = NO;
            [self setupRefresh:@"table1"];
        }
    }
    else if (currentIndex == 1) {
        if (_tableList2.count == 0 || _isGuidangSuccess2) {
            _isGuidangSuccess2 = NO;
            [self setupRefresh:@"table2"];
        }
    }
    else if (currentIndex == 2) {
        if (_tableList3 == 0 || _isGuidangSuccess3) {
            _isGuidangSuccess3 = NO;
            [self setupRefresh:@"table3"];
        }
    }
}

#pragma mark -
#pragma mark - MJRefresh
/**
 *  集成刷新控件
 */
- (void)setupRefresh:(NSString *)dateKey
{
    if (_currentIndex == 0) {
        // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
        // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
        [_tableView1 addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:dateKey];
        //#warning 自动刷新(一进入程序就下拉刷新)
        [_tableView1 headerBeginRefreshing];
        
        // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
        //[self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
        
        // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
        _tableView1.headerPullToRefreshText = @"下拉可以刷新";
        _tableView1.headerReleaseToRefreshText = @"松开马上刷新";
        _tableView1.headerRefreshingText = @"正在努力帮您刷新中,不客气";
        
        //    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据";
        //    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据";
        //    self.tableView.footerRefreshingText = @"正在努力帮您加载中,不客气";
    }
    else if (_currentIndex == 1) {
        [_tableView2 addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:dateKey];
        [_tableView2 headerBeginRefreshing];
        
        _tableView2.headerPullToRefreshText = @"下拉可以刷新";
        _tableView2.headerReleaseToRefreshText = @"松开马上刷新";
        _tableView2.headerRefreshingText = @"正在努力帮您刷新中,不客气";
    }
    else if (_currentIndex == 2) {
        [_tableView3 addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:dateKey];
        [_tableView3 headerBeginRefreshing];
        
        _tableView3.headerPullToRefreshText = @"下拉可以刷新";
        _tableView3.headerReleaseToRefreshText = @"松开马上刷新";
        _tableView3.headerRefreshingText = @"正在努力帮您刷新中,不客气";
    }
   
}

- (void)headerRereshing
{
    if (_currentIndex == 0) {
        [self getMyCreateDocument];
    }
    else if (_currentIndex == 1) {
        [self getMySharedDocument];
    }
    else if (_currentIndex == 2) {
        [self getDocumentSharedToMe];
    }
    // 刷新表格
    //[self.tableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    //[self.tableView headerEndRefreshing];
    
}


#pragma mark - UITableView DataSource

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == _tableView1) {
        return _tableList1.count;
    }
    else if (tableView == _tableView2) {
        return _tableList2.count;
    }
    else if (tableView == _tableView3) {
        return _tableList3.count;
    }
    
    return 0;
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
    
    
    if (tableView == _tableView1) {
        
        cell.contentItem = [_tableList1 objectAtIndex:indexPath.section];
        
    }
    else if (tableView == _tableView2) {
        cell.contentItem = [_tableList2 objectAtIndex:indexPath.section];
    }
    else if (tableView == _tableView3) {
        cell.contentItem = [_tableList3 objectAtIndex:indexPath.section];
    }
    
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FileDetailVC *detailVC = [[FileDetailVC alloc] initWithNibName:@"FileDetailVC" bundle:nil];
    [detailVC setHidesBottomBarWhenPushed:YES];
    detailVC.delegate = self;
    if (tableView == _tableView1) {
        
        detailVC.contentItem = [_tableList1 objectAtIndex:indexPath.section];
        
    }
    else if (tableView == _tableView2) {
        detailVC.contentItem = [_tableList2 objectAtIndex:indexPath.section];
    }
    else if (tableView == _tableView3) {
        detailVC.contentItem = [_tableList3 objectAtIndex:indexPath.section];
    }

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
    if (_currentIndex == 0) {
        
        [self setupRefresh:@"table1"];
       
    }
    else if (_currentIndex == 1) {
        
        [self setupRefresh:@"table2"];
        
    }
    else if (_currentIndex == 2) {
       
        [self setupRefresh:@"table3"];
        
    }
}

- (void)guidangSuccess {
    
    _isGuidangSuccess1 = YES;
    _isGuidangSuccess2 = YES;
    _isGuidangSuccess3 = YES;
    
    if (_currentIndex == 0) {
        
        [self setupRefresh:@"table1"];
        _isGuidangSuccess1 = NO;
        
    }
    else if (_currentIndex == 1) {
        
        [self setupRefresh:@"table2"];
        _isGuidangSuccess2 = NO;
        
    }
    else if (_currentIndex == 2) {
        
        [self setupRefresh:@"table3"];
        _isGuidangSuccess3 = NO;
        
    }

}


@end
