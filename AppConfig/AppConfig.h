//
//  AppConfig.h
//
//  Created by lixiang on 15-5-15.
//  Copyright 2015年 lixiang. All rights reserved.
//



#define kAPPID                  @"123456789"
#define kAPPName                [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define kAPPCommentUrl          @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d"
#define kAPPUpdateUrl           @"http://itunes.apple.com/lookup?id=%d"


///----------屏幕尺寸----------
#define kScreenWidth          ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight         ([UIScreen mainScreen].bounds.size.height)

///云平台WebService
#define CLOUDURL @"http://211.152.38.164:9080/IDOC/WebService"
#define IMAGEURL @"http://211.152.38.164:9080/IDOC/service/file"

///全局用户key
#define UserGlobalKey       @"UserGlobalKey"
#define uUserName           @"uUserName"
#define uPassword           @"uPassword"
#define uNickName           @"uNickName"
#define uRemenberPassword   @"uRemenberPassword"
#define uAotoLogin          @"uAotoLogin"

//本地文件
#define LocalFileGlobalKey  @"LocalFileGlobalKey"

#define DOCUMENT_FOLDER_DIR [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


//用户头像名称
#define UserIconImageName @"UserIconImageName.jpeg"















