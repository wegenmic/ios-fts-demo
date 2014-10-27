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
    self.workingDatabasePath = databasePath;
    [self prepareDatabaseConnection];
    [self prepareDatabase];
    return self;
}

- (void)prepareDatabaseConnection
{
    NSLog(@"Prepare Database connection");
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:self.workingDatabasePath];
    
    [self copyDatabaseIfNeeded:dbPath];
    
    _queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    _writeQueue = [NSOperationQueue new];
    [_writeQueue setMaxConcurrentOperationCount:1];
    _writeQueueLock = [NSRecursiveLock new];
    
    NSLog(@"Database connection prepared for path [%@]", dbPath);
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

- (void)dropDatabase
{
    [_writeQueue addOperationWithBlock:^{
        [_writeQueueLock lock];
        [_queue inDatabase:^(FMDatabase *database) {
            NSLog(@"Cleanup FTS DB");
            [database executeUpdate:[NSString stringWithFormat:dropTableDatabaseQuery, tableName]];
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

- (void)deleteDatabase
{
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:self.workingDatabasePath];
    
    NSError *err = nil;
    [[NSFileManager defaultManager] removeItemAtURL:[NSURL URLWithString:dbPath] error:&err];
    if (err) {
        NSLog(@"Error occured while deleting: %@",err);
    }
}

// If the database that should be used is not the default database, then it will be copied from the default database to the required one.
// Is currently used only for testing.
- (void)copyDatabaseIfNeeded:(NSString *)targetDbPath
{
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *defaultDbPath = [documentsDir stringByAppendingPathComponent:databasePath];

    NSURL *sourceUrl = [NSURL URLWithString:defaultDbPath];
    NSURL *targetUrl = [NSURL URLWithString:targetDbPath];
    
    if([defaultDbPath isEqualToString:targetDbPath]) {
        return;
    }
    
    NSError *err = nil;
    [[NSFileManager defaultManager] removeItemAtURL:targetUrl error:nil];
    [[NSFileManager defaultManager] copyItemAtURL:sourceUrl toURL:targetUrl error:&err];
    if (err) {
        NSLog(@"Error occured when copying file: %@",err);
    }
}

@end
