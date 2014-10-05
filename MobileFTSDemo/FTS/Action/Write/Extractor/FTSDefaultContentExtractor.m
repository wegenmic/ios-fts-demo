//
//  FTSDefaultContentExtractor.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 08/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSDefaultContentExtractor.h"

@implementation FTSDefaultContentExtractor

-(NSString *)extractContent {
    return [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
}

-(NSString *)extractMetadata {
    return [[NSString alloc] initWithFormat:@"filetype_%@", [self.documentPath pathExtension]];
}

@end
