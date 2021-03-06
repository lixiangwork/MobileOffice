//
//  ContactsVC.m
//  MobileOffice
//
//  Created by MacAir2 on 15/5/27.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "ContactsVC.h"


#import "NoticeVC.h"



@interface ContactsVC ()



@end

@implementation ContactsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"通讯录";
    
    
    //[self getContentData];
    
    NSData *data = [[NSData alloc]initWithContentsOfFile:ContactsPath];
    NSMutableArray *_contactsArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (_contactsArray.count == 0) {
        [self getContentData];
    }
    else{
        [self fillLevelArraysWithContactsArray:_contactsArray];
        [self fillNodesArray];
        [self fillDisplayArray];
        [self.tableView reloadData];
    }

}

- (void)initUI {
    [super initUI];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(10, 0, 44, 44)];
    //[leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[leftBtn setTitle:@"公告列表" forState:UIControlStateNormal];
    //[leftBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [leftBtn setImage:[UIImage imageNamed:@"notice.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(LeftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - My Action
- (void)LeftBtnAction{
    
    NoticeVC *vc = [[NoticeVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - getDataFromNet
- (void)getContentData{
    [self showHud];
    [[CloudService sharedInstance] getAllContentTypeInfo:@"MobileConstacts" withBlock:^(NSArray *results, NSError *error) {
        [self hideHud];
        if (!error) {
            if (results.count != 0) {
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:results];
                [data writeToFile:ContactsPath atomically:NO];
                
                [self fillLevelArraysWithContactsArray:[results mutableCopy]];
                [self fillNodesArray];
                [self fillDisplayArray];
               
                
                [self.tableView reloadData];

            }
        }
        else{
            [UIFactory showAlert:@"网络错误"];
        }
    }];
}

#pragma mark - Private Array

- (void)fillLevelArraysWithContactsArray:(NSMutableArray *)contactsArray;
{
    ///fill firstLevelArray
    _firstLevelArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < contactsArray.count; i++) {
        ContentItems *item = [contactsArray objectAtIndex:i];
        NSString *company = [item.Properties objectForKey:@"ymCompany"];
    
        if (![_firstLevelArr containsObject:company]) {
            [_firstLevelArr addObject:company];
        }
    }
    
    //fill secondLevelArray
    _secondLevelArr = [[NSMutableArray alloc] init];
    for (int j = 0; j < _firstLevelArr.count; j++) {
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i = 0; i < contactsArray.count; i++) {
            ContentItems *item = [contactsArray objectAtIndex:i];
            NSString *company = [item.Properties objectForKey:@"ymCompany"];
            NSString *department = [item.Properties objectForKey:@"ymDepartment"];
            
            if ([_firstLevelArr[j] isEqualToString:company]) {
                
                TreeNodeSecondLevel *secondLevel = [[TreeNodeSecondLevel alloc] initWithFirstLevelTitle:company andsecondLevelTitle:department];
                
                if (![arr containsObject:department]) {
                    [arr addObject:department];
                    [_secondLevelArr addObject:secondLevel];
                    
                    NSLog(@"%@",secondLevel.secondLevelTitle);
                }
                
            }
        }
    }
    
    
    //////fill thirdLevelArr
    _thirdLevelArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < contactsArray.count; i++) {
        ContentItems *item = [contactsArray objectAtIndex:i];
        NSString *company = [item.Properties objectForKey:@"ymCompany"];
        NSString *department = [item.Properties objectForKey:@"ymDepartment"];
        NSString *nickName = [item.Properties objectForKey:@"ymNickName"];
        NSString *userName = [item.Properties objectForKey:@"ymUserName"];
        NSString *position = [item.Properties objectForKey:@"ymPositions"];
        NSString *phone = [item.Properties objectForKey:@"ymMobilePhone"];
        
        TreeNodeThirdLevel *thirdLevel = [[TreeNodeThirdLevel alloc] initWithFtitle:company andStitle:department andTtitle:nickName andUserName:userName andDescription:position andPhoneNum:phone];
        
        [_thirdLevelArr addObject:thirdLevel];
    }
    
}

#pragma mark - Private Nodes
- (void)fillNodesArray
{
    _nodes = [[NSMutableArray alloc] init];
    
    for (int i=0; i<_firstLevelArr.count; i++) {
        TreeViewNode *firstLevelNode = [[TreeViewNode alloc] init];
        firstLevelNode.nodeLevel = 0;
        firstLevelNode.isExpanded = YES;
        
        firstLevelNode.isNodeSelected = NO;
        
        NSString *title = _firstLevelArr[i];
        firstLevelNode.nodeObject = [NSString stringWithFormat:@"%@",title];
        
        firstLevelNode.nodeChildren = [[self fillChildrenForNode:title] mutableCopy];
        
        [_nodes addObject:firstLevelNode];
    }
}

- (NSArray *)fillChildrenForNode:(NSString *)fatherTitle
{
    NSMutableArray *childrenArray = [[NSMutableArray alloc] init];
    
    //根据参数fatherTitle 找出_SecondLevelArr中符合条件的
    for (TreeNodeSecondLevel *sl in _secondLevelArr) {
        if ([sl.firstLevelTitle isEqualToString:fatherTitle]) {
            
            TreeViewNode *SecondLevelNode = [[TreeViewNode alloc] init];
            SecondLevelNode.nodeLevel = 1;
            SecondLevelNode.isExpanded = NO;
            
            SecondLevelNode.nodeObject = sl;
            SecondLevelNode.isNodeSelected = NO;
            
            SecondLevelNode.nodeChildren = [[self fillGrandsonForNode:fatherTitle andSonTitle:sl.secondLevelTitle andFatherNodeSelected:NO] mutableCopy];
            
            [childrenArray addObject:SecondLevelNode];
        }
    }
    
    return childrenArray;
    
}

-(NSArray *)fillGrandsonForNode:(NSString *)fatherTitle andSonTitle:(NSString *)sonTitle andFatherNodeSelected:(BOOL)isSelected
{
    NSMutableArray *grandsonArray = [[NSMutableArray alloc] init];
    
    for (TreeNodeThirdLevel *thirdLevel in _thirdLevelArr) {
        
        if ([thirdLevel.firstLevelTitle isEqualToString:fatherTitle] && [thirdLevel.secondLevelTitle isEqualToString:sonTitle]) {
            
            TreeViewNode *thirdLevelNode = [[TreeViewNode alloc] init];
            thirdLevelNode.nodeLevel = 2;
            thirdLevelNode.isExpanded = NO;
            
            thirdLevelNode.nodeObject = thirdLevel;
            
            thirdLevelNode.isNodeSelected = isSelected;
            
            thirdLevelNode.nodeChildren = nil;
            
            [grandsonArray addObject:thirdLevelNode];
        }
    }
    return grandsonArray;
    
}

#pragma mark - Private  displayArray
- (void)fillDisplayArray
{
    _displayArray = [[NSMutableArray alloc]init];
    for (TreeViewNode *node in _nodes) {
        [_displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (TreeViewNode *node in childrenArray) {
        [_displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}


#pragma mark - UITableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _displayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier1 = @"ContactsFirstCell_identfier";
    static NSString *CellIdentifier2 = @"ContactsSecondCell_identfier";
    static NSString *CellIdentifier3 = @"ContactsThirdCell_identfier";
    
    TreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    
    if (node.nodeLevel == 0) {
        UINib *nib = [UINib nibWithNibName:@"ContactsFirstCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier1];
        ContactsFirstCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        cell.titleLabel.text = node.nodeObject;
        
        if (node.isExpanded) {
            [cell setTheJiantouView:[UIImage imageNamed:@"tree_view_icon_open.png"]];
        }
        else{
            [cell setTheJiantouView:[UIImage imageNamed:@"tree_view_icon_close.png"]];
        }
        
        return cell;
        
    }
    else if (node.nodeLevel == 1){
        UINib *nib = [UINib nibWithNibName:@"ContactsSecondCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier2];
        ContactsSecondCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        
        TreeNodeSecondLevel *secondLevel = (TreeNodeSecondLevel *)node.nodeObject;
        cell.titleLabel.text = secondLevel.secondLevelTitle;
        
        if (node.isExpanded) {
            [cell setTheJiantouView:[UIImage imageNamed:@"tree_view_icon_open.png"]];
        }
        else{
            [cell setTheJiantouView:[UIImage imageNamed:@"tree_view_icon_close.png"]];
        }
        
        return cell;
        
    }
    else{
        UINib *nib = [UINib nibWithNibName:@"ContactsThirdCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier3];
        ContactsThirdCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        
        TreeNodeThirdLevel *thirdLevel = (TreeNodeThirdLevel *)node.nodeObject;
        cell.titleLabel.text = thirdLevel.thirdLevelTitle;
        //cell.positionLabel.text = thirdLevel.description;
        cell.phoneTV.text = thirdLevel.phoneNum;
        
        return cell;
    }
    
    //return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    if (node.nodeLevel == 0) {
        return 50;
    }
    else {
        return 44;
    }
}

#pragma mark - UITableView delegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    
    if (node.nodeLevel == 0) {
        node.isExpanded = !node.isExpanded;
        
        [self fillDisplayArray];
        [_tableView reloadData];
    }
    else if (node.nodeLevel == 1){
        node.isExpanded = !node.isExpanded;
        
        [self fillDisplayArray];
        [_tableView reloadData];
    }
    
}



@end
