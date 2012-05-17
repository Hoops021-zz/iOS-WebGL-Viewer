//
//  WebGLViewController.m
//  WebGLViewer
//
//  Created by Troy Ferrell on 3/25/12.
//  Copyright (c) 2012 Troy Ferrell. All rights reserved.
//

#import "WebGLViewController.h"

#import "HistoryViewController.h"

@interface WebGLViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation WebGLViewController

@synthesize historyPopoverController = _historyPopoverController;
@synthesize historyController = _historyController;
@synthesize webGLView = _webGLView;
@synthesize urlField = _urlField;
@synthesize forwardButton = _forwardButton;
@synthesize backButton = _backButton;
@synthesize sessionTracker = _sessionTracker;
@synthesize sessionIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.title = NSLocalizedString(@"WebGL Viewer", @"WebGL Viewer");
        self.historyController = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
        self.sessionTracker = [[NSMutableArray alloc] initWithCapacity:1];
        self.sessionIndex = 0;
        
        [self.backButton setEnabled:FALSE];
        [self.forwardButton setEnabled:FALSE];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Code from Online
    UIWebView *webView = self.webGLView;
    id webDocumentView = [webView performSelector:@selector(_browserView)];
    id backingWebView = [webDocumentView performSelector:@selector(webView)];
    [backingWebView _setWebGLEnabled:YES]; 
    [self.webGLView setDelegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction) loadPageButtonPressed:(id)sender
{
    NSString *query = self.urlField.text;
    [self.urlField resignFirstResponder];

    if(![query hasPrefix:@"http://"] || ![query hasPrefix:@"https://"]) 
    {
        query = [NSString stringWithFormat:@"http://%@",query];
    }
    
    if([self validateUrl:query])
    {
        // Add URL to history
        [self.historyController addURLToHistory:query];
        
        // Make sure to clean up session storage
        if([self.sessionTracker count] > 0)
        {
            if(self.sessionIndex != [self.sessionTracker count] - 1)
            {
                int lengthToEnd = [self.sessionTracker count] - 1 - self.sessionIndex;
                NSLog(@"%d", lengthToEnd);
                [self.sessionTracker removeObjectsInRange:NSMakeRange(self.sessionIndex + 1, lengthToEnd)];            
            }
            
            self.sessionIndex++;
        }
        
        // Add URL to history for session
        [self.sessionTracker addObject:query];
        [self.backButton setEnabled:TRUE];
        
        // Try to load page
        [self loadPage:query];
    }
    else 
    {
        // Show error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" 
                                                        message:@"URL entered was invalid"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

- (BOOL) validateUrl: (NSString *) candidate 
{
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx]; 
    return [urlTest evaluateWithObject:candidate];
}

- (void) loadPage:(NSString *)urlQuery
{
    NSURL *url = [NSURL URLWithString:urlQuery];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webGLView loadRequest:request]; 
}


- (IBAction) historyButtonPressed:(id)sender
{
    UIPopoverController* aPopover = [[UIPopoverController alloc] initWithContentViewController:self.historyController];
    // aPopover.delegate = self;
    self.historyPopoverController = aPopover;

    [self.historyPopoverController presentPopoverFromBarButtonItem:sender 
                                   permittedArrowDirections:UIPopoverArrowDirectionAny 
                                                   animated:YES];
}

- (IBAction) forwardButtonPressed:(id)sender
{
    if(self.sessionIndex < [self.sessionTracker count] - 1)
    {
        self.sessionIndex++;
        [self.backButton setEnabled:true];
        [self loadPage:[self.sessionTracker objectAtIndex:self.sessionIndex]];
        if(self.sessionIndex == [self.sessionTracker count] - 1)
        {
            [self.forwardButton setEnabled:FALSE];
        }
    }
}

- (IBAction) backButtonPressed:(id)sender
{
    if(self.sessionIndex > 0)
    {   
        self.sessionIndex--;
        [self.forwardButton setEnabled:true];
        [self loadPage:[self.sessionTracker objectAtIndex:self.sessionIndex]];
        
        if(sessionIndex == 0)
        {
            [self.backButton setEnabled:FALSE];
        }
    }
}

#pragma mark - Split view

/*
- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"History", @"History");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}
*/
#pragma mark - WebView Delegate Methods
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" 
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loadPageButtonPressed:nil];
    [self.urlField resignFirstResponder];
    return YES;
}

- (void)dealloc
{
    [_webGLView release];
    [_urlField release];
    [_forwardButton release];
    [_backButton release];
    [_historyPopoverController release];
    [_historyController release];
    [_sessionTracker release];

    [super dealloc];
}

@end
