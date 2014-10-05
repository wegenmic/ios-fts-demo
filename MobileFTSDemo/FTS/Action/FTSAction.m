//
//  FTSAction.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSAction.h"

@implementation FTSAction

- (instancetype)init {
    self.handler = [FTSDatabaseHandler sharedFTSDatabaseHandler];
    return self;
}

@end
