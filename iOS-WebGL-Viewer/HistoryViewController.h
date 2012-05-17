//
//  HistoryViewController.h
//  WebGLViewer
//
//  Created by Troy Ferrell on 3/25/12.
//  Copyright (c) 2012 Troy Ferrell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebGLViewController;

@interface HistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) WebGLViewController *detailViewController;

@property (strong, nonatomic) IBOutlet UITableView *historyTableView;

- (void) addURLToHistory:(NSString *)urlStr;
- (IBAction) clearButtonPressed:(id)sender;

@end
