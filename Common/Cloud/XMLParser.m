//
//  XMLParser.m
//  MobileOffice
//
//  Created by MacAir2 on 15/5/27.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "XMLParser.h"
#import "AppCore.h"


@implementation XMLParser

//解析XML
static NSString *kStart =			@"//YOUNGCONTENT";
static NSString *KContentID =	    @"CONTENTID";
static NSString *kProperty =       @"YOUNGPROPERTY";
static NSString *KName =			@"NAME";
static NSString *KValue =	        @"VALUE";
static NSString *KDocumentID =	    @"DOCUMENTID";

+ (XMLParser *)sharedInstance{
    static XMLParser *sharedXMLParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedXMLParser = [[self alloc] init];
    });
    return sharedXMLParser;
}

- (void)parsedContentWithXMLString:(NSString *)xmlString{
    self.parserResultArray = [[NSMutableArray alloc] init];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
    
    /////解析
    NSArray *items = [doc nodesForXPath:kStart error:nil];
    
    for (DDXMLElement *obj in items) {
        ContentItems *aContent = [[ContentItems alloc] init];//表里面的一条数据
        aContent.Properties = [[NSMutableDictionary alloc] init];
        
        DDXMLElement *aContentID = [obj elementForName:KContentID];//ContentID
        if(aContentID){
            aContent.ContentID = aContentID.stringValue;
            //NSLog(aContent.ContentID);
        }
        
        ////////////////////表里面的属性名称和值
        //NSArray *properties = [obj nodesForXPath:kPropertyStart error:nil];
        DDXMLElement *Properties = [obj elementForName:@"YOUNGPROPERTIES"];//
        if(Properties){
            NSArray *propertiesArr = [Properties nodesForXPath:kProperty error:nil];
            //NSLog(@"%i",propertiesArr.count);
            
            for (DDXMLElement *aProperty in propertiesArr) {
                static NSString *strName=@"";
                static NSString *strValue=@"";
                
                DDXMLElement *aName = [aProperty elementForName:KName];
                if (aName) {
                    strName = aName.stringValue;
                }
                
                DDXMLElement *aValue = [aProperty elementForName:KValue];
                if (aValue) {
                    strValue = aValue.stringValue;
                    [aContent.Properties setObject:strValue forKey:strName];
                }
                else{
                    strValue = @"";
                    [aContent.Properties setObject:strValue forKey:strName];
                }
                
            }
            
        }
        ////////////////////
        
        /////DocumentID
        DDXMLElement *Documents = [obj elementForName:@"YOUNGDOCUMENTS"];
        if (Documents) {
            NSArray *documentsArr = [Documents nodesForXPath:@"YOUNGDOCUMENT" error:nil];
            
            for (DDXMLElement *aDocument in documentsArr) {
                DDXMLElement *aDocumentID = [aDocument elementForName:KDocumentID];
                if(aDocumentID){
                    aContent.DocumentID = aDocumentID.stringValue;
                    //NSLog(aContent.DocumentID);
                }
                
            }
        }
        /////
        
        [self.parserResultArray addObject:aContent];
        //[self performSelectorInBackground:@selector(parsedXml:) withObject:XmlDictionary];
    }
}

- (BOOL)parsedUserWithXMLString:(NSString *)xmlString
{
    self.parserResultArray = [[NSMutableArray alloc] init];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
    
    /////解析
    NSArray *items = [doc nodesForXPath:@"//YOUNGUSER" error:nil];
    if (items.count == 0) {
        return NO;
    }
    
    for (DDXMLElement *obj in items) {
        UserItems *aUser = [[UserItems alloc] init];//一个用户
        
        DDXMLElement *name = [obj elementForName:@"NAME"];//name
        if(name){
            aUser.userName = name.stringValue;
        }
        else
            aUser.userName = @"";
        
        DDXMLElement *miaoshu = [obj elementForName:@"DESCRIPTION"];//描述
        if(miaoshu){
           //  NSLog(@"%@",miaoshu.stringValue);
            aUser.userDescription = miaoshu.stringValue;
            
        }
        else
            aUser.userDescription = @"";
        
        
        DDXMLElement *group = [obj elementForName:@"ALLGROUPNAMES"];//ALLGROUPNAMES
        if(group){
            aUser.allgroupnames = group.stringValue;
        }
        else
            aUser.allgroupnames = @"";
        
        DDXMLElement *extattr1 = [obj elementForName:@"EXTATTR1"];//EXTATTR1
        if(extattr1){
            aUser.extattr1 = extattr1.stringValue;
        }
        else{
            aUser.extattr1 = @"";
        }
        
        DDXMLElement *extattr2 = [obj elementForName:@"EXTATTR2"];//EXTATTR2
        if(extattr2){
            aUser.extattr2 = extattr2.stringValue;
        }
        else{
            aUser.extattr2 = @"";
        }
        
        
        
        [self.parserResultArray addObject:aUser];
        
    }
    
    return YES;
}


- (BOOL)ifReplaySuccessFromData:(NSData *)data
{
    /////解析
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
    
    
    NSArray *items = [doc nodesForXPath:@"//REPLY" error:nil];
    
    for (DDXMLElement *obj in items) {
        DDXMLElement *element = [obj elementForName:@"SUCCESS"];
        NSLog(@"%@",element);
        if(element){
            if ([element.stringValue isEqualToString:@"1000"]) {
                return YES;
            }
            else{
                return NO;
            }
            
        }
        else{
            return NO;
        }
        
    }
    
    return NO;
    
}

- (NSString *)parsedInsertXMLString:(NSString *)xmlString
{
    /////解析
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
    
    
    NSArray *items = [doc nodesForXPath:@"//YOUNGCONTENT" error:nil];
    
    for (DDXMLElement *obj in items) {
        DDXMLElement *element = [obj elementForName:@"CONTENTID"];
        NSLog(@"%@",element);
        
        if (element) {
            return element.stringValue;
        }
        
    }
    
    return nil;
    
}


@end
