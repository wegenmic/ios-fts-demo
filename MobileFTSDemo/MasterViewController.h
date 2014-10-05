//
//  MasterViewController.h
//  MobileFTSDemo
//
//  Created by Michael Wegener on 04/10/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSFindDocumentAction.h"
#import "FTSRemoveDocumentAction.h"
#import "FTSAddDocumentAction.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <UISearchBarDelegate, FTSFindDocumentActionDelegate, FTSRemoveDocumentActionDelegate, FTSAddDocumentActionDelegate, UITextFieldDelegate>

@property (nonatomic, retain) DetailViewController *detailViewController;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextField *addDocumentTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

// Actions
- (IBAction)addDocument:(id)sender;

@end

