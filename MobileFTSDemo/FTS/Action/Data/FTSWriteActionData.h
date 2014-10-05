//
//  FTSWriteActionData.h
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSActionData.h"

@interface FTSWriteActionData : FTSActionData

@property (strong, nonatomic) NSURL *documentPath;

- (instancetype)initWithDocumentPath:(NSURL *)documentPath andDatabase:(FMDatabase *)database;

@end
