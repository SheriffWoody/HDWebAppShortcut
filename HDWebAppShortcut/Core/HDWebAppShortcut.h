//
//  HDWebAppShortcut.h
//  Pods-Example
//
//  Created by woody on 2019/5/27.
//

#import <Foundation/Foundation.h>
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface HDWebAppShortcut : NSObject

+ (void)createShortcut:(UIImage *)iconImg
           launchImage:(UIImage *)launchImg
              appTitle:(NSString *)title
             urlScheme:(NSString *)url
            sourceHtml:(NSString *)htmlStr;

@end

NS_ASSUME_NONNULL_END
