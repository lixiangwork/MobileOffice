//
//  CloudOperation.m
//  MobileOffice
//
//  Created by MacAir2 on 15/5/25.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "CloudOperation.h"
#import "PropertyItem.h"

@implementation CloudOperation

+ (AFHTTPRequestOperation *)testUser:(NSString *)username andPassWord:(NSString *)password{
    
    NSURL* WebURL = [NSURL URLWithString:CLOUDURL];
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc] init];
    [req setURL:WebURL];
    [req setHTTPMethod:@"POST"];
    [req addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    NSMutableData* postbody = [[NSMutableData alloc] init];
    [postbody appendData:[[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Envelope  xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\"><Body><REQUEST><AUTHENTICATION><SERVERDEF><SERVERNAME>server</SERVERNAME></SERVERDEF><LOGONDATA><USERNAME>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[username dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"</USERNAME><PASSWORD>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[password dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"</PASSWORD></LOGONDATA></AUTHENTICATION><COMMAND>LOGON</COMMAND></REQUEST></Body></Envelope>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [req setHTTPBody:postbody];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    return operation;
}

+(AFHTTPRequestOperation *)getAllContentTypeInfo:(NSString *)contentType userName:(NSString *)uname password:(NSString *)password{
    
    NSURL* WebURL = [NSURL URLWithString:CLOUDURL];
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc] init];
    [req setURL:WebURL];
    [req setHTTPMethod:@"POST"];
    [req addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    NSMutableData* postbody = [[NSMutableData alloc] init];
    [postbody appendData:[[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Envelope  xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\"><Body><REQUEST><AUTHENTICATION><SERVERDEF><SERVERNAME>server</SERVERNAME></SERVERDEF><LOGONDATA><USERNAME>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[uname dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"</USERNAME><PASSWORD>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[password dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[[NSString stringWithFormat:@"</PASSWORD></LOGONDATA></AUTHENTICATION><COMMAND>SEARCHYOUNGCONTENT</COMMAND><DATA><CONTENTTYPENAME>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[contentType dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"</CONTENTTYPENAME><RETENTIONDOC>TRUE</RETENTIONDOC><CHECKDOCONLY>FALSE</CHECKDOCONLY><SIMPLESEARCH>FALSE</SIMPLESEARCH></DATA></REQUEST></Body></Envelope>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [req setHTTPBody:postbody];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    return operation;
}

+(AFHTTPRequestOperation *) insertContent:(NSString*)uname password:(NSString*)password andPropertyList:(NSArray*)propertyList andFolder:(NSString*)Folder andContentType:(NSString*)contentType andSourceFileName:(NSString*)fileName andFileType:(NSString*) fileType andInputstream:(NSData*)inputStream{
    
    NSURL* WebURL = [NSURL URLWithString:CLOUDURL];
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc] init];
    [req setURL:WebURL];
    [req setHTTPMethod:@"POST"];
    [req addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    NSMutableData* postbody = [[NSMutableData alloc] init];
    [postbody appendData:[[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Envelope  xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\"><Body><REQUEST><AUTHENTICATION><SERVERDEF><SERVERNAME>server</SERVERNAME></SERVERDEF><LOGONDATA><USERNAME>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[uname dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"</USERNAME><PASSWORD>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[password dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"</PASSWORD></LOGONDATA></AUTHENTICATION><COMMAND>IMPORTYOUNGCONTENT</COMMAND><DATA><CONTENTTYPENAME>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[contentType dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"</CONTENTTYPENAME><FOLDER>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[Folder dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"</FOLDER><YOUNGPROPERTIES>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (int i = 0 ; i < [propertyList count] ; i++) {
        PropertyItem* item = (PropertyItem*)[propertyList objectAtIndex:i];
        [postbody appendData:[[NSString stringWithFormat:@"<YOUNGPROPERTY><NAME>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[item.name dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"</NAME><TYPE>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[item.type dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"</TYPE><VALUE>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[item.value dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"</VALUE></YOUNGPROPERTY>"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [postbody appendData:[[NSString stringWithFormat:@"</YOUNGPROPERTIES><YOUNGDOCUMENTS>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[[NSString stringWithFormat:@"<YOUNGDOCUMENT><SIZE>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSUInteger length = [inputStream length];
    NSString* strlength = [NSString stringWithFormat:@"%lu",(unsigned long)length];
    [postbody appendData:[strlength dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[[NSString stringWithFormat:@"</SIZE><SOURCEFILENAME>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[fileName dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[[NSString stringWithFormat:@"</SOURCEFILENAME><MIMETYPE>"] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString* mimetype;
    if ([fileName rangeOfString:@"png" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        mimetype = @"image/png";
    }
    
    else if ([fileName rangeOfString:@"pdf" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        mimetype = @"application/pdf";
    }
    [postbody appendData:[mimetype dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"</MIMETYPE><DOCUMENTTYPENAME>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[fileType dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[[NSString stringWithFormat:@"</DOCUMENTTYPENAME><INPUTSTREAM>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:inputStream];
    [postbody appendData:[[NSString stringWithFormat:@"</INPUTSTREAM></YOUNGDOCUMENT></YOUNGDOCUMENTS></DATA></REQUEST></Body></Envelope>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [req setHTTPBody:postbody];
    // NSLog([[NSString alloc] initWithData:req.HTTPBody encoding:NSUTF8StringEncoding]);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    return  operation;

}

////////////////////sql
+ (AFHTTPRequestOperation *)sqlSearch:(NSString *)contentType andCondition:(NSString *)condition {
    NSURL* WebURL = [NSURL URLWithString:CLOUDURL];
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc] init];
    [req setURL:WebURL];
    [req setHTTPMethod:@"POST"];
    [req addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    NSMutableData* postbody = [[NSMutableData alloc] init];
    [postbody appendData:[[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Envelope  xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\"><Body><REQUEST><AUTHENTICATION><SERVERDEF><SERVERNAME>server</SERVERNAME></SERVERDEF><LOGONDATA><USERNAME>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"docadmin" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"</USERNAME><PASSWORD>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"passw0rd" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[[NSString stringWithFormat:@"</PASSWORD></LOGONDATA></AUTHENTICATION><COMMAND>SEARCHYOUNGCONTENT</COMMAND><DATA><CONTENTTYPENAME>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[contentType dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"</CONTENTTYPENAME><QUERY>from (select * from "] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[contentType dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@" where "] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[condition dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[[NSString stringWithFormat:@")"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[contentType dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[[NSString stringWithFormat:@"</QUERY><RETENTIONDOC>TRUE</RETENTIONDOC><CHECKDOCONLY>FALSE</CHECKDOCONLY><SIMPLESEARCH>false</SIMPLESEARCH><NOCHECKEDOUTSTATU>true</NOCHECKEDOUTSTATU></DATA></REQUEST></Body></Envelope>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [req setHTTPBody:postbody];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    return operation;
}

+ (AFHTTPRequestOperation *) SQLSearch2: (NSString*)contentType andCondition: (NSString*) condition andSize:(NSString *)size andOrderby:(NSString *)orderby andColumnlist:(NSString *)columnlist
{
    
    NSURL* WebURL = [NSURL URLWithString:CLOUDURL];
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc] init];
    [req setURL:WebURL];
    [req setHTTPMethod:@"POST"];
    [req addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    NSMutableData* postbody = [[NSMutableData alloc] init];
    [postbody appendData:[[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Envelope  xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\"><Body><REQUEST><AUTHENTICATION><SERVERDEF><SERVERNAME>server</SERVERNAME></SERVERDEF><LOGONDATA><USERNAME>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"docadmin" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"</USERNAME><PASSWORD>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"passw0rd" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[[NSString stringWithFormat:@"</PASSWORD></LOGONDATA></AUTHENTICATION><COMMAND>SEARCHYOUNGCONTENT</COMMAND><DATA><SIMPLESEARCH>false</SIMPLESEARCH><CONTENTTYPENAME>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[contentType dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"</CONTENTTYPENAME><QUERY>from(select * from "] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[contentType dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@" where "] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[condition dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[[NSString stringWithFormat:@")"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[contentType dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[[NSString stringWithFormat:@"</QUERY><SIZE>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[size dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[[NSString stringWithFormat:@"</SIZE><ORDERBY>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[orderby dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[[NSString stringWithFormat:@"</ORDERBY><COLUMNLIST>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[columnlist dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"</COLUMNLIST><RETENTIONDOC>TRUE</RETENTIONDOC><CHECKDOCONLY>TRUE</CHECKDOCONLY><NOCHECKEDOUTSTATU>true</NOCHECKEDOUTSTATU><NOTINCLUDEDOCINFO>false</NOTINCLUDEDOCINFO></DATA></REQUEST></Body></Envelope>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [req setHTTPBody:postbody];
    
    
    // NSString* content = [[NSString alloc] initWithData:postbody encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",content);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    return operation;
    
}


@end
