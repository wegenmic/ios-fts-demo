//
//  FTSJsonContentExtractor.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 08/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSJsonContentExtractor.h"

@implementation FTSJsonContentExtractor


#pragma mark - public

-(NSString *)extractContent {
    NSArray *parsedData = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:nil];
    return [self parseJsonArray:parsedData];
}

-(NSString *)extractMetadata {
    // TODO anything else to add?
    return [[NSString alloc] initWithFormat:@"filetype_%@", [self.documentPath pathExtension]];
}


#pragma mark - private

-(NSString *)parseJsonDict:(NSDictionary *)dict {
    NSMutableString *content = [[NSMutableString alloc] init];
    for (NSObject* key in dict) {
        [content appendString:[self parse:[dict objectForKey:key]]];
    }
    return content;
}

-(NSString *)parseJsonArray:(NSArray *)array {
    NSMutableString *content = [[NSMutableString alloc] init];
    for(NSDictionary *dict in array) {
        [content appendString:[self parse:dict]];
    }
    return content;
}

-(NSString *)parse:(NSObject *)object {
    NSString *content;
    if([object isKindOfClass:[NSDictionary class]]) {
        content = [self parseJsonDict:(NSDictionary *) object];
    } else if ([object isKindOfClass:[NSArray class]]) {
        content = [self parseJsonArray:(NSArray *) object];
    } else if ([object isKindOfClass:[NSNumber class]]) {
        content = [NSString stringWithFormat:@"%@ ", [(NSNumber *)object stringValue]];
    } else {
        content = [NSString stringWithFormat:@"%@ ", (NSString *)object];
    }
    return content;
}

@end
