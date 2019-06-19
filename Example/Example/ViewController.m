//
//  ViewController.m
//  Example
//
//  Created by woody on 2018/10/25.
//  Copyright © 2018 woody. All rights reserved.
//

#import "ViewController.h"
#import "HDWebAppShortcut.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)buttonAction{
    NSString *htmlPath = [[NSBundle mainBundle]pathForResource:@"content1" ofType:@"html"];
    NSError *error;
    NSString *htmlStr = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:&error];
    [HDWebAppShortcut createShortcut:[UIImage imageNamed:@"icon"] launchImage:[UIImage imageNamed:@"launch"] appTitle:@"测试桌面" urlScheme:@"HD://home/refresh" sourceHtml:htmlStr];
}

@end
