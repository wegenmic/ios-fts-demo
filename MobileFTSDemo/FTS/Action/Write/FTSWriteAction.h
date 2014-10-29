//
//  FTSWriteAction.h
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSAction.h"
#import "FTSWriteActionData.h"

@interface FTSWriteAction : FTSAction

// Prepared the DB locking and queueing mechanism and logs the execution time of the [(void)action:(FTSWriteActionData *)input] function.
- (void)write:(NSURL *)documentPath;
// Does the actual writing and has to be implemented by subclasses an gets called by [(void)write:(NSURL *)documentPath].
- (void)action:(FTSWriteActionData *)input;

// Helper Functions
- (BOOL)documentExists:(NSString *)filename inDatabase:(FMDatabase *)database;

@end
