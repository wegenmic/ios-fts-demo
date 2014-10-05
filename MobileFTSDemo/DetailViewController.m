//
//  DetailViewController.m
//  MobileFTSDemo
//
//  Created by Michael Wegener on 04/10/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_doc != newDetailItem) {
        _doc = newDetailItem;
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.doc) {
        self.detailDescriptionLabel.text = self.doc.title;
        
        if (!_webView) {
            _webView = [[UIWebView alloc] init];
            [self.view addSubview:_webView];
            [_webView setFrame:self.view.frame];
            [_webView setBounds:self.view.bounds];
            [_webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ];
        }

        NSLog(@"Open WebView with path: [%@]", self.doc.path);
        NSURLRequest *request = [NSURLRequest requestWithURL:[self.doc.path absoluteURL]];
        [_webView loadRequest:request];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // added to handle the navigation bar overlap of the view
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self configureView];
    self.title = self.doc.title;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
