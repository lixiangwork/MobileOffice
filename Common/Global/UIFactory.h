//
//  UIFactory.h
//  MobileOffice
//
//  Created by MacAir2 on 15/5/15.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFactory : NSObject

+ (UIFactory*)sharedUIFactory;

/**--------------------------------
 * set UILabel
 *
 * label :UILabel
 * frame :CGRect
 * font  :UIFont
 * title :
 *
 */
+ (void)setLable:(UILabel *)label
           frame:(CGRect)frame
            font:(UIFont *)font
           title:(NSString *)title;


/**--------------------------------
 * Create UILabel
 *
 * frame :CGRect
 * label :NSString
 *
 */
+ (id)createLabelWith:(CGRect)frame
                 text:(NSString *)text;


/**--------------------------------
 * Create UILabel
 *
 * frame            :CGRect
 * label            :NSString
 * backgroundColor  :UIColor
 *
 */
+ (id)createLabelWith:(CGRect)frame
                 text:(NSString *)text
      backgroundColor:(UIColor *)backgroundColor;

/**--------------------------------
 * Create UILabel
 *
 * frame            :CGRect
 * label            :NSString
 * font             :UIFont
 * textColor        :UIColor
 * backgroundColor  :UIColor
 *
 */
+ (id)createLabelWith:(CGRect)frame
                 text:(NSString *)text
                 font:(UIFont *)font
            textColor:(UIColor *)textColor
      backgroundColor:(UIColor *)backgroundColor;

/**--------------------------------
 * Create UITextField
 *
 * frame            :CGRect
 * delegate         :id<UITextFieldDelegate>
 * returnKeyType    :UIReturnKeyType
 * secureTextEntry  :BOOL
 * placeholder      :NSString
 * font             :UIFont
 *
 */
+ (id)createTextFieldWith:(CGRect)frame
                 delegate:(id<UITextFieldDelegate>)delegate
            returnKeyType:(UIReturnKeyType)returnKeyType
          secureTextEntry:(BOOL)secureTextEntry
              placeholder:(NSString *)placeholder
                     font:(UIFont *)font;



//TextField
+ (id)createTextFieldWithRect:(CGRect)frame
                 keyboardType:(UIKeyboardType)keyboardType
                       secure:(BOOL)secure
                  placeholder:(NSString *)placeholder
                         font:(UIFont *)font
                        color:(UIColor *)color
                     delegate:(id)delegate;

//Image拉伸
+ (UIImage*)resizableImageWithSize:(CGSize)size
                             image:(NSString*)image;


//Button(只有背景图)
+ (UIButton *)createButtonWithRect:(CGRect)frame
                            normal:(NSString *)normalImage
                         highlight:(NSString *)clickIamge
                          selector:(SEL)selector
                            target:(id)target;

//设置Button(frame + 图标 + 图标的边距 + 响应方法)
+ (void)setButton:(UIButton *)button
         WithRect:(CGRect)frame
      normalImage:(NSString *)normalImage
   highlightImage:(NSString *)highlightImage
  imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
         selector:(SEL)selector
           target:(id)target;




//设置Button(frame + 背景 + 响应方法)
+ (void)setButton:(UIButton *)button
         WithRect:(CGRect)frame
backgroundImageNormal:(NSString *)backgroundImageNormal
backgroundImageHighLight:(NSString *)backgroundImageHighLight
         selector:(SEL)selector
           target:(id)target;


//Button(标题+背景图)
+ (UIButton *)createButtonWithRect:(CGRect)frame
                             title:(NSString *)title
                         titleFont:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                            normal:(NSString *)normalImage
                         highlight:(NSString *)highLightIamge
                          selected:(NSString *)clickIamge
                          selector:(SEL)selector
                            target:(id)target;


+ (UIButton *)createButtonWithRect:(CGRect)frame
                             title:(NSString *)title
                         titleFont:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                            normal:(NSString *)normalImage
                         highlight:(NSString *)clickIamge
                             fixed:(CGSize)fixedSize
                          selector:(SEL)selector
                            target:(id)target;


//Button(标题+图标+背景)
+ (UIButton *)createButtonWithRect:(CGRect)frame
                             title:(NSString *)title
                         titleFont:(UIFont  *)font
                  titleColorNormal:(UIColor *)titleColorNormal
               titleColorHighLight:(UIColor *)titleColorHighLight
                       normalImage:(NSString *)normalImage
                    highlightImage:(NSString *)highlightImage
             backgroundImageNormal:(NSString *)backgroundImageNormal
          backgroundImageHighLight:(NSString *)backgroundImageHighLight
                          selector:(SEL)selector
                            target:(id)target;





//+ (NSString *)localized:(NSString *)key;

//Alert提示
+ (void)showAlert:(NSString *)message;
+ (void)showAlert:(NSString *)message tag:(NSUInteger)tag delegate:(id)delegate;
+ (void)showConfirm:(NSString *)message tag:(NSUInteger)tag delegate:(id)delegate;

//校验IP/PORT
//+ (BOOL)isValidIPAddress:(NSString *)address;
//+ (BOOL)isValidPortAddress:(NSString *)address;

//获得系统版本
+ (float)getSystemVersion;

//获取APNS设备令牌
//+(NSString *)getDeviceTokenFromData:(NSData *)deviceToken;

//显示AppStore应用评论
//+(void)showAppCommentWithAppID:(int)appID;

//拨打电话
+ (void)call:(NSString *)telephoneNum;

//发送短信
+ (void)sendSMS:(NSString *)telephoneNum;

//发送邮件
+ (void)sendEmail:(NSString *)emailAddr;

//打开网页
+ (void)openUrl:(NSString *)url;

//获得中文gbk编码
+(NSStringEncoding)getGBKEncoding;


//- (BOOL) IsEnable3G;
//- (BOOL) IsEnableWIFI;


@end
