//
//  HDWebAppShortcut.m
//  Pods-Example
//
//  Created by woody on 2019/5/27.
//

#import "HDWebAppShortcut.h"
#import <CocoaHTTPServer/HTTPServer.h>

static NSString *HDAppTitle = @"HDAppTitle";
static NSString *HDIconImageData = @"HDIconImageData";
static NSString *HDLaunchImageData = @"HDLaunchImageData";
static NSString *HDAppScheme = @"HDAppScheme";
static NSString *HDDataURISchemeContent = @"HDDataURISchemeContent";
static NSString *HDWebPath = @"HDWebPath";

@interface HDWebAppShortcut ()
@property (nonatomic, strong) HTTPServer *mHttpServer;
@end

@implementation HDWebAppShortcut

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static HDWebAppShortcut *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[HDWebAppShortcut alloc]init];
    });
    return _instance;
}

+ (void)createShortcut:(UIImage *)iconImg
           launchImage:(UIImage *)launchImg
              appTitle:(NSString *)title
             urlScheme:(NSString *)url
            sourceHtml:(NSString *)htmlStr{
    HDWebAppShortcut *instance = [HDWebAppShortcut sharedInstance];
    NSString *iconStr = [instance dataURIScheme:iconImg];
    NSString *launchStr = [instance dataURIScheme:launchImg];
    NSString *contentHTML = [instance replaceContentHtml:htmlStr iconStr:iconStr launchStr:launchStr title:title urlScheme:url];
    NSData *contentData = [contentHTML dataUsingEncoding:NSUTF8StringEncoding];
    contentHTML = [contentData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *dataURIString = [NSString stringWithFormat:@"0;data:text/html;charset=utf-8;base64,%@",contentHTML];
    NSString *indexHtmlString = [instance replaceIndexHtmlWithBase64ContentString:dataURIString];
    if ([instance writeHTMLToDocument:indexHtmlString]) {
        [instance startServer];
    }
}

#pragma mark - Getter

- (HTTPServer *)mHttpServer{
    if (_mHttpServer == nil) {
        _mHttpServer = [[HTTPServer alloc] init];
        [_mHttpServer setType:@"_http._tcp."];
        NSString *serverWebPath = [self getServerWebPath];
        [_mHttpServer setDocumentRoot:serverWebPath];
    }
    return _mHttpServer;
}

#pragma mark - Helper

- (void)startServer{
    NSError *error;
    if([self.mHttpServer start:&error]){
        NSLog(@"Started HTTP Server on port %hu", [self.mHttpServer listeningPort]);
        /*服务启动成功后，访问网址*/
        NSString *localAddress = [NSString stringWithFormat:@"http://127.0.0.1:%hu",[self.mHttpServer listeningPort]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:localAddress]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.mHttpServer stop];
        });
    }else{
        NSLog(@"Error starting HTTP Server: %@", error);
    }
}

- (NSString *)replaceContentHtml:(NSString *)sourceHtml iconStr:(NSString *)iconDataUri launchStr:(NSString *)launchDataUri title:(NSString *)title urlScheme:(NSString *)url{
    NSMutableString *contentString = [NSMutableString stringWithString:sourceHtml];
    NSRange range = [contentString rangeOfString:@"<html>"];
    NSString *head=  @"\n<head>\n\t<meta name=\"apple-mobile-web-app-capable\" content=\"yes\">\n\t<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"default\">\n\t<meta content=\"text/html charset=UTF-8\" http-equiv=\"Content-Type\" />\n\t<meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,user-scalable=no\" />\n\t<link rel=\"apple-touch-icon\" href=\"HDIconImageData\">\n\t<link rel=\"apple-touch-startup-image\" href=\"HDLaunchImageData\">\n\t<title>HDAppTitle</title>\n</head>";
    [contentString insertString:head atIndex:range.location+range.length];

    NSString *contentStr = [NSString stringWithString:contentString];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:HDIconImageData withString:iconDataUri];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:HDLaunchImageData withString:launchDataUri];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:HDAppTitle withString:title];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:HDAppScheme withString:url];
    return contentStr;
}

- (NSString *)replaceIndexHtmlWithBase64ContentString:(NSString *)contentString{
    NSString *indexHtmlPath = [self getIndexHTMLTempletPath];
    NSString *indexHtmlString = [NSString stringWithContentsOfFile:indexHtmlPath encoding:NSUTF8StringEncoding error:nil];
    indexHtmlString = [indexHtmlString stringByReplacingOccurrencesOfString:HDDataURISchemeContent withString:contentString];
    return indexHtmlString;
}

- (NSString *)dataURIScheme:(UIImage *)image{
    NSData *data = UIImagePNGRepresentation(image);
    NSString *string = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *resultStr = [NSString stringWithFormat:@"data:image/png;base64,%@",string];
    return resultStr;
}

- (NSString *)getServerWebPath{
    NSString *serverWebPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:HDWebPath];
    return serverWebPath;
}

- (NSString *)getIndexHTMLTempletPath{
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:@"HDWebAppShortcut" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:associateBundleURL];
    NSString *path = [[bundle resourcePath] stringByAppendingPathComponent:@"/index.html"];
    return path;
}

- (NSString *)getContentHTMLTempletPath{
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:@"HDWebAppShortcut" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:associateBundleURL];
    NSString *path = [[bundle resourcePath] stringByAppendingPathComponent:@"/content.html"];
    NSLog(@"%@",path);
    return path;
}

- (BOOL)writeHTMLToDocument:(NSString *)htmlString{
    NSString *serverWebPath = [self getServerWebPath];
    if ([[NSFileManager defaultManager]fileExistsAtPath:serverWebPath]) {
        NSError * error;
        [[NSFileManager defaultManager]removeItemAtPath:serverWebPath error:&error];
    }
    BOOL writeSuccess = NO;
    BOOL flag = [[NSFileManager defaultManager]createDirectoryAtPath:serverWebPath withIntermediateDirectories:YES attributes:nil error:nil];
    if (flag) {
        NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
        BOOL writeToDucument = [data writeToFile:[NSString stringWithFormat:@"%@/index.html",serverWebPath] atomically:YES];
        if (writeToDucument) {
            writeSuccess = YES;
        }
    }
    return writeSuccess;
}


@end

