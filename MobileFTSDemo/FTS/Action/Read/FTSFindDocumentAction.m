//
//  FTSFindDocumentAction.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSFindDocumentAction.h"

@implementation FTSFindDocumentAction

+ (FTSFindDocumentAction *)sharedFTSFindDocumentActionWithDelegate:(id)delegate{
    static FTSFindDocumentAction *_shareFTSFindDocumentAction = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareFTSFindDocumentAction = [[self alloc] init];
    });
    _shareFTSFindDocumentAction.delegate = delegate;
    _shareFTSFindDocumentAction.preprocessor = [[FTSQueryPreprocessor alloc] init];
    
    return _shareFTSFindDocumentAction;
}

- (void)action:(FTSReadActionData *)input {
    NSMutableArray *foundDocumentPaths = [[NSMutableArray alloc] init];
    FMResultSet *rs;
    if([input.query length] == 0) {
        // search for all documents in index when there is an empty input query
        rs = [input.database executeQuery:[NSString stringWithFormat:@"SELECT path FROM %@", [self.handler tableName]]];
    } else {
        rs = [input.database executeQuery:[NSString stringWithFormat:@"SELECT path FROM %@ WHERE content MATCH ?", [self.handler tableName]], input.query, nil];
    }
    
    while ([rs next]) {
        NSString *path = [rs stringForColumn:@"path"];
        if(path != nil) {
            [foundDocumentPaths addObject:path];
        }
        
    }
    [rs close];
    [self notifyDelegate:foundDocumentPaths forSearch:input.query];
}

- (void)notifyDelegate:(NSArray *)foundDocumentPaths forSearch:(NSString *)query {
    if ([self.delegate respondsToSelector:@selector(ftsDocumentAction:didFindDocuments:forSearch:)]) {
        [self.delegate ftsDocumentAction:self didFindDocuments:foundDocumentPaths forSearch:query];
    }
}

-(NSString *)actionName {
    return @"Find";
}

@end
