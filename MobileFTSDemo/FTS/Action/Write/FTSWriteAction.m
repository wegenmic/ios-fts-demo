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

@implementation FTSWriteAction

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

-(NSString *)actionName {
    return @"Write";
}

- (NSString *)retrieveContentFromDocument:(NSURL *)documentPath {
    
    NSString *content;
    
    // TODO refactor with configurable Map<filetype,classInstanceToUse>
    NSString *pathExtension = [[documentPath absoluteURL] pathExtension];
    if ([pathExtension isEqualToString:@"xml"]) {
        content = [[[FTSXmlContentExtractor alloc] initWithDocumentPath:documentPath] extractContent];
    }
    else if ([pathExtension isEqualToString:@"xhtml"]) {
        content = [[[FTSXmlContentExtractor alloc] initWithDocumentPath:documentPath] extractContent];
    }
    else if ([pathExtension isEqualToString:@"html"]) {
        content = [[[FTSHtmlContentExtractor alloc] initWithDocumentPath:documentPath] extractContent];
    }
    else if ([pathExtension isEqualToString:@"json"]) {
        content = [[[FTSJsonContentExtractor alloc] initWithDocumentPath:documentPath] extractContent];
    }
    else if ([pathExtension isEqualToString:@"pdf"]) {
        content = [[[FTSPdfContentExtractor alloc] initWithDocumentPath:documentPath] extractContent];
    }
    else
    {
        content = [[[FTSDefaultContentExtractor alloc] initWithDocumentPath:documentPath] extractContent];
    }
    
    NSLog(@"Extracted Content from Document [%@]: [%@]", documentPath, content);
    return content;
}

- (NSString *)retrieveMetadataFromDocument:(NSURL *)documentPath {
    
    NSString *metadata;
    
    // TODO refactor with configurable Map<filetype,classInstanceToUse>
    NSString *pathExtension = [[documentPath absoluteURL] pathExtension];
    if ([pathExtension isEqualToString:@"xml"]) {
        metadata = [[[FTSXmlContentExtractor alloc] initWithDocumentPath:documentPath] extractMetadata];
    }
    else if ([pathExtension isEqualToString:@"xhtml"]) {
        metadata = [[[FTSXmlContentExtractor alloc] initWithDocumentPath:documentPath] extractMetadata];
    }
    else if ([pathExtension isEqualToString:@"html"]) {
        metadata = [[[FTSHtmlContentExtractor alloc] initWithDocumentPath:documentPath] extractMetadata];
    }
    else if ([pathExtension isEqualToString:@"json"]) {
        metadata = [[[FTSJsonContentExtractor alloc] initWithDocumentPath:documentPath] extractMetadata];
    }
    else if ([pathExtension isEqualToString:@"pdf"]) {
        metadata = [[[FTSPdfContentExtractor alloc] initWithDocumentPath:documentPath] extractMetadata];
    }
    else
    {
        metadata = [[[FTSDefaultContentExtractor alloc] initWithDocumentPath:documentPath] extractMetadata];
    }
    
    NSLog(@"Extracted Metadata from Document [%@]: [%@]", documentPath, metadata);
    return metadata;
}

- (BOOL)documentExists:(NSString *)filename inDatabase:(FMDatabase *)database {
    FMResultSet *rs = [database executeQuery:[NSString stringWithFormat:@"SELECT path FROM %@ WHERE path MATCH ?", [self.handler tableName]], filename, nil];
    BOOL exists = [rs next];
    [rs close];
    return exists;
}

@end
