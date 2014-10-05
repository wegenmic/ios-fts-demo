//
//  DetailViewController.h
//  MobileFTSDemo
//
//  Created by Michael Wegener on 04/10/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Document.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Document *doc;
@property (strong, nonatomic) UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

