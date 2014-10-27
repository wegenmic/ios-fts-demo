//
//  FTSDocumentHandler.h
//  MobileAssetFTS
//
//  Created by Michael Wegener on 04/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSDocumentHandler.h"
#import "FTSAddDocumentAction.h"
#import "FTSRemoveDocumentAction.h"
#import "FTSFindDocumentAction.h"

@implementation FTSDocumentHandler

+ (FTSDocumentHandler *)sharedFTSDocumentHandlerWithDelegate:(id)delegate {
    static FTSDocumentHandler *_shareFTSDocumentHandler = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareFTSDocumentHandler = [[self alloc] init];
    });
    _shareFTSDocumentHandler.delegate = delegate;
    
    return _shareFTSDocumentHandler;
}


#pragma mark - find documents

- (void)findDocuments:(NSString *)searchText {
    FTSReadAction* action = [FTSFindDocumentAction sharedFTSFindDocumentActionWithDelegate:self.delegate];
    [action find:searchText];
}

- (void)findDocuments:(NSString *)searchText withFacets:(NSArray *)facets {
    FTSReadAction* action = [FTSFindDocumentAction sharedFTSFindDocumentActionWithDelegate:self.delegate];
    [action find:searchText withFacets:facets];
}

#pragma mark - add documents

- (void)addDocument:(NSURL *)documentPath {
    FTSWriteAction* action = [FTSAddDocumentAction sharedFTSAddDocumentActionWithDelegate:self.delegate];
    [action write:documentPath];
}

- (void)addDocuments:(NSArray *)documentPaths {
    for (NSURL *documentPath in documentPaths) {
        [self addDocument:documentPath];
    }
}

#pragma mark - remove documents

- (void)removeDocument:(NSURL *)documentPath {
    FTSWriteAction* action = [FTSRemoveDocumentAction sharedFTSRemoveDocumentActionWithDelegate:self.delegate];
    [action write:documentPath];
}

- (void)removeDocuments:(NSArray *)documentPaths {
    for (NSURL *documentPath in documentPaths) {
        [self removeDocument:documentPath];
    }
}

#pragma mark - remove documents without delegate callback

- (void)removeAllDocuments {
    // Access the handler directly to access its helper method.
    // Therefore no delegate callback.
    FTSWriteAction* action = [FTSRemoveDocumentAction sharedFTSRemoveDocumentActionWithDelegate:self.delegate];
    [action.handler cleanDatabase];
}

@end
