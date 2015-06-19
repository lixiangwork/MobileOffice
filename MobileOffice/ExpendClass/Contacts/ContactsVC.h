//
//  ContactsVC.h
//  MobileOffice
//
//  Created by MacAir2 on 15/5/27.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "BaseVC.h"
#import "AppCore.h"
#import "TreeViewNode.h"
#import "ContentItems.h"
#import "TreeNodeSecondLevel.h"
#import "TreeNodeThirdLevel.h"

#import "ContactsFirstCell.h"
#import "ContactsSecondCell.h"
#import "ContactsThirdCell.h"

@interface ContactsVC : BaseVC<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

///nodes
@property (strong, nonatomic) NSMutableArray *nodes;
@property (strong, nonatomic) NSMutableArray *displayArray;
@property (strong, nonatomic) NSMutableArray *firstLevelArr;
@property (strong, nonatomic) NSMutableArray *secondLevelArr;
@property (strong, nonatomic) NSMutableArray *thirdLevelArr;

///////////////////////////////////////////////////////////////////////////

/**
 *	@brief	初始树形结构的数组
 */
- (void)fillNodesArray;

/**
 *	@brief	根据父结点title找到相对应的二级结点
 *  @param  fatherTitle  父结点名称
 */
- (NSArray *)fillChildrenForNode:(NSString *)fatherTitle;

/**
 *	@brief	根据父结点titlehe二级结点title找到对应的三级结点
 *  @param  fatherTitle  父结点名称
 *  @param  sonTitle  二级结点名称
 */
-(NSArray *)fillGrandsonForNode:(NSString *)fatherTitle andSonTitle:(NSString *)sonTitle andFatherNodeSelected:(BOOL)isSelected;

//////////////////////////////////////////////////////////////////////////////////////////////


/**
 *	@brief	填充显示tableView上的数组
 */
- (void)fillDisplayArray;
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray;

////////////////////////////////////////////////////////////////////

@end
