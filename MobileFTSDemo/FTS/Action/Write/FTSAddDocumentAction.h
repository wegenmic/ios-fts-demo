//
//  FTSAddDocumentAction.h
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSWriteAction.h"

@protocol FTSAddDocumentActionDelegate;

@interface FTSAddDocumentAction : FTSWriteAction

@property (nonatomic, weak) id<FTSAddDocumentActionDelegate> delegate;

+ (FTSAddDocumentAction *)sharedFTSAddDocumentActionWithDelegate:(id)delegate;

@end

@protocol FTSAddDocumentActionDelegate <FTSActionDelegate>
@optional
// Add
-(void)ftsDocumentAction:(FTSAddDocumentAction *)action didAddDocument:(NSURL *)pathToDocument;
-(void)ftsDocumentAction:(FTSAddDocumentAction *)action didFailAddingDocument:(NSURL *)pathToDocument;
// Update
-(void)ftsDocumentAction:(FTSAddDocumentAction *)action didUpdateDocument:(NSURL *)pathToDocument;
-(void)ftsDocumentAction:(FTSAddDocumentAction *)action didFailUpdatingDocument:(NSURL *)pathToDocument;
@end
