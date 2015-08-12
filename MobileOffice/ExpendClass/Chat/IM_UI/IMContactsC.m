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

#import "IMXMPPManager.h"
#import "IMLocalSearchViewModel.h"
#import "IMContactCell.h"
#import "IMStaticContactCell.h"
#import "IMChatVC.h"
#import "IMSearchDisplayController.h"
#import "IMMainMessageViewModel.h"
#import "IMContactEntity.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "IMUIHelper.h"
#import "TTGlobalUICommon.h"

@interface IMContactsC ()<UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) IMSearchDisplayController *searchController;


@end

@implementation IMContactsC

- (void)dealloc
{
    [[IMXMPPManager sharedManager].xmppRoster removeDelegate:self delegateQueue:dispatch_get_main_queue()];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"我的好友";
    
    self.viewModel = [IMContactsViewModel sharedViewModel];
    
    @weakify(self);
    [self.viewModel.updatedContentSignal subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];

//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.f, 0.f,
                                                                           self.view.width, TT_TOOLBAR_HEIGHT)];
    searchBar.tintColor = APP_MAIN_COLOR;
    self.tableView.tableHeaderView = searchBar;
    
    IMSearchDisplayController *searchDisplayController = [[IMSearchDisplayController alloc] initWithSearchBar:searchBar
                                                                                           contentsController:self];
    self.searchController = searchDisplayController;

}

- (void)initUI {
    [super initUI];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    self.tableView.rowHeight = ADDRESS_BOOK_ROW_HEIGHT;
    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.tableView.tableFooterView = [IMUIHelper createDefaultTableFooterView];
    
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - Private

- (void)showAddFriendsView
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"请输入好友jid" message:nil
                                                delegate:nil cancelButtonTitle:@"取消"
                                       otherButtonTitles:@"发送请求", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av show];
    [[av rac_buttonClickedSignal] subscribeNext:^(id x) {
        if ([x intValue] == 1) {
            UITextField *tf = [av textFieldAtIndex:0];
            XMPPJID *jid = [XMPPJID jidWithUser:tf.text domain:XMPP_DOMAIN resource:XMPP_RESOURCE];
            [[[IMXMPPManager sharedManager] xmppRoster] addUser:jid
                                                   withNickname:tf.text];
        }
    }];
}


#pragma mark - Table view data source

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
     return [self.viewModel sectionIndexTitles];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.viewModel numberOfSections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.viewModel titleForHeaderInSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.viewModel numberOfItemsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *IMContactCellIdentifier = @"IMContactCell";
    static NSString *IMStaticContactCellIdentifier = @"IMStaticContactCellIdentifier";
    
    UITableViewCell *cell = nil;
    id object = [self.viewModel objectAtIndexPath:indexPath];
    if ([object isKindOfClass:[XMPPUserCoreDataStorageObject class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:IMContactCellIdentifier];
        if (!cell) {
            cell = [[IMContactCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:IMContactCellIdentifier];
        }
        
        XMPPUserCoreDataStorageObject *user = (XMPPUserCoreDataStorageObject *)object;
        [(IMContactCell *)cell shouldUpdateCellWithObject:user];
    }
    else if ([object isKindOfClass:[NSString class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:IMStaticContactCellIdentifier];
        if (!cell) {
            cell = [[IMStaticContactCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:IMStaticContactCellIdentifier];
        }
        [(IMStaticContactCell *)cell shouldUpdateCellWithObject:object
                                           unsubscribedCountNum:self.viewModel.unsubscribedCountNum];
    }

    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0) {
        return YES;
    }
    else {
        // section 0 不可删除
        return NO;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0) {
        return UITableViewCellEditingStyleDelete;
    }
    else {
        // section 0 不可删除
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0 && editingStyle == UITableViewCellEditingStyleDelete) {
        
        XMPPUserCoreDataStorageObject *user = [self.viewModel objectAtIndexPath:indexPath];
        
        // 1、 解除好友关系，调用删除接口
        //        if (!self.rosterAddtionlViewModel) {
        //            self.rosterAddtionlViewModel = [[IMRosterAddtionalViewModel alloc] init];
        //        }
        //        [self.rosterAddtionlViewModel deleteFriend:user.jid.user
        //                                            withMe:MY_JID.user
        //                                           success:^{
        //                                               NSLog(@"delete friend success");
        //                                           }
        //                                           failure:^(NSString *errorMsg) {
        //                                               NSLog(@"delete friend error:%@", errorMsg);
        //                                           }];
        // 2、xmpp删除
        [[IMXMPPManager sharedManager].xmppRoster removeUser:user.jid];
        
        // 3、同步删除联系人
        if ([[IMMainMessageViewModel sharedViewModel] deleteRecentContactWithJid:user.jid]) {
            NSLog(@"deleteRecentContact:%@", user.jid.bare);
        };
        
        if ([self.viewModel deleteUser:user]) {
            NSLog(@"deleteUser:%@", user.jid.bare);
            
            // 删除数据库，底层fetchController会controllerDidChangeContent
            // 不用手工删除cell
        }
    }
}


#pragma mark -tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                //                [self showNewFriendsView];
                self.viewModel.unsubscribedCountNum = @0;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
                break;
                
            default:
                break;
        }
    }
    else {
        
        XMPPUserCoreDataStorageObject *user = [self.viewModel objectAtIndexPath:indexPath];
        
        IMChatVC *chatVC = [[IMChatVC alloc] initWithBuddyJID:user.jid buddyName:user.nickname];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:chatVC];
        
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 0.f;
    }
    return 25.f;//[super tableview:tableView heightForHeaderInSection:section];
}

@end
