//
//  FTSWriteAction.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSWriteAction.h"
#import "FTSDefaultContentExtractor.h"
#import "FTSXmlContentExtractor.h"
#import "FTSHtmlContentExtractor.h"
#import "FTSPdfContentExtractor.h"
#import "FTSJsonContentExtractor.h"
#import "FTSConstants.h"

@implementation FTSWriteAction


#pragma mark - public

- (void)write:(NSURL *)documentPath {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        NSDate *start = [NSDate date];
        FTSWriteActionData *writeActionData = [[FTSWriteActionData alloc] initWithDocumentPath:documentPath];
        [[self.handler writeQueue] addOperationWithBlock:^{
            [[self.handler writeQueueLock] lock];
            [[self.handler queue] inDatabase:^(FMDatabase *database) {
                writeActionData.database = database;
                [self action:writeActionData];
            }];
            [[self.handler writeQueueLock] unlock];
        }];
        NSDate *end = [NSDate date];
        NSTimeInterval executionTime = [end timeIntervalSinceDate:start];
        NSLog(@"%@ Document [%@] took %f s", self.actionName, writeActionData.filename, executionTime);
    });
}

- (void)action:(FTSWriteActionData *)input {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}


#pragma mark - private

-(NSString *)actionName {
    return @"Write";
}

- (BOOL)documentExists:(NSString *)filename inDatabase:(FMDatabase *)database {
    FMResultSet *rs = [database executeQuery:[NSString stringWithFormat:FIND_DOCUMENT_BY_PATH_QUERY, TABLE_NAME], filename, nil];
    BOOL exists = [rs next];
    [rs close];
    return exists;
}


#pragma mark - content retrieval

- (NSString *)retrieveContentFromDocument:(NSURL *)documentPath {
    
    FTSContentExtractor *extractor = [self retrieveContentExtractorFromDocumentPath:documentPath];
    NSString *content = [extractor extractContent];
    
    NSLog(@"Extracted Content from Document [%@]: [%@]", documentPath, content);
    return content;
}

- (NSString *)retrieveMetadataFromDocument:(NSURL *)documentPath {
    
    FTSContentExtractor *extractor = [self retrieveContentExtractorFromDocumentPath:documentPath];
    NSString *metadata = [extractor extractMetadata];
    
    NSLog(@"Extracted Metadata from Document [%@]: [%@]", documentPath, metadata);
    return metadata;
}

- (FTSContentExtractor *)retrieveContentExtractorFromDocumentPath:(NSURL *)documentPath {
    NSString *pathExtension = [[documentPath absoluteURL] pathExtension];
    
    if ([pathExtension isEqualToString:@"xml"]) {
        return [[FTSXmlContentExtractor alloc] initWithDocumentPath:documentPath];
    }
    else if ([pathExtension isEqualToString:@"xhtml"]) {
        return [[FTSXmlContentExtractor alloc] initWithDocumentPath:documentPath];
    }
    else if ([pathExtension isEqualToString:@"html"]) {
        return [[FTSHtmlContentExtractor alloc] initWithDocumentPath:documentPath];
    }
    else if ([pathExtension isEqualToString:@"json"]) {
        return [[FTSJsonContentExtractor alloc] initWithDocumentPath:documentPath];
    }
    else if ([pathExtension isEqualToString:@"pdf"]) {
        return [[FTSPdfContentExtractor alloc] initWithDocumentPath:documentPath];
    }
    else
    {
        return [[FTSDefaultContentExtractor alloc] initWithDocumentPath:documentPath];
    }
}

@end
