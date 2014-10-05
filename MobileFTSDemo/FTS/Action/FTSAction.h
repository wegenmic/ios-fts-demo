//
//  FTSAction.h
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FTSDatabaseHandler.h"

@protocol FTSActionDelegate;

@interface FTSAction : NSObject

@property (strong, nonatomic) FTSDatabaseHandler *handler;
@property (nonatomic, weak) id<FTSActionDelegate> delegate;

- (instancetype)init;

@end

@protocol FTSActionDelegate <NSObject>
@optional
@end