//
//  AKSHTTPSessionModel.m
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import "AKSHTTPSessionModel.h"
#import "AKSNetWorkHelper.h"
#import "AKSNetWorkConfig.h"
#import "AKSHTTPModelManager.h"
#import "AKSNetWorkLogHelper.h"

void AKSLog(NSString *format, ...) {
#ifdef DEBUG
    if (![AKSNetWorkConfig netWorkConfig].dubugLogeEnable) {
        return;
    }
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}

@implementation AKSHTTPSessionModel

@synthesize ne_request,ne_response;

- (void)setNe_request:(NSURLRequest *)ne_request_new {
    
    ne_request = ne_request_new;
    self.requestURLString = [ne_request.URL absoluteString];
    
    switch (ne_request.cachePolicy) {
        case 0:
            self.requestCachePolicy = @"NSURLRequestUseProtocolCachePolicy";
            break;
        case 1:
            self.requestCachePolicy = @"NSURLRequestReloadIgnoringLocalCacheData";
            break;
        case 2:
            self.requestCachePolicy = @"NSURLRequestReturnCacheDataElseLoad";
            break;
        case 3:
            self.requestCachePolicy = @"NSURLRequestReturnCacheDataDontLoad";
            break;
        case 4:
            self.requestCachePolicy = @"NSURLRequestReloadIgnoringLocalAndRemoteCacheData";
            break;
        case 5:
            self.requestCachePolicy = @"NSURLRequestReloadRevalidatingCacheData";
            break;
        default:
            self.requestCachePolicy = @"";
            break;
    }
    
    self.requestTimeoutInterval = [[NSString stringWithFormat:@"%.1lf",ne_request.timeoutInterval] doubleValue];
    self.requestHTTPMethod=ne_request.HTTPMethod;
    
    for (NSString *key in [ne_request.allHTTPHeaderFields allKeys]) {
        self.requestAllHTTPHeaderFields = [NSString stringWithFormat:@"%@%@",self.requestAllHTTPHeaderFields,[self formateRequestHeaderFieldKey:key object:[ne_request.allHTTPHeaderFields objectForKey:key]]];
    }
    
    [self appendCookieStringAfterRequestAllHTTPHeaderFields];
    
    if (self.requestAllHTTPHeaderFields.length > 1) {
        if ([[self.requestAllHTTPHeaderFields substringFromIndex:self.requestAllHTTPHeaderFields.length - 1] isEqualToString:@"\n"]) {
            self.requestAllHTTPHeaderFields = [self.requestAllHTTPHeaderFields substringToIndex:self.requestAllHTTPHeaderFields.length - 1];
        }
    }
    if (self.requestAllHTTPHeaderFields.length > 6) {
        if ([[self.requestAllHTTPHeaderFields substringToIndex:6] isEqualToString:@"(null)"]) {
            self.requestAllHTTPHeaderFields = [self.requestAllHTTPHeaderFields substringFromIndex:6];
        }
    }
    
    if ([ne_request HTTPBody].length > 512) {
        self.requestHTTPBody = @"requestHTTPBody too long";
    }
    else {
        self.requestHTTPBody = [[NSString alloc] initWithData:[ne_request HTTPBody] encoding:NSUTF8StringEncoding];
    }
    if (self.requestHTTPBody.length > 1) {
        if ([[self.requestHTTPBody substringFromIndex:self.requestHTTPBody.length - 1] isEqualToString:@"\n"]) {
            self.requestHTTPBody = [self.requestHTTPBody substringToIndex:self.requestHTTPBody.length - 1];
        }
    }
}

- (void)setNe_response:(NSHTTPURLResponse *)ne_response_new {
    
    ne_response = ne_response_new;
    
    self.responseMIMEType = @"";
    self.responseExpectedContentLength = @"";
    self.responseTextEncodingName = @"";
    self.responseSuggestedFilename = @"";
    self.responseStatusCode = 200;
    self.responseAllHeaderFields = @"";
    
    self.responseMIMEType = [ne_response MIMEType];
    self.responseExpectedContentLength = [NSString stringWithFormat:@"%lld",[ne_response expectedContentLength]];
    self.responseTextEncodingName = [ne_response textEncodingName];
    self.responseSuggestedFilename = [ne_response suggestedFilename];
    self.responseStatusCode = (int)ne_response.statusCode;
    
    for (NSString *key in [ne_response.allHeaderFields allKeys]) {
        NSString *headerFieldValue = [ne_response.allHeaderFields objectForKey:key];
        if ([key isEqualToString:@"Content-Security-Policy"]) {
            if (headerFieldValue.length > 12 && [[headerFieldValue substringFromIndex:12] isEqualToString:@"'none'"]) {
                headerFieldValue = [headerFieldValue substringToIndex:11];
            }
        }
        
        self.responseAllHeaderFields = [NSString stringWithFormat:@"%@%@:%@\n",self.responseAllHeaderFields,key,headerFieldValue];
    }
    
    if (self.responseAllHeaderFields.length > 1) {
        if ([[self.responseAllHeaderFields substringFromIndex:self.responseAllHeaderFields.length-1] isEqualToString:@"\n"]) {
            self.responseAllHeaderFields = [self.responseAllHeaderFields substringToIndex:self.responseAllHeaderFields.length-1];
        }
    }
}

- (void)appendCookieStringAfterRequestAllHTTPHeaderFields {
    
    NSString *host = self.ne_request.URL.host;
    NSArray *cookieArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSMutableArray *cookieValueArray = [NSMutableArray array];
    
    for (NSHTTPCookie *cookie in cookieArray) {
        NSString *domain = [cookie.properties valueForKey:NSHTTPCookieDomain];
        NSRange range = [host rangeOfString:domain];
        NSComparisonResult result = [cookie.expiresDate compare:[NSDate date]];
        if(range.location != NSNotFound && result == NSOrderedDescending) {
            [cookieValueArray addObject:[NSString stringWithFormat:@"%@=%@",cookie.name,cookie.value]];
        }
    }
    if(cookieValueArray.count > 0) {
        NSString *cookieString = [cookieValueArray componentsJoinedByString:@";"];
        self.requestAllHTTPHeaderFields = [self.requestAllHTTPHeaderFields stringByAppendingString:[self formateRequestHeaderFieldKey:@"Cookie" object:cookieString]];
    }
}

- (NSString *)formateRequestHeaderFieldKey:(NSString *)key object:(id)obj {
    
    return [NSString stringWithFormat:@"%@:%@\n",key?:@"",obj?:@""];
}

- (void)startLoadingRequest:(NSURLRequest *)request {
    
    self.ne_request = request;
    self.startDateString = [AKSNetWorkHelper AKS_currentTimeString];
    self.ID = [self requestID];
}

- (void)endLoadingResponse:(NSURLResponse *)response responseObject:(id)responseObject ErrorDescription:(nonnull NSString *)errorDescription {
    
    self.ne_response = (NSHTTPURLResponse *)response;
    self.endDateString = [AKSNetWorkHelper AKS_currentTimeString];
    self.errorDescription = errorDescription;
    
    NSData *data = nil;
    if (responseObject) {
        data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
    }
    
    NSString *mimeType = response.MIMEType;
    if ([mimeType isEqualToString:@"application/json"]) {
        self.receiveJSONData = [self responseJSONFromData:data];
    }
    else if ([mimeType isEqualToString:@"text/javascript"]) {
        
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if ([jsonString hasSuffix:@")"]) {
            jsonString = [NSString stringWithFormat:@"%@;", jsonString];
        }
        if ([jsonString hasSuffix:@");"]) {
            NSRange range = [jsonString rangeOfString:@"("];
            if (range.location != NSNotFound) {
                range.location ++;
                range.length = [jsonString length] - range.location - 2;/** 删除括号和分号 */
                jsonString = [jsonString substringWithRange:range];
                NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                self.receiveJSONData = [self responseJSONFromData:jsonData];
            }
        }
    }
    else if ([mimeType isEqualToString:@"application/xml"] || [mimeType isEqualToString:@"text/xml"]) {
        
        NSString *xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (xmlString && xmlString.length > 0) {
            self.receiveJSONData = xmlString;
        }
    }
    
#if DEBUG
    
    if ([AKSNetWorkConfig netWorkConfig].SQLLogEnable) {
        [[AKSHTTPModelManager defaultManager] addModel:self];
    } else {
        AKSLog(@"未开启SQLLogEnable日志");
    }
    
#endif
    
    AKSNetWorkLogHelper *log = [[AKSNetWorkLogHelper alloc] initWithSessionModel:self];;
    NSString *logString = [log printRequestLog];
    AKSLog(@"%@",logString);
    
    double flowCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"flowCount"] doubleValue];
    if (!flowCount) {
        flowCount = 0.0;
    }
    
    flowCount = flowCount + self.ne_response.expectedContentLength / (1024.0 * 1024.0);
    [[NSUserDefaults standardUserDefaults] setDouble:flowCount forKey:@"flowCount"];
}



- (id)responseJsonStringFromResponseObject:(id )responseObject {
    
    if (!responseObject || responseObject == [NSNull null]) {
        return nil;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}


- (id)responseJSONFromData:(NSData *)data {
    
    if (data == nil) {
        return nil;
    }
    
    NSError *error = nil;
    id returnValue = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if(error) {
        NSLog(@"JSON Parsing Error: %@", error);
        return nil;
    }
    if (!returnValue || returnValue == [NSNull null]) {
        return nil;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:returnValue options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}


- (double)requestID {
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    double random = arc4random_uniform(10000);
    
    return time + random;
}


@end
