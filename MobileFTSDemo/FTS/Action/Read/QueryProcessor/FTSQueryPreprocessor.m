//
//  FTSQueryPreprocessor.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSQueryPreprocessor.h"

@implementation FTSQueryPreprocessor

-(NSString *)processQuery:(NSString *)query {
    NSArray* tokens = [query componentsSeparatedByString:@" "];
    NSMutableString* modifiedQuery = [[NSMutableString alloc] init];
    NSString* wildcard = @"*";
    for (NSString* token in tokens) {
        // add wildcard postfix (*)
        if([token length] > 0) {
            [modifiedQuery appendFormat:@"%@%@ ", token, wildcard];
        }
    }
    // TODO remove last character (space)?
    
    return modifiedQuery;
}

@end
