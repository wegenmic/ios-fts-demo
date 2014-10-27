//
//  FTSPdfContentExtractor.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 08/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSPdfContentExtractor.h"
#import "PDFStringParser.h"

@implementation FTSPdfContentExtractor


#pragma mark - public

-(NSString *)extractContent {
    NSMutableString* content = [[NSMutableString alloc] init];
    PDFStringParser *parser = [[PDFStringParser alloc] initWithFileAtURL:self.documentPath];
    [parser parseWithCallbackBlock:^void (NSUInteger pageIndex, NSString *pageString) {
        [content appendString:pageString];
    }];

    return content;
}

-(NSString *)extractMetadata {
    // TODO what metadata to add?
    return [[NSString alloc] initWithFormat:@"filetype_%@", [self.documentPath pathExtension]];
}

@end
