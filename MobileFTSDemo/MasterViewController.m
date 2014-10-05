//
//  MasterViewController.m
//  MobileFTSDemo
//
//  Created by Michael Wegener on 04/10/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "FTSDocumentHandler.h"
#import "Document.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
    FTSDocumentHandler *_indexedDocumentHandler;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    
    [super awakeFromNib];
}

- (void)displaySearchBar
{
    
    [self.addButton setHidden:YES];
    [self.addDocumentTextField setHidden:YES];
    [self.searchBar setHidden:NO];
    
    [self.searchBar becomeFirstResponder];
}

- (void)displayAddDocument
{
    [self loadDocumentsFromIndex];
    
    [self.addButton setHidden:NO];
    [self.addDocumentTextField setHidden:NO];
    [self.searchBar setHidden:YES];
    
    [self.addDocumentTextField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self displaySearchBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDocumentViewAppear:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    }
    
    _indexedDocumentHandler = [FTSDocumentHandler sharedFTSDocumentHandlerWithDelegate:self];
    [self loadDocumentsFromIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDocumentsFromIndex
{
    [_indexedDocumentHandler findDocuments:[self.searchBar text]];
}

- (void)addDocumentViewAppear:(id)sender
{
    if([self.searchBar isHidden]) {
        [self displaySearchBar];
    } else {
        [self displayAddDocument];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Document *doc = _objects[indexPath.row];
    cell.textLabel.text = doc.title;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Document *doc = [_objects objectAtIndex:indexPath.row];
        [_indexedDocumentHandler removeDocument:doc.path];
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        Document *doc = _objects[indexPath.row];
        self.detailViewController.doc = doc;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            Document *doc = _objects[indexPath.row];
            DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
            [controller setDoc:doc];
            controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
            controller.navigationItem.leftItemsSupplementBackButton = YES;
        } else {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            Document *doc = _objects[indexPath.row];
            [[segue destinationViewController] setDoc:doc];
        }
    }
}

// Actions
- (IBAction)addDocument:(id)sender
{
    [self addDocument];
}

- (void)addDocument
{
    NSString* documentPath = self.addDocumentTextField.text;
    NSArray* splitDocumentPath = [self separateComponents:documentPath byLastOccurrence:@"."];
    NSURL* documentUrl = [[NSBundle mainBundle] URLForResource:splitDocumentPath[0] withExtension:splitDocumentPath[1]];
    
    if(documentUrl != nil) {
        [_indexedDocumentHandler addDocument:[documentUrl absoluteURL]];
    } else {
        NSLog(@"Could not find the Document [%@]", documentPath);
    }

    self.addDocumentTextField.text = @"";
    [self displaySearchBar];
}

- (NSArray *)separateComponents:(NSString *)input byLastOccurrence:(NSString *)delimiter {
    NSArray* splitDocumentPath = [input componentsSeparatedByString:delimiter];
    if (splitDocumentPath.count < 2) {
        return [[NSArray alloc] initWithObjects:input, @"", nil];
    }
    NSMutableString* path = [[NSMutableString alloc] init];
    for (NSString* splitPart in splitDocumentPath) {
        if ([splitDocumentPath lastObject] != splitPart) {
            [path appendFormat:@"%@.",splitPart];
        } else {
            [path deleteCharactersInRange:NSMakeRange([path length]-1, 1)];
        }
    }
    NSString* lastElement = [splitDocumentPath lastObject];
    return [[NSArray alloc] initWithObjects:path, lastElement, nil];
}

// UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_indexedDocumentHandler findDocuments:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [_indexedDocumentHandler findDocuments:[searchBar text]];
}

// UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self addDocument];
    return NO;
}

// FTSFindDocumentActionDelegate

-(void)ftsDocumentAction:(FTSFindDocumentAction *)action didFindDocuments:(NSArray *)documentPaths forSearch:(NSString *)query {
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    
    [_objects removeAllObjects];
    for (NSString * documentPath in documentPaths) {
        NSURL *urlPath = [NSURL URLWithString:[documentPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        Document *doc = [[Document alloc] initWithPath:urlPath];
        [_objects insertObject:doc atIndex:0];
    }
    [self.tableView reloadData];
}

// FTSRemoveDocumentActionDelegate

-(void)ftsDocumentAction:(FTSRemoveDocumentAction *)action didRemoveDocument:(NSURL *)pathToDocument
{
    NSLog(@"Removed Document [%@] successfully", pathToDocument);
}
-(void)ftsDocumentAction:(FTSRemoveDocumentAction *)action didFailRemovingDocument:(NSURL *)pathToDocument
{
    NSLog(@"Failed to remove Document [%@]", pathToDocument);
}

// FTSAddDocumentActionDelegate

// Add
-(void)ftsDocumentAction:(FTSAddDocumentAction *)action didAddDocument:(NSURL *)pathToDocument
{
    NSLog(@"Added Document [%@] successfully", pathToDocument);
    [self loadDocumentsFromIndex];
}
-(void)ftsDocumentAction:(FTSAddDocumentAction *)action didFailAddingDocument:(NSURL *)pathToDocument
{
    NSLog(@"Failed to add Document [%@]", pathToDocument);
}

// Update
-(void)ftsDocumentAction:(FTSAddDocumentAction *)action didUpdateDocument:(NSURL *)pathToDocument
{
    NSLog(@"Updated Document [%@] successfully", pathToDocument);
    [self loadDocumentsFromIndex];
}
-(void)ftsDocumentAction:(FTSAddDocumentAction *)action didFailUpdatingDocument:(NSURL *)pathToDocument
{
    NSLog(@"Failed to update Document [%@]", pathToDocument);
}

@end
