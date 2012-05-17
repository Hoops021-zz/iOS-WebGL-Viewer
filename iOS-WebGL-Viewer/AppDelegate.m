//
//  AppDelegate.m
//  WebGLViewer
//
//  Created by Troy Ferrell on 3/25/12.
//  Copyright (c) 2012 Troy Ferrell. All rights reserved.
//

#import "AppDelegate.h"

#import "HistoryViewController.h"
#import "WebGLViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize splitViewController = _splitViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        WebGLViewController *webGLController = [[WebGLViewController alloc] initWithNibName:@"WebGLViewController_iPhone" bundle:nil];
        
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:webGLController];
        
        self.window.rootViewController = self.navigationController;
    } 
    else
    {
        /*
         HistoryViewController *masterViewController = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
         
         UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
         
         WebGLViewController *detailViewController = [[WebGLViewController alloc] initWithNibName:@"WebGLViewController" bundle:nil];
         detailViewController.masterController = masterViewController;
         
         UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
         
         masterViewController.detailViewController = detailViewController;
         
         self.splitViewController = [[UISplitViewController alloc] init];
         self.splitViewController.delegate = detailViewController;
         self.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];
         */
        
        WebGLViewController *detailViewController = [[WebGLViewController alloc] initWithNibName:@"WebGLViewController" bundle:nil];
        
        self.window.rootViewController = detailViewController;
        //self.window.rootViewController = self.splitViewController;
    }
    
    [self.window makeKeyAndVisible];
}

- (void) dealloc 
{
    [_window release];
    [_navigationController release];
    [_splitViewController release];
    [super dealloc];
}

@end
