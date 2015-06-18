//
//  CommentItems.m
//  MobileOffice
//
//  Created by MacAir2 on 15/6/17.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "CommentItems.h"

@implementation CommentItems

+ (NSMutableArray*) handleComment:(NSString*) WholeString
{
    NSMutableArray* allComments = [[NSMutableArray alloc] init];
    NSArray* allCommentsArr = [WholeString componentsSeparatedByString:@"\n"];
    NSLog(@"%@", allCommentsArr);
    for (int i = 0 ; i < [allCommentsArr count]; i++) {
        
        NSString *oneCommentStr = [allCommentsArr objectAtIndex:i];
        
        NSArray *oneCommentArr = [oneCommentStr componentsSeparatedByString:@"_"];
        
        CommentItems* item = [[CommentItems alloc] init];
        if (oneCommentArr.count < 3) {
            continue;
        }
        item.commentor = [oneCommentArr objectAtIndex:0];
        item.date = [oneCommentArr objectAtIndex:1];
        item.content = [oneCommentArr objectAtIndex:2];
        
        [allComments addObject:item];
        
        
    }
    NSLog(@"allComments:%lu", (unsigned long)[allComments count]);
    return allComments;
}


@end
