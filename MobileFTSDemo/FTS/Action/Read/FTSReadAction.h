//
//  FTSReadAction.h
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSAction.h"
#import "FTSReadActionData.h"
#import "FTSQueryPreprocessor.h"

@interface FTSReadAction : FTSAction

@property (strong, nonatomic) NSString *lastSearchQuery;
@property (strong, nonatomic) FTSQueryPreprocessor *preprocessor;

// Handles the delayed search mechanism and prepares the DB locking mechanism for the search before it calls [(void)action:(FTSReadActionData *)input].
// It also logs the execution time.
- (void)find:(NSString *)query;
// In addition to [(void)find:(NSString *)query] it extends the query by the additional facets
- (void)find:(NSString *)query withFacets:(NSArray *)facets;
// Does the actual reading and has to be implemented by subclasses an gets called by [(void)find:(NSString *)query].
- (void)action:(FTSReadActionData *)input;

@end
