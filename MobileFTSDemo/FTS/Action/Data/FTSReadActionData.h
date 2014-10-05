//
//  FTSReadActionData.h
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSActionData.h"

@interface FTSReadActionData : FTSActionData

@property (strong, nonatomic) NSString *query;

- (instancetype)initWithQuery:(NSString *)query andDatabase:(FMDatabase *)database;

@end
