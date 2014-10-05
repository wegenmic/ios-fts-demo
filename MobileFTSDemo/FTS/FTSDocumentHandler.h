//
//  FTSDocumentHandler.h
//  MobileAssetFTS
//
//  Created by Michael Wegener on 04/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTSAction.h"

@protocol FTSDocumentHandlerDelegate;

//
// To make use of the Offline Asset Fulltext Search, the easiest way to access its functionality is by the FTSDocumentHandler.
// Create a singleton instance by calling [(FTSDocumentHandler *)sharedFTSDocumentHandlerWithDelegate:(id)delegate] and you are ready to go.
// All the following functions trigger asynchronous calls and give feedback via their delegate callbacks. All of them are optional by design.
// When passing the delegate, remember that the delegate class has to handle all the desired delegate callbacks.
//
// Callbacks:
//
// 1.) Finding Documents
//
// @protocol FTSFindDocumentActionDelegate <FTSActionDelegate>
// @optional
// -(void)ftsDocumentAction:(FTSFindDocumentAction *)action didFindDocuments:(NSArray *)documentPaths forSearch:(NSString *)query;
// @end
//
// 2.) Adding & Updating Documents
//
// @protocol FTSAddDocumentActionDelegate <FTSActionDelegate>
// @optional
// -(void)ftsDocumentAction:(FTSAddDocumentAction *)action didAddDocument:(NSURL *)pathToDocument;
// -(void)ftsDocumentAction:(FTSAddDocumentAction *)action didFailAddingDocument:(NSURL *)pathToDocument;
// -(void)ftsDocumentAction:(FTSAddDocumentAction *)action didUpdateDocument:(NSURL *)pathToDocument;
// -(void)ftsDocumentAction:(FTSAddDocumentAction *)action didFailUpdatingDocument:(NSURL *)pathToDocument;
// @end
//
// 3.) Removing Documents
//
// @protocol FTSRemoveDocumentActionDelegate <FTSActionDelegate>
// @optional
// -(void)ftsDocumentAction:(FTSRemoveDocumentAction *)action didRemoveDocument:(NSURL *)pathToDocument;
// -(void)ftsDocumentAction:(FTSRemoveDocumentAction *)action didFailRemovingDocument:(NSURL *)pathToDocument;
// @end
//
@interface FTSDocumentHandler : NSObject
@property (nonatomic, weak) id<FTSActionDelegate> delegate;

+ (FTSDocumentHandler *)sharedFTSDocumentHandlerWithDelegate:(id)delegate;

- (void)findDocuments:(NSString *)searchText;
- (void)findDocuments:(NSString *)searchText withFacets:(NSArray *)facets;

- (void)addDocument:(NSURL *)documentPath;
- (void)addDocuments:(NSArray *)documentPaths;

- (void)removeDocument:(NSURL *)documentPath;
- (void)removeDocuments:(NSArray *)documentPaths;
- (void)removeAllDocuments;

@end
