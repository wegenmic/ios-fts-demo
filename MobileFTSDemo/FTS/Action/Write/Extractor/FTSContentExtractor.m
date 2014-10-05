//
//  FTSContentExtractor.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 08/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSContentExtractor.h"

@implementation FTSContentExtractor

-(instancetype)initWithDocumentPath:(NSURL *)documentPath {
    self.documentPath = documentPath;
    
    NSFileHandle* handle = [NSFileHandle fileHandleForReadingFromURL:documentPath error:nil];
    if (handle) {
        self.data = [handle readDataToEndOfFile];
    }
    return self;
}

-(NSString *)extractContent {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return NULL;
}

-(NSString *)extractMetadata {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return NULL;
}

@end
