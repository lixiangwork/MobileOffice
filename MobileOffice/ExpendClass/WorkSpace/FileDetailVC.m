//
//  FileDetailVC.m
//  MobileOffice
//
//  Created by MacAir2 on 15/6/18.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "FileDetailVC.h"
#import "FileDetailCell.h"
#import "ShareCell.h"
#import "CommentCell.h"
#import "CustomIOSAlertView.h"
#import "CommentItems.h"

#define DeleteActionSheetTag 1
//#define ShareActionSheetTag 2
#define HandleActionSheetTag 3

@interface FileDetailVC ()<UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate, UIActionSheetDelegate>

- (IBAction)lookupButtonClicked:(id)sender;
- (IBAction)commentButtonClicked:(id)sender;
- (IBAction)handleButtonClicked:(id)sender;
- (IBAction)shareButtonClicked:(id)sender;
- (IBAction)deleteButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *commentArray;


/////
@property (strong, nonatomic) ShareCell *shareCell;
@property (strong, nonatomic) CommentCell *commentCell;


/////
@property (strong, nonatomic) UIDocumentInteractionController *documentController;

/////
@property (strong, nonatomic) UITextView *commentTextView;

@end

@implementation FileDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"文件详情";
    
    //////
    _shareCell = [[ShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShareCell_identfier"];
    _commentCell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell_identfier"];
    /////////////////
    
    _commentArray = [[NSMutableArray alloc] init];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -myself
- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 160)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 270, 20)];
    titleLabel.text = @"评论";
    [titleLabel setTextColor:RGBCOLOR(0, 122, 255)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [demoView addSubview:titleLabel];
    
    _commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, 270, 120)];
    [demoView addSubview:_commentTextView];
    
    return demoView;
}


#pragma mark - lookup
- (void)lookupDocument:(NSURL *)myURL
{
    _documentController = [[UIDocumentInteractionController alloc] init];
    _documentController = [UIDocumentInteractionController interactionControllerWithURL:myURL];
    _documentController.delegate = self;
    //[_documentController presentPreviewAnimated:YES];
    [_documentController presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
}


#pragma mark - IBAction
- (IBAction)lookupButtonClicked:(id)sender {
    if (_contentItem.DocumentID) {
        if (_contentItem.IsLocalFile) {
            NSURL *myURL = [self ConstituteURL];
            [self lookupDocument:myURL];
        }
        else {

            [self showHudWithMsg:@"下载中..."];
            [[CloudService sharedInstance] getDocumentInfo:_contentItem.DocumentID withBlock:^(NSMutableArray *result, NSError *error) {
                [self hideHud];
                if (!error) {
                    if (result.count > 0) {
                        DocumentItem *dItem = result[0];
                        //NSLog(@"documentResult:%@\t%@\t%@",item.DocumentID,item.SourceFileName,dItem.InputStream);
                        
                        NSData* dataContent = [GTMBase64 decodeString:dItem.InputStream];
                        [self registerInDefaults:dItem];
                        
                        NSURL *fileURL = [self ConstituteURL];
                        
                        BOOL resultFlag = [dataContent writeToURL:fileURL atomically:YES];
                        
                        if (!resultFlag) {
                            NSLog(@"!!!!!!!!!!!!!写入文件失败");
                        }
                        _contentItem.IsLocalFile = YES;
                        
                        [self lookupDocument:fileURL];
                    }
                    else {
                        [UIFactory showAlert:@"下载失败"];
                    }
                }
                else {
                    [UIFactory showAlert:@"网络错误"];
                }
                
            }];
        }
    }
}

- (IBAction)commentButtonClicked:(id)sender {
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    [alert setContainerView:[self createDemoView]];
    [alert setButtonTitles:[@[@"取消", @"提交"] mutableCopy]];
    
    [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        //NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        NSLog(@"comment:%@",_commentTextView.text);
        
        if (buttonIndex == 1) {
            if ([_commentTextView.text isEqualToString:@""]) {
                return;
            }
            else{
                CommentItems *item = [[CommentItems alloc] init];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                item.date = [dateFormatter stringFromDate:[NSDate date]];
                NSLog(@"%@", item.date);
                
                item.commentor = [[[User sharedUser] getUserGlobalDic] objectForKey:uUserName];
                item.content = _commentTextView.text;
                
                
                [_commentArray addObject:item];
                
                //dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                //});
                
                
                
                [self alertCommentToClound:_commentArray];
                
                
            }

        }
        
        [alertView close];
    }];
    //[alert setDelegate:self];
    [alert setUseMotionEffects:YES];
    [alert show];

}

- (IBAction)handleButtonClicked:(id)sender {
    
}

- (IBAction)shareButtonClicked:(id)sender {
}

- (IBAction)deleteButtonClicked:(id)sender {
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"删除文档" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"在云平台上删除",@"从本地删除" ,nil];
    actionSheet.tag = DeleteActionSheetTag;
    actionSheet.destructiveButtonIndex = -1;
    //        actionSheet.cancelButtonIndex = 0;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark -
#pragma mark - localFile methods
-(NSURL*) ConstituteURL
{
    NSMutableDictionary* MuDic = [[[LocalFileDic sharedInstance] getLocalFileGlobalDic] mutableCopy];
    NSString* SubPath =  [MuDic objectForKey:_contentItem.ContentID];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@",DOCUMENT_FOLDER_DIR,SubPath];
    return [NSURL fileURLWithPath:filePath isDirectory:NO];
}

-(void) registerInDefaults:(DocumentItem*)dItem
{
    NSMutableDictionary* Mudic =[[[LocalFileDic sharedInstance] getLocalFileGlobalDic] mutableCopy];
    
    NSString *exestr = [dItem.SourceFileName pathExtension];
    NSLog(@"exestr:%@",exestr);
    
    NSString *valueStr = [NSString stringWithFormat:@"%@.%@",[_contentItem.Properties objectForKey:@"zh_wzbt"],exestr];
    
    [Mudic setValue:valueStr forKey:_contentItem.ContentID];
    NSLog(@"sourceFileName:%@",valueStr);
    
    [[LocalFileDic sharedInstance] setLocalFileGlobalDic:Mudic];
}


-(void) DeleteLocalFile
{
    NSURL* FileURL = [self ConstituteURL];
    //NSData* TheFileData = [NSData dataWithContentsOfURL:FileURL];
    //    if (TheFileData) {
    //        NSLog(@"file exist");
    NSFileManager* ma = [NSFileManager defaultManager];
    NSError* err = [[NSError alloc] init];
    [ma removeItemAtPath:[FileURL path] error:&err];
    _contentItem.IsLocalFile = NO;
    
    NSDictionary* Paths = [[LocalFileDic sharedInstance] getLocalFileGlobalDic];
    NSMutableDictionary* NewPaths = [[NSMutableDictionary alloc] initWithDictionary:Paths];
    [NewPaths removeObjectForKey:_contentItem.ContentID];
    //[[NSUserDefaults standardUserDefaults] setValue:NewPaths forKey:@"Paths"];
    [[LocalFileDic sharedInstance] setLocalFileGlobalDic:NewPaths];
    
}

#pragma mark - getComment
- (void)getCommentFromClound
{
    if (_contentItem.CommentID) {
        //[_actIndicator startAnimating];
        
        ///获取评论
        //[];
        
    }
    else{
        NSLog(@"!!!!!!!!!!!!!!!!当前没有评论");
        //        CommentItem *mItem = [[CommentItem alloc] init];
        //        mItem.date = @"";
        //        mItem.commentor = @"";
        //        mItem.content = @"当前没有评论!";
        //
        //        [_commentArray addObject:mItem];
    }
}


#pragma mark - alert comment
- (void)alertCommentToClound:(NSMutableArray *)commArr {
    
   /* NSMutableString* newCommentsStr  = [[NSMutableString alloc] init];
    for (CommentItems *item in commArr) {
        [newCommentsStr appendString:[NSString stringWithFormat:@"%@_%@_%@",item.commentor,item.date,item.content]];
        [newCommentsStr appendString:@"\n"];
    }
    
    NSData* commentData = [newCommentsStr dataUsingEncoding:-2147481296];
    //NSData* commentData = [newCommentsStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* encoderedData = [GTMBase64 encodeData:commentData];
    
    NSString *commentID = @"";
    if (_contentItem.CommentID) {
        commentID = _contentItem.CommentID;
    }*/

}


#pragma mark - UITableView datasource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1){
        return 1;
    }
    else if (section == 2){
        return _commentArray.count;
    }
    else{
        return 0;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier1 = @"FileDetail_identifier";
    static NSString *CellIdentifier2 = @"ShareCell_identfier";
    static NSString *CellIdentifier3 = @"CommentCell_identfier";

    
    if (indexPath.section == 0) {
        UINib *nib = [UINib nibWithNibName:@"FileDetailCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier1];
        FileDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        cell.item = _contentItem;
        
        return cell;
        
    }
    else if (indexPath.section == 1){
        ShareCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[ShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        ((ShareCell *)cell).sharePeopers = [_contentItem.Properties objectForKey:@"shares"];
        
        return cell;
    }
    else if (indexPath.section == 2){
        
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        if (cell == nil) {
            cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
        }
        
        ((CommentCell *)cell).cItem = [_commentArray objectAtIndex:indexPath.row];
        
        return cell;
    }
    else{
        return nil;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 290, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor darkGrayColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont systemFontOfSize:14];
    
    
    if (section == 1){
        NSString *shareMens = [_contentItem.Properties objectForKey:@"shares"];
        //NSLog(@"share:%@",shareMens);
        
        NSArray *shareArr = [shareMens componentsSeparatedByString:@","];
        //NSLog(@"shareArr:%@",shareArr);
        
        headerLabel.text = [NSString stringWithFormat:@"已共享%lu人",(unsigned long)shareArr.count ];
    }
    else if(section == 2){
        headerLabel.text = [NSString stringWithFormat:@"评论 %@",[_contentItem.Properties objectForKey:@"comment_num"]];
    }
    else{
        headerLabel.text = @"";
    }
    
    [customView addSubview:headerLabel];
    
    return customView;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 200.0f;
    }
    else if (indexPath.section == 1){
        
        CGFloat height =[_shareCell layoutThatContentItems:[_contentItem.Properties objectForKey:@"shares"]];
        
        return height;
    }
    else if (indexPath.section == 2){
        
        CGFloat height =  [_commentCell layoutThatContentItems:[_commentArray objectAtIndex:indexPath.row]];
        
        return height;
        
    }
    else{
        return 0.0f;
    }
    
}

#pragma mark - documentInteractionController delegate

- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller
{
    return self;
}
- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller
{
    return self.view;
}
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
{
    
    return self.view.frame;
}

#pragma mark ActinoSheet delegate methods
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    NSLog(@"button clicked :%d", buttonIndex);
    
    if (actionSheet.tag == DeleteActionSheetTag) {
        if (buttonIndex == 0) {
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您没有权限从云平台删除文件！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if(buttonIndex == 1 && _contentItem.IsLocalFile){
            [self DeleteLocalFile];
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"删除成功" message:@"文件已经成功在本地删除" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            //            self.parentView.IsChanged = YES;
        }
    }
}



@end
