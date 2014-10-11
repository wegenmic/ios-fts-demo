//
//  FTSDatabaseHandler.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSConstants.h"
#import "FTSDatabaseHandler.h"
#import "FMDatabase.h"

@implementation FTSDatabaseHandler

+ (FTSDatabaseHandler *)sharedFTSDatabaseHandler {
    static FTSDatabaseHandler *_shareFTSDatabaseHandler = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareFTSDatabaseHandler = [[self alloc] init];
    });
    
    return _shareFTSDatabaseHandler;
}

- (instancetype)init {
    [self prepareDatabaseConnection];
    [self prepareDatabase];
    return self;
}

- (void)prepareDatabaseConnection
{
    NSLog(@"Prepare Database connection.");
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:databasePath];
    
    _queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    _writeQueue = [NSOperationQueue new];
    [_writeQueue setMaxConcurrentOperationCount:1];
    _writeQueueLock = [NSRecursiveLock new];
}

- (void)prepareDatabase
{
    [_writeQueue addOperationWithBlock:^{
        [_writeQueueLock lock];
        [_queue inDatabase:^(FMDatabase *database) {
            NSLog(@"Start preparing FTS DB...");
            // Create DB Table if it doesn't exist.
            BOOL success = [database executeUpdate:[NSString stringWithFormat:createDatabaseQuery, tableName]];
            
            if(success) {
                NSLog(@"Finished Preparing FTS DB");
            } else {
                NSLog(@"Error while preparing FTS DB");
            }
        }];
        [_writeQueueLock unlock];
    }];
}

- (void)killDatabase
{
    [_writeQueue addOperationWithBlock:^{
        [_writeQueueLock lock];
        [_queue inDatabase:^(FMDatabase *database) {
            NSLog(@"Cleanup FTS DB");
            [database executeUpdate:[NSString stringWithFormat:killDatabaseQuery, tableName]];
        }];
        [_writeQueueLock unlock];
    }];
}

- (void)cleanDatabase
{
        [_writeQueue addOperationWithBlock:^{
            [_writeQueueLock lock];
            [_queue inDatabase:^(FMDatabase *database) {
                NSLog(@"Remove all documents from FTS DB");
                [database executeUpdate:[NSString stringWithFormat:cleanDatabaseQuery, tableName], nil];
            }];
            [_writeQueueLock unlock];
        }];
}

@end
