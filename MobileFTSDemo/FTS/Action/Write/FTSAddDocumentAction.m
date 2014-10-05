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
    
    if(input.documentPath == nil) {
        [self notifyAddDelegate:success forDocument:input.documentPath];
        return;
    }
    
    NSString *content = [self retrieveContentFromDocument:input.documentPath];
    NSString *metadata = [self retrieveMetadataFromDocument:input.documentPath];
    
    if ([self documentExists:input.documentPath inDatabase:input.database]) {
        // UPDATE - document exists.
        success = [input.database executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET keywords = ?, content = ? WHERE path = ?", [self.handler tableName]], metadata, content, input.documentPath,  nil];
        [self notifyUpdateDelegate:success forDocument:input.documentPath];
    } else {
        // ADD - document does not exist yet.
        success = [input.database executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@(path, keywords, content) VALUES(?, ?, ?)", [self.handler tableName]], input.documentPath, metadata, content, nil];
        [self notifyAddDelegate:success forDocument:input.documentPath];
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
