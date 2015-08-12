//
//  IMMainMessageC.m
//  MobileOffice
//
//  Created by 李祥 on 15/7/31.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "IMMainMessageC.h"
#import "AppCore.h"
#import "IIViewDeckController.h"
#import "IMChatVC.h"

#import "IMRecentContactCell.h"
#import "IMXMPPManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "IMUIHelper.h"


@interface IMMainMessageC ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation IMMainMessageC

- (id)init {
    self = [super init];
    if (self) {
        self.viewModel = [IMMainMessageViewModel sharedViewModel];
        
        [[IMXMPPManager sharedManager].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        @weakify(self);
        [self.viewModel.updatedContentSignal subscribeNext:^(id x) {
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resetCurrentContactUnreadMessagesCountNofity:)
                                                     name:@"RESET_CURRENT_CONTACT_UNREAD_MESSAGES_COUNT"
                                                   object:nil];

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [[[User sharedUser] getUserGlobalDic] objectForKey:uNickName];
    
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }

     self.tableView.tableFooterView = [IMUIHelper createDefaultTableFooterView];
    
}

- (void)initUI {
    [super initUI];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(15, 7, 30, 30);
    [leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"chat_showleft.png"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![[User sharedUser] isOpenIM]) {
        UIView *theView = [UIFactory waitingViewWithMessage:@"聊天未开启，请在设置中开启聊天!"];
        theView.tag = 999;
        [self.viewDeckController.view addSubview:theView];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (![[User sharedUser] isOpenIM]) {
        
        [[self.viewDeckController.view viewWithTag:999] removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)resetCurrentContactUnreadMessagesCountNofity:(NSNotification *)nofify
{
    id object = nofify.object;
    if ([object isKindOfClass:[XMPPJID class]]) {
        XMPPJID *contactJid = (XMPPJID *)object;
        [self.viewModel resetUnreadMessagesCountForCurrentContact:contactJid];
    }
}


#pragma mark - action
- (void)leftButtonClicked:(id)sender {
    [self.viewDeckController toggleLeftView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.viewModel numberOfItemsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"IMRecentContactCell";
    
    IMRecentContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[IMRecentContactCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
    }
    
    XMPPMessageArchiving_Contact_CoreDataObject *contact = [self.viewModel objectAtIndexPath:indexPath];
    [cell shouldUpdateCellWithObject:contact];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.viewModel deleteObjectAtIndexPath:indexPath];
    }
}


#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     XMPPMessageArchiving_Contact_CoreDataObject *contact = [self.viewModel objectAtIndexPath:indexPath];
    
    IMChatVC *chatVC = [[IMChatVC alloc] initWithBuddyJID:contact.bareJid buddyName:contact.displayName];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:chatVC];
    
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
    
    // reset unread message count
    if ([self.viewModel resetUnreadMessagesCountForCurrentContact:contact.bareJid]) {
        if ([self.tableView numberOfSections] > indexPath.section
            && [self.tableView numberOfRowsInSection:indexPath.section] > indexPath.row) {
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }

}

#pragma mark - XMPPStreamDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
}


@end
