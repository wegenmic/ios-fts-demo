//
//  FTSWriteActionData.h
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSActionData.h"

@interface FTSWriteActionData : FTSActionData

@property (strong, nonatomic) NSURL *originDocumentPath;
@property (strong, nonatomic) NSURL *targetDocumentPath;
@property (strong, nonatomic) NSString *filename;

- (instancetype)initWithDocumentPath:(NSURL *)documentPath;

@end
