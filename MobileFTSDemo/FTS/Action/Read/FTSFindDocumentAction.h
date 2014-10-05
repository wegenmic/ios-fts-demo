//
//  FTSFindDocumentAction.h
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSReadAction.h"

@protocol FTSFindDocumentActionDelegate;

@interface FTSFindDocumentAction : FTSReadAction

@property (nonatomic, weak) id<FTSFindDocumentActionDelegate> delegate;

+ (FTSFindDocumentAction *)sharedFTSFindDocumentActionWithDelegate:(id)delegate;

@end

@protocol FTSFindDocumentActionDelegate <FTSActionDelegate>
@optional
-(void)ftsDocumentAction:(FTSFindDocumentAction *)action didFindDocuments:(NSArray *)documentPaths forSearch:(NSString *)query;
@end
