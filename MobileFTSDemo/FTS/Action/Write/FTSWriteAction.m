//
//  FTSWriteAction.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSWriteAction.h"
#import "FTSConstants.h"

@implementation FTSWriteAction


#pragma mark - public

- (void)write:(NSURL *)documentPath {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        NSDate *start = [NSDate date];
        FTSWriteActionData *writeActionData = [[FTSWriteActionData alloc] initWithDocumentPath:documentPath];
        [[self.handler writeQueue] addOperationWithBlock:^{
            [[self.handler writeQueueLock] lock];
            [[self.handler queue] inDatabase:^(FMDatabase *database) {
                writeActionData.database = database;
                [self action:writeActionData];
            }];
            [[self.handler writeQueueLock] unlock];
        }];
        NSDate *end = [NSDate date];
        NSTimeInterval executionTime = [end timeIntervalSinceDate:start];
        NSLog(@"%@ Document [%@] took %f s", self.actionName, writeActionData.filename, executionTime);
    });
}

- (void)action:(FTSWriteActionData *)input {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}


#pragma mark - private

-(NSString *)actionName {
    return @"Write";
}

- (BOOL)documentExists:(NSString *)filename inDatabase:(FMDatabase *)database {
    FMResultSet *rs = [database executeQuery:[NSString stringWithFormat:FIND_DOCUMENT_BY_PATH_QUERY, TABLE_NAME], filename, nil];
    BOOL exists = [rs next];
    [rs close];
    return exists;
}

@end
