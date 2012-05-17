//
//  AppDelegate.h
//  WebGLViewer
//
//  Created by Troy Ferrell on 3/25/12.
//  Copyright (c) 2012 Troy Ferrell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow*           _window;
    //    AppViewController*  _viewcontrol;
    UINavigationController* _navigationController;
    UISplitViewController* _splitViewController;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) UISplitViewController *splitViewController;

@end
