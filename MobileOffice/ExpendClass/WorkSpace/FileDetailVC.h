//
//  FileDetailVC.h
//  MobileOffice
//
//  Created by MacAir2 on 15/6/18.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "BaseVC.h"
#import "ContentItems.h"

@protocol FileDetailVCDelegate <NSObject>

- (void)alterCommentSuccess;

@end

@interface FileDetailVC : BaseVC

@property (assign, nonatomic) id<FileDetailVCDelegate>delegate;

@property (strong, nonatomic) ContentItems *contentItem;

@end
