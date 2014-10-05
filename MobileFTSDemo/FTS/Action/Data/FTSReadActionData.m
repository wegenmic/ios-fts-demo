//
//  FTSReadActionData.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSReadActionData.h"

@implementation FTSReadActionData

- (instancetype)initWithQuery:(NSString *)query andDatabase:(FMDatabase *)database {
    self.query = query;
    self.database = database;
    return self;
}

@end
