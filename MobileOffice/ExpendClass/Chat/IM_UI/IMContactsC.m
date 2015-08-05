//
//  IMContactsC.m
//  MobileOffice
//
//  Created by 李祥 on 15/7/31.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "IMContactsC.h"
#import "AppCore.h"
#import "IIViewDeckController.h"
#import "IMMainMessageC.h"
#import "IMChatVC.h"


@interface IMContactsC ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *tableList;
@property (strong, nonatomic) UITableView *tableView;


@end

@implementation IMContactsC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"我的好友";
    
    _tableList = @[@"lixiang", @"lx"];
    
    
}

- (void)initUI {
    [super initUI];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _tableList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *IMContactCellIdentifier = @"IMContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IMContactCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IMContactCellIdentifier];
    }
    
    cell.textLabel.text = [_tableList objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark -tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IMChatVC *chatVC = [[IMChatVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:chatVC];
    
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
    
    ///////////
    
//      [self.viewDeckController closeLeftViewAnimated:NO completion:^(IIViewDeckController *controller, BOOL success) {
//          
//          IMChatVC *chatVC = [[IMChatVC alloc] init];
//          //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:chatVC];
//          
//          ///////////
//          UINavigationController *nav = (UINavigationController *)controller.centerController;
//         
//        [nav pushViewController:chatVC animated:YES];
//          
//
//    }];
}

@end
