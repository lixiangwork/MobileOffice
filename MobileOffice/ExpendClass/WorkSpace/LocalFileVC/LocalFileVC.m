//
//  LocalFileVC.m
//  MobileOffice
//
//  Created by houjing on 15/6/11.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "LocalFileVC.h"
#import "LocalFileVCCell.h"

@interface LocalFileVC ()<UITableViewDataSource,UITableViewDelegate, UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *allLoaclFiles;

@property (strong, nonatomic) UIDocumentInteractionController *documentController;

@end

@implementation LocalFileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"本地文件";
    
    NSDictionary* LocalDic = [[LocalFileDic sharedInstance] getLocalFileGlobalDic] ;
    _allLoaclFiles = [[LocalDic allValues] mutableCopy];
}

- (void)initUI{
    
    [super initUI];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - myself
-(NSURL*) ConstituteURL:(NSString*) subPath
{
    NSString* filePath = [NSString stringWithFormat:@"%@/%@",DOCUMENT_FOLDER_DIR,subPath];
    return [NSURL fileURLWithPath:filePath isDirectory:NO];
}

#pragma mark - lookup
- (void)lookupDocument:(NSURL *)myURL andThefileName:(NSString *)thefileName
{
    //_documentController = [[UIDocumentInteractionController alloc] init];
    _documentController = [UIDocumentInteractionController interactionControllerWithURL:myURL];
    _documentController.delegate = self;
    
    if ([thefileName isEqualToString:@"png"] || [thefileName isEqualToString:@"JPG"] ||  [thefileName isEqualToString:@"jpg"] || [thefileName isEqualToString:@"jpeg"]) {
        
        [_documentController presentPreviewAnimated:YES];
    }
    else {
        [_documentController presentOptionsMenuFromRect:self.view.frame inView:self.view animated:YES];
    }
    //
    //[_documentController presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
}



#pragma mark - UITableView DataSource

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _allLoaclFiles.count;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuse = @"LocalFileCell";
    
    [tableView registerNib:[UINib nibWithNibName:@"LocalFileVCCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuse];
    
    LocalFileVCCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    
    if (cell == nil) {
        cell = [[LocalFileVCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    cell.cellEdge = 10;
    cell.fileName = [_allLoaclFiles objectAtIndex:indexPath.section];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *fileName = [_allLoaclFiles objectAtIndex:indexPath.section];
    NSString* thefileName = [fileName pathExtension];
    
    NSURL *fileURL = [self ConstituteURL:fileName];
    
    
    [self lookupDocument:fileURL andThefileName:thefileName];
    
   
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0f;
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




@end
