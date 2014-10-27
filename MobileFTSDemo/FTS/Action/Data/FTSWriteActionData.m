//
//  FTSWriteActionData.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSWriteActionData.h"

@implementation FTSWriteActionData

- (instancetype)initWithDocumentPath:(NSURL *)documentPath {
    self.originDocumentPath = documentPath;
    self.filename = [self copyToDocumentsDir:documentPath];
    return self;
}

- (NSString *)copyToDocumentsDir:(NSURL *)documentPath {
    NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *newDocumentPath = [documentsFolder stringByAppendingPathComponent:[documentPath lastPathComponent]];
    self.targetDocumentPath = [NSURL fileURLWithPath:newDocumentPath];
    if([self.targetDocumentPath isEqual:documentPath]) {
        // do not copy if the document is already in the documents folder
        return [documentPath lastPathComponent];
    }
    
    NSError *err = nil;
    [[NSFileManager defaultManager] removeItemAtURL:self.targetDocumentPath error:nil];
    [[NSFileManager defaultManager] copyItemAtURL:documentPath toURL:self.targetDocumentPath error:&err];
    if (err) {
        NSLog(@"Error occured when copying file: %@",err);
    }
    return [self.targetDocumentPath lastPathComponent];
}

@end
