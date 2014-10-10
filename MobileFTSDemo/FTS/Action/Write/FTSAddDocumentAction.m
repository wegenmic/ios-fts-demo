//
//  FTSAddDocumentAction.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSAddDocumentAction.h"

@implementation FTSAddDocumentAction

+ (FTSAddDocumentAction *)sharedFTSAddDocumentActionWithDelegate:(id)delegate {
    static FTSAddDocumentAction *_shareFTSAddDocumentAction = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareFTSAddDocumentAction = [[self alloc] init];
    });
    _shareFTSAddDocumentAction.delegate = delegate;
    
    return _shareFTSAddDocumentAction;
}

- (void)action:(FTSWriteActionData *)input {
    BOOL success = NO;
    
    if(input.filename == nil) {
        [self notifyAddDelegate:success forDocument:input.originDocumentPath];
        return;
    }
    
    NSString *content = [self retrieveContentFromDocument:input.targetDocumentPath];
    NSString *metadata = [self retrieveMetadataFromDocument:input.targetDocumentPath];
    
    if ([self documentExists:input.filename inDatabase:input.database]) {
        // UPDATE - document exists.
        success = [input.database executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET keywords = ?, content = ? WHERE path = ?", [self.handler tableName]], metadata, content, input.filename,  nil];
        [self notifyUpdateDelegate:success forDocument:input.originDocumentPath];
    } else {
        // ADD - document does not exist yet.
        success = [input.database executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@(path, keywords, content) VALUES(?, ?, ?)", [self.handler tableName]], input.filename, metadata, content, nil];
        [self notifyAddDelegate:success forDocument:input.originDocumentPath];
    }
}

- (void)notifyAddDelegate:(BOOL)success forDocument:(NSURL *)documentPath {
    if (success && [self.delegate respondsToSelector:@selector(ftsDocumentAction:didAddDocument:)]) {
        [self.delegate ftsDocumentAction:self didAddDocument:documentPath];
    }
    
    if (!success && [self.delegate respondsToSelector:@selector(ftsDocumentAction:didFailAddingDocument:)]) {
        [self.delegate ftsDocumentAction:self didFailAddingDocument:documentPath];
    }
}

- (void)notifyUpdateDelegate:(BOOL)success forDocument:(NSURL *)documentPath {
    if (success && [self.delegate respondsToSelector:@selector(ftsDocumentAction:didUpdateDocument:)]) {
        [self.delegate ftsDocumentAction:self didUpdateDocument:documentPath];
    }
    
    if (!success && [self.delegate respondsToSelector:@selector(ftsDocumentAction:didFailUpdatingDocument:)]) {
        [self.delegate ftsDocumentAction:self didFailUpdatingDocument:documentPath];
    }
}

-(NSString *)actionName {
    return @"Add";
}

@end
