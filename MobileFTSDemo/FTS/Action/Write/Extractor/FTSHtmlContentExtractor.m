//
//  FTSHtmlContentExtractor.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 09/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSHtmlContentExtractor.h"
#import "TFHpple.h"

@implementation FTSHtmlContentExtractor


#pragma mark - public

-(NSString *)extractContent {
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:self.data];
    NSArray *elements = [hpple searchWithXPathQuery:@"//text()"];
    
    return [self extractHtmlFromElements:elements];
}

-(NSString *)extractMetadata {
    // TODO should add Tag names as metadata?
    return [[NSString alloc] initWithFormat:@"filetype_%@", [self.documentPath pathExtension]];
}


#pragma mark - private

-(NSString *)extractHtmlFromElements:(NSArray *)elements {
    NSMutableString* content = [[NSMutableString alloc] init];
    
    for (TFHppleElement *element in elements) {
        NSArray *children = [element children];
        if ([children count] > 0) {
            [content appendString:[self extractHtmlFromElements:children]];
        }
        
        [content appendString:[element content]];
    }
    return content;
}
@end
