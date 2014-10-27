//
//  FTSFindDocumentAction.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSConstants.h"
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


#pragma mark - public

- (void)action:(FTSReadActionData *)input {
    NSMutableArray *foundDocumentPaths = [[NSMutableArray alloc] init];
    FMResultSet *rs;
    if([input.query length] == 0) {
        // search for all documents in index when there is an empty input query
        rs = [input.database executeQuery:[NSString stringWithFormat:findAllDocumentsQuery, tableName]];
    } else {
        rs = [input.database executeQuery:[NSString stringWithFormat:findDocumentByContentQuery, tableName], input.query, nil];
    }
    
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    while ([rs next]) {
        NSString *filename = [rs stringForColumn:tableIdColumn];
        NSString *documentPath = [documentsDir stringByAppendingPathComponent:filename];
        NSURL *documentUrl = [NSURL fileURLWithPath:documentPath];
        if(documentUrl != nil) {
            [foundDocumentPaths addObject:documentUrl];
        }
        
    }
    [rs close];
    [self notifyDelegate:foundDocumentPaths forSearch:input.query];
}


#pragma mark - private

-(NSString *)actionName {
    return @"Find";
}


#pragma mark - FTSFindDocumentActionDelegate

- (void)notifyDelegate:(NSArray *)foundDocumentPaths forSearch:(NSString *)query {
    if ([self.delegate respondsToSelector:@selector(ftsDocumentAction:didFindDocuments:forSearch:)]) {
        [self.delegate ftsDocumentAction:self didFindDocuments:foundDocumentPaths forSearch:query];
    }
}

@end
