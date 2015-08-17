//
//  ChooseSharerVC.m
//  MobileOffice
//
//  Created by MacAir2 on 15/6/19.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "ChooseSharerVC.h"
#import "SharerSecondCell.h"
#import "SharerThirdCell.h"

@interface ChooseSharerVC () <SharerSecondCellDelegate>

@property (strong, nonatomic) NSMutableArray *allSelectedThirdLevelNodes;

@end

@implementation ChooseSharerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"共享群组";
    _allSelectedThirdLevelNodes = [[NSMutableArray alloc] init];
}

- (void)initUI {
    [super initUI];
    
    UIButton *backButton = [UIFactory createButtonWithRect:CGRectMake(15, 0, 54, 44) normal:@"nav_backButtonBg.png" highlight:nil selector:@selector(backButtonClicked:) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];

    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setFrame:CGRectMake(270, 20, 54, 44)];
    [rightButton setImage:[UIImage imageNamed:@"nav_quedingButtonBg.png"] forState:UIControlStateNormal];
    //[rightButton setImageEdgeInsets:UIEdgeInsetsMake(3, 0, 3, 0)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get allSelectedThirdLevelNodes

- (void)TraversalNodes
{
    for (TreeViewNode *node in self.nodes) {
        if (node.nodeChildren) {
            [self TraversalChildrenNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

- (void)TraversalChildrenNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (TreeViewNode *node in childrenArray) {
        
        if (node.nodeLevel == 2 && node.isNodeSelected) {
            [_allSelectedThirdLevelNodes addObject:node];
        }
        if (node.nodeChildren) {
            [self TraversalChildrenNodeWithChildrenArray:node.nodeChildren];
        }
    }
}


#pragma mark - action
- (void)backButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)rightButtonClicked:(id)sender {
    [self TraversalNodes];
    NSLog(@"_allSelectedThirdLevelNodes Numbers:%lu",(unsigned long)_allSelectedThirdLevelNodes.count);
    if (_allSelectedThirdLevelNodes.count == 0) {
        [UIFactory showAlert:@"没有选择共享人"];
    }
    else {
        
        NSString *shares = [_cItem.Properties objectForKey:@"shares"];
        NSString *sharesFrom = [_cItem.Properties objectForKey:@"shares_from"];
        
        NSString *newShares = @"";
        if (shares) {
            newShares = shares;
        }
        
        NSString *newSharesFrom = @"";
        if (sharesFrom) {
            if ([newSharesFrom rangeOfString:sharesFrom].location != NSNotFound) {
                newSharesFrom = sharesFrom;
            }
            else {
                newSharesFrom = [NSString stringWithFormat:@"%@%@,",newSharesFrom,[[[User sharedUser] getUserGlobalDic] objectForKey:uUserName]];
            }
        }

        for (int i=0 ; i<_allSelectedThirdLevelNodes.count; i++) {
            TreeViewNode *node = [_allSelectedThirdLevelNodes objectAtIndex:i];
            TreeNodeThirdLevel *thirdLevel = (TreeNodeThirdLevel *)node.nodeObject;
            
            if ([newShares rangeOfString:thirdLevel.userName].location != NSNotFound) {
                continue;
            }
            else{
                
                newShares = [NSString stringWithFormat:@"%@%@,",newShares,thirdLevel.userName];
            }
        }
        
        if (![shares isEqualToString:newShares]) {
            [self alertSharerlist:newShares andShareFromList:newSharesFrom];
        }
        else{
            [UIFactory showAlert:@"分享成功"];
        }
        
    }
}

#pragma mark - Clound
- (void)alertSharerlist:(NSString *)shares andShareFromList:(NSString *)shareFrom{
    
    /*[[CloudService sharedInstance] alterContentProperty:_cItem.ContentID andPropertyName:@"shares" andPropertyType:@"12" andPropertyValue:shares andContentType:@"test_table_1" withBlock:^(BOOL success, NSError *error) {
        if (!error) {
            [self hideHud];
            if (success) {
                NSLog(@"更新分享成功");
                            }
            else {
                NSLog(@"更新分享失败%@",[error description]);
            }
        }
        else {
            //[UIFactory showAlert:@"网络错误"];
        }
        
    }];*/
    NSMutableArray *properties = [[NSMutableArray alloc] init];
    PropertyItem *pItem1 = [[PropertyItem alloc] init];
    pItem1.name = @"shares";
    pItem1.type = @"12";
    pItem1.value = shares;
    [properties addObject:pItem1];
    
    PropertyItem *pItem2 = [[PropertyItem alloc] init];
    pItem2.name = @"shares_from";
    pItem2.type = @"12";
    pItem2.value = shareFrom;
    [properties addObject:pItem2];

    [self showHudWithMsg:@"分享中..."];
    [[CloudService sharedInstance] alterContentProperties:_cItem.ContentID andPropertyList:properties andContentType:@"test_table_1" withBlock:^(BOOL success, NSError *error) {
        [self hideHud];
        if (!error) {
            if (success) {
                if ([self.delegate respondsToSelector:@selector(chooseSharerVCSharedSuccess:)]) {
                    [self.delegate chooseSharerVCSharedSuccess:shares];
                }
                //NSLog(@"更新分享成功");
                [UIFactory showAlert:@"分享成功"];
            }
            else {
                //NSLog(@"更新分享失败%@",[error description]);
                [UIFactory showAlert:@"分享失败"];
            }
        }
        else {
            [UIFactory showAlert:@"网络错误"];
        }

    }];

}

#pragma mark - UItableView datasource  delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"ContactsFirstCell_identfier";
    static NSString *CellIdentifier2 = @"SharerSecondCell_identfier";
    static NSString *CellIdentifier3 = @"SharerThirdCell_identfier";
    
    TreeViewNode *node = [self.displayArray objectAtIndex:indexPath.row];
    
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
        UINib *nib = [UINib nibWithNibName:@"SharerSecondCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier2];
        SharerSecondCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        cell.delegate = self;
        cell.node = node;
        TreeNodeSecondLevel *secondLevel = (TreeNodeSecondLevel *)node.nodeObject;
        cell.titleLabel.text = secondLevel.secondLevelTitle;
        
        if (node.isExpanded) {
            [cell setTheJiantouImageView:[UIImage imageNamed:@"tree_view_icon_open.png"]];
        }
        else{
            [cell setTheJiantouImageView:[UIImage imageNamed:@"tree_view_icon_close.png"]];
        }
        
        return cell;
        
    }
    else{
        UINib *nib = [UINib nibWithNibName:@"SharerThirdCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier3];
        SharerThirdCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        
        TreeNodeThirdLevel *thirdLevel = (TreeNodeThirdLevel *)node.nodeObject;
        cell.node = node;
        cell.titleLabel.text = thirdLevel.thirdLevelTitle;
        //cell.positionLabel.text = thirdLevel.description;
        //cell.phoneTV.text = thirdLevel.phoneNum;
        
        return cell;
    }

}


#pragma mark - ShareSecondCell delegate
- (void)SharerSecondCellCheckButtonClicked:(TreeViewNode *)node {
    //node.isExpanded = !node.isExpanded;
    [self fillDisplayArray];
    [self.tableView reloadData];
}


@end
