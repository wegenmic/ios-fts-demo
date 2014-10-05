//
//  FTSReadAction.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSReadAction.h"

@implementation FTSReadAction

- (void)find:(NSString *)query {
    self.lastSearchQuery = query;
    
    // add execution delay for 1.0s if the search query has 3 or less characters
    double_t delay = 1.0;
	if ([query length] > 3) {
		delay = 0.0;
	}
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void) {
        // abort outdated query requests
        if (![[self lastSearchQuery] isEqualToString:query]) {
			return;
		}
        
        NSDate *start = [NSDate date];
        NSString* preProcessedQuery = [self.preprocessor processQuery:query];
        [[self.handler writeQueueLock] lock];
        [[self.handler queue] inDatabase:^(FMDatabase *database) {
            [self action:[[FTSReadActionData alloc] initWithQuery:preProcessedQuery andDatabase:database]];
        }];
        [[self.handler writeQueueLock] unlock];
        NSDate *end = [NSDate date];
        NSTimeInterval executionTime = [end timeIntervalSinceDate:start];
        NSLog(@"%@ Documents for Query [%@] took %f s", self.actionName, preProcessedQuery, executionTime);
    });
}

- (void)find:(NSString *)query withFacets:(NSArray *)facets {
    NSMutableString *queryWithFacets = [[NSMutableString alloc] init];
    
    for (NSString *facet in facets) {
        [queryWithFacets appendFormat:@"keywords:%@ ", facet];
    }
    
    [queryWithFacets appendString:query];
    [self find:queryWithFacets];
}

- (void)action:(FTSReadActionData *)input {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

-(NSString *)actionName {
    return @"Read";
}


@end
