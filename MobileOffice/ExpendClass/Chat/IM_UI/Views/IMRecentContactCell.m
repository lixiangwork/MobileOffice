//
//  IMRecentContactCell.m
//  JLWeChat
//
//  Created by jimneylee on 14-5-22.
//  Copyright (c) 2014年 jimneylee. All rights reserved.
//

#import "IMRecentContactCell.h"
#import "JSCustomBadge.h"
#import "XMPPMessageArchiving_Contact_CoreDataObject.h"
#import "XMPPMessageArchiving_Contact_CoreDataObject+RecentContact.h"
#import "NSDate+IM.h"
#import "IMXMPPManager.h"
#import "IMChatMessageEntityFactory.h"
#import "UIImageView+AFNetworking.h"

#import "UIViewAdditions.h"

#define NAME_FONT_SIZE [UIFont boldSystemFontOfSize:18.f]
#define MESSAGE_FONT_SIZE [UIFont systemFontOfSize:15.f]
#define DATE_FONT_SIZE [UIFont systemFontOfSize:14.f]

#define HEAD_IAMGE_HEIGHT 48

@interface IMRecentContactCell()

@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) JSCustomBadge *badgeView;

@property (nonatomic, strong) XMPPMessageArchiving_Contact_CoreDataObject* contact;

@end

@implementation IMRecentContactCell

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // head
        self.headView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, HEAD_IAMGE_HEIGHT, HEAD_IAMGE_HEIGHT)];
        self.headView.image = [UIImage imageNamed:@"head_s.png"];
        [self.contentView addSubview:self.headView];
        self.headView.layer.cornerRadius = 4.f;
        self.headView.clipsToBounds = YES;// must be set for cornerRadius
        
        // badge
        self.badgeView = [JSCustomBadge customBadgeWithString:nil
                                              withStringColor:[UIColor whiteColor]
                                               withInsetColor:[UIColor redColor]
                                               withBadgeFrame:YES
                                          withBadgeFrameColor:[UIColor redColor]
                                                    withScale:.8f
                                                  withShining:NO];
        [self.contentView addSubview:self.badgeView];
    
        // name
        self.textLabel.font = NAME_FONT_SIZE;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        
        // message
        self.detailTextLabel.font = MESSAGE_FONT_SIZE;
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.highlightedTextColor = self.detailTextLabel.textColor;
        
        // date
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.dateLabel.font = DATE_FONT_SIZE;
        self.dateLabel.textColor = [UIColor grayColor];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.highlightedTextColor = self.dateLabel.textColor;
        [self.contentView addSubview:self.dateLabel];
        
        // background color
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.badgeView.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.headView.image = [UIImage imageNamed:@"head_s.png"];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat cellMarin = CELL_PADDING_10;
    CGFloat padding = CELL_PADDING_10;
    
    self.headView.left = cellMarin;
    self.headView.top = cellMarin;
    
    [self.badgeView sizeToFit];
    self.badgeView.centerX = self.headView.right;
    self.badgeView.top = 0.f;

    CGFloat textMaxWidth = self.contentView.width - self.headView.width - cellMarin * 2 - padding;
    CGFloat nameWidth = (textMaxWidth * 2 ) / 3;
    CGFloat dateWidth = textMaxWidth / 3;
    
    // name
    self.textLabel.frame = CGRectMake(self.headView.right + padding, self.headView.top,
                                      nameWidth, self.textLabel.font.lineHeight);
    
    // date
    self.dateLabel.frame = CGRectMake(self.textLabel.right, self.textLabel.top,
                                      dateWidth, self.dateLabel.font.lineHeight);

    // message
    self.detailTextLabel.frame = CGRectMake(self.textLabel.left, self.textLabel.bottom + padding,
                                            textMaxWidth, self.detailTextLabel.font.lineHeight);
    
    // head data
#if 0
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSData *photoData = [[[IMXMPPManager sharedManager] xmppvCardAvatarModule]
                             photoDataForJID:self.contact.bareJid];
        if (photoData != nil)
            self.headView.image = [UIImage imageWithData:photoData];
        else
            self.headView.image = [UIImage imageNamed:@"head_s.png"];
    });
#endif
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldUpdateCellWithObject:(id)object
{
    if ([object isKindOfClass:[XMPPMessageArchiving_Contact_CoreDataObject class]]) {
        
        XMPPMessageArchiving_Contact_CoreDataObject* o = (XMPPMessageArchiving_Contact_CoreDataObject*)object;
        self.contact = o;
        self.textLabel.text = o.displayName;
        self.detailTextLabel.text = [IMChatMessageEntityFactory recentContactLastMessageFromJSONString:o.mostRecentMessageBody];
        self.dateLabel.text = [o.mostRecentMessageTimestamp formatRecentContactDate];
//        [self.headView setImageWithURL:[NSURL URLWithString:HEAD_IMAGE(o.bareJid.user)]
//                      placeholderImage:[UIImage imageNamed:@"head_s.png"]];
        
        if (self.contact.unreadMessages.intValue > 0) {
            self.badgeView.hidden = NO;
            [self.badgeView autoBadgeSizeWithString:self.contact.unreadMessages.stringValue];
        }
        else {
            self.badgeView.hidden = YES;
        }
    }
    return YES;
}

@end
