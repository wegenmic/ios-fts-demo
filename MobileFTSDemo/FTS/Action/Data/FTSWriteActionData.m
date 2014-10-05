//
//  FTSWriteActionData.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSWriteActionData.h"

@implementation FTSWriteActionData

- (instancetype)initWithDocumentPath:(NSURL *)documentPath andDatabase:(FMDatabase *)database {
    self.documentPath = documentPath;
    self.database = database;
    return self;
}

@end
