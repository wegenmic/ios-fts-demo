//
//  FTSActionData.h
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface FTSActionData : NSObject

@property (strong, nonatomic) FMDatabase *database;

@end
