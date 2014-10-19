//
//  FTSDatabaseHandler.h
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"

@interface FTSDatabaseHandler : NSObject

@property (strong, nonatomic) NSString *workingDatabasePath;
@property (strong, nonatomic) FMDatabaseQueue *queue;
@property (strong, nonatomic) NSOperationQueue *writeQueue;
@property (strong, nonatomic) NSRecursiveLock *writeQueueLock;

// Creates a singleton instance of FTSDatabaseHandler
+ (FTSDatabaseHandler *)sharedFTSDatabaseHandler;
// Initialization combined with DB setup tasks
- (instancetype)init;
// Setup of the DB queueing and locking mechanism
- (void)prepareDatabaseConnection;
// Setup database table if not already existing
- (void)prepareDatabase;
// Drop the Table created in [(void)prepareDatabase]
- (void)dropDatabase;
// Delete the database
- (void)deleteDatabase;
// Remove all entries from the Table created in [(void)prepareDatabase]
- (void)cleanDatabase;



@end
