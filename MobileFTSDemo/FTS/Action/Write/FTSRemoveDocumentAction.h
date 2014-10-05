//
//  FTSRemoveDocumentAction.h
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSWriteAction.h"

@protocol FTSRemoveDocumentActionDelegate;

@interface FTSRemoveDocumentAction : FTSWriteAction

@property (nonatomic, weak) id<FTSRemoveDocumentActionDelegate> delegate;

+ (FTSRemoveDocumentAction *)sharedFTSRemoveDocumentActionWithDelegate:(id)delegate;

@end

@protocol FTSRemoveDocumentActionDelegate <FTSActionDelegate>
@optional
-(void)ftsDocumentAction:(FTSRemoveDocumentAction *)action didRemoveDocument:(NSURL *)pathToDocument;
-(void)ftsDocumentAction:(FTSRemoveDocumentAction *)action didFailRemovingDocument:(NSURL *)pathToDocument;
@end
