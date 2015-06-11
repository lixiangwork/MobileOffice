//
//  AppMacros.h
//
//  Created by lixiang on 15-5-10.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//



//----------设备系统相关---------
#define isRetina    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIP5       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)
#define isPad       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isIPhone    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define kSystemVersion   ([[UIDevice currentDevice] systemVersion])
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define kAPPVersion      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define kFirstLaunch     mAPPVersion     //以系统版本来判断是否是第一次启动，包括升级后启动。
#define kFirstRun        @"firstRun"     //判断是否为第一次运行，升级后启动不算是第一次运行


//selfLog
#define LOG_SELF_METHOD  NSLog(@"<%@> Called:'%@'",self,NSStringFromSelector(_cmd));


//应用委托
#ifdef APP_PLATFORM_IPHONE
#define kAppDelegate ((AppDelegate_iphone *)[UIApplication sharedApplication].delegate)
#elif APP_PLATFORM_IPAD
#define kAppDelegate ((AppDelegate_ipad *)[UIApplication sharedApplication].delegate)
#endif


//Window UserDefaults NotificationCenter
#define kWindow             [[[UIApplication sharedApplication] windows] lastObject]
#define kKeyWindow          [[UIApplication sharedApplication] keyWindow]
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

//以tag读取View
#define kViewByTag(parentView, tag, Class)  (Class *)[parentView viewWithTag:tag]

//读取Xib文件的类
#define kViewByNib(Class, owner, index) [[[NSBundle mainBundle] loadNibNamed:Class owner:owner options:nil] objectAtIndex:index]


//id对象与NSData之间转换
#define kObjectToData(object)   [NSKeyedArchiver archivedDataWithRootObject:object]
#define kDataToObject(data)     [NSKeyedUnarchiver unarchiveObjectWithData:data]

//度弧度转换
#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)
#define kRadianToDegrees(radian) (radian*180.0) / (M_PI)

//GCD
#define kGCDBackground(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define kGCDMain(block)       dispatch_async(dispatch_get_main_queue(),block)


//计时器
#define MM_INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }

//颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//16进制RGB颜色转换
#define RGBTOCOLOR(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]

//单例
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
        + (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
        + (__class *)sharedInstance \
        { \
            static dispatch_once_t once; \
            static __class * __singleton__; \
            dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
            return __singleton__; \
        }



/**************************************以下宏定义用于非ARC模式**********************************************************************/

//安全释放
#define MM_RELEASE_SAFELY(__POINTER) {  [__POINTER release]; __POINTER = nil; }

//静态只读NSString属性声明和定义
#undef	AS_STATIC_PROPERTY
#define AS_STATIC_PROPERTY( __name ) \
@property (nonatomic, readonly) NSString * __name; \
+ (NSString *)__name;

#undef	DEF_STATIC_PROPERTY
#define DEF_STATIC_PROPERTY( __name ) \
@dynamic __name; \
+ (NSString *)__name \
{ \
static NSString * __local = nil; \
if ( nil == __local ) \
{ \
__local = [[NSString stringWithFormat:@"%s", #__name] retain]; \
} \
return __local; \
}


//静态NSString属性声明和定义(带一个前缀)
#undef	DEF_STATIC_PROPERTY2
#define DEF_STATIC_PROPERTY2( __name, __prefix ) \
@dynamic __name; \
+ (NSString *)__name \
{ \
static NSString * __local = nil; \
if ( nil == __local ) \
{ \
__local = [[NSString stringWithFormat:@"%@.%s", __prefix, #__name] retain]; \
} \
return __local; \
}


//静态NSString属性声明和定义(带两个前缀)
#undef	DEF_STATIC_PROPERTY3
#define DEF_STATIC_PROPERTY3( __name, __prefix, __prefix2 ) \
@dynamic __name; \
+ (NSString *)__name \
{ \
static NSString * __local = nil; \
if ( nil == __local ) \
{ \
__local = [[NSString stringWithFormat:@"%@.%@.%s", __prefix, __prefix2, #__name] retain]; \
} \
return __local; \
}


//静态只读NSInteger属性声明和定义
#undef	AS_STATIC_PROPERTY_INT
#define AS_STATIC_PROPERTY_INT( __name ) \
@property (nonatomic, readonly) NSInteger __name; \
+ (NSInteger)__name;

#undef	DEF_STATIC_PROPERTY_INT
#define DEF_STATIC_PROPERTY_INT( __name, __value ) \
@dynamic __name; \
+ (NSInteger)__name \
{ \
return __value; \
}


//只读NSString属性声明和定义
#undef	AS_STATIC_PROPERTY_STRING
#define AS_STATIC_PROPERTY_STRING( __name ) \
@property (nonatomic, readonly) NSString * __name; \
+ (NSString *)__name;

#undef	DEF_STATIC_PROPERTY_STRING
#define DEF_STATIC_PROPERTY_STRING( __name, __value ) \
@dynamic __name; \
+ (NSString *)__name \
{ \
return __value; \
}



#undef	AS_INT
#define AS_INT	AS_STATIC_PROPERTY_INT

#undef	DEF_INT
#define DEF_INT	DEF_STATIC_PROPERTY_INT

#undef	AS_STRING
#define AS_STRING	AS_STATIC_PROPERTY_STRING

#undef	DEF_STRING
#define DEF_STRING	DEF_STATIC_PROPERTY_STRING




