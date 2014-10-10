//
//  FTSRemoveDocumentAction.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSRemoveDocumentAction.h"

@implementation FTSRemoveDocumentAction

+ (FTSRemoveDocumentAction *)sharedFTSRemoveDocumentActionWithDelegate:(id)delegate {
    static FTSRemoveDocumentAction *_shareFTSRemoveDocumentAction = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareFTSRemoveDocumentAction = [[self alloc] init];
    });
    _shareFTSRemoveDocumentAction.delegate = delegate;
    
    return _shareFTSRemoveDocumentAction;
}

- (void)action:(FTSWriteActionData *)input {
    BOOL success = [input.database executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE path = ?", [self.handler tableName]], input.filename, nil];
    [self notifyDelegate:success forDocument:input.originDocumentPath];
}

- (void)notifyDelegate:(BOOL)success forDocument:(NSURL *)documentPath {
    if (success && [self.delegate respondsToSelector:@selector(ftsDocumentAction:didRemoveDocument:)]) {
        [self.delegate ftsDocumentAction:self didRemoveDocument:documentPath];
    }
    
    if (!success && [self.delegate respondsToSelector:@selector(ftsDocumentAction:didFailRemovingDocument:)]) {
        [self.delegate ftsDocumentAction:self didFailRemovingDocument:documentPath];
    }
}

-(NSString *)actionName {
    return @"Remove";
}

@end
