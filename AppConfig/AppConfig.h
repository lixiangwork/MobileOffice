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


//通知
#define NoticeUploadFileSuccess @"NoticeUploadFileSuccess"




//////////////////////////////////////////////////////////////////////////////////
//IM

// 是否为本地地址测试
#define LOCAL_TEST 0

#if LOCAL_TEST
#define XMPP_DOMAIN         @"127.0.0.1"
#define XMPP_HOST_NAME      @"127.0.0.1"
#else
#define XMPP_DOMAIN         @"211.152.38.164"
#define XMPP_HOST_NAME      @"211.152.38.164"
#endif//LOCAL_TEST

// XMPP
#define XMPP_RESOURCE       @"iPhoneXMPP"
#define XMPP_DEFAULT_GROUP_NAME @"friends"

#define XMPP_USER_ID        @"XMPP_USER_ID"
#define XMPP_PASSWORD       @"XMPP_PASSWORD"

#define DEFAULT_MESSAGE_MAX_COUNT 100
#define DEFAULT_ROSTER_MAX_COUNT 100

//#define IM_MOC [IMDataBaseManager sharedManager].managedObjectContext
#define MY_JID [IMXMPPManager sharedManager].myJID


//////////////////////////////////////////////////////////////////////////////////
// APP 主色调
#define APP_MAIN_COLOR RGBCOLOR(33.f, 40.f, 42.f)

// 搜索框激活时背景色
#define SEARCH_ACTIVE_BG_COLOR RGBCOLOR(201, 201, 206)
#define TABLEVIEW_GROUP_BG_COLOR RGBCOLOR(240, 239, 246)

// Cell布局
#define CELL_PADDING_10 10
#define CELL_PADDING_8 8
#define CELL_PADDING_6 6
#define CELL_PADDING_4 4
#define CELL_PADDING_2 2

// Screen Size
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

// Line Color
#define LINE_COLOR RGBCOLOR(240, 240, 240)

// 消息页面Cell固定高度
#define MESSAGE_MAIN_ROW_HEIGHT 68.f

// 通讯录页面Cell固定高度
#define ADDRESS_BOOK_ROW_HEIGHT 55.f

// group头部高度
#define GROUP_SECTION_HEADER_HEIGHT 20.f






