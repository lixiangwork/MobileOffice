//
//  ContentItems.m
//  MobileOffice
//
//  Created by MacAir2 on 15/5/27.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "ContentItems.h"

@implementation ContentItems

-(id) copyWithZone:(NSZone *)zone
{
    ContentItems* item = [[[self class] allocWithZone:zone] init];
    item.MimeType = [self.MimeType copyWithZone:zone];
    item.ContentID= [self.ContentID copyWithZone:zone];
    item.DocumentID = [self.DocumentID copyWithZone:zone];
    item.CommentID = [self.CommentID copyWithZone:zone];
    item.Properties= [self.Properties copyWithZone:zone];
    
    item.LastChangedTime = [self.LastChangedTime copyWithZone:zone];
    item.IsLocalFile = self.IsLocalFile;
    
    return item;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    //encode properties/values
    [aCoder encodeObject:_MimeType    forKey:@"MimeType"];
    [aCoder encodeObject:_ContentID     forKey:@"ContentID"];
    [aCoder encodeObject:_DocumentID     forKey:@"DocumentID"];
    [aCoder encodeObject:_CommentID     forKey:@"CommentID"];
    [aCoder encodeObject:_Properties     forKey:@"Properties"];
    
    [aCoder encodeObject:_LastChangedTime     forKey:@"LastChangedTime"];
    [aCoder encodeBool:_IsLocalFile     forKey:@"IsLocalFile"];
    
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super init])) {
        //decode properties/values
        _MimeType = [aDecoder decodeObjectForKey:@"MimeType"];
        _ContentID = [aDecoder decodeObjectForKey:@"ContentID"];
        _DocumentID = [aDecoder decodeObjectForKey:@"DocumentID"];
        _CommentID = [aDecoder decodeObjectForKey:@"CommentID"];
        _Properties = [aDecoder decodeObjectForKey:@"Properties"];
        
        _LastChangedTime = [aDecoder decodeObjectForKey:@"LastChangedTime"];
        _IsLocalFile = [aDecoder decodeBoolForKey:@"IsLocalFile"];
        
    }
    
    return self;
}



@end
