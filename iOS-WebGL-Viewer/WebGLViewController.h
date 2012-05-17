//
//  WebGLViewController.h
//  WebGLViewer
//
//  Created by Troy Ferrell on 3/25/12.
//  Copyright (c) 2012 Troy Ferrell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HistoryViewController;

@interface WebGLViewController : UIViewController < UIWebViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) HistoryViewController *historyController;

@property (strong, nonatomic) UIPopoverController *historyPopoverController;

@property (strong, nonatomic) IBOutlet UIWebView *webGLView;

@property (strong, nonatomic) IBOutlet UITextField *urlField;

@property (strong, nonatomic) IBOutlet UIButton *forwardButton;

@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) NSMutableArray *sessionTracker;
@property (nonatomic) int sessionIndex;

- (void) loadPage:(NSString *)urlQuery;

- (IBAction) loadPageButtonPressed:(id)sender;
- (IBAction) historyButtonPressed:(id)sender;
- (IBAction) forwardButtonPressed:(id)sender;
- (IBAction) backButtonPressed:(id)sender;

@end
