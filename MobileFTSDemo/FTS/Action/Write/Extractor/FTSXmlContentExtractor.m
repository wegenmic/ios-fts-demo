//
//  FTSXmlContentExtractor.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 08/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSXmlContentExtractor.h"

@implementation FTSXmlContentExtractor


#pragma mark - public

-(NSString *)extractContent {
    self.content = [[NSMutableString alloc] init];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.data];
    [parser setDelegate:self];
    BOOL successful = [parser parse];
    
    if(successful) {
        return self.content;
    } else {
        NSLog(@"Could not XML parse Document [%@]", self.documentPath);
        [NSException raise:NSParseErrorException
                    format:@"Could not XML parse Document [%@]", self.documentPath];
        return NULL;
    }
}

-(NSString *)extractMetadata {
    return [[NSString alloc] initWithFormat:@"filetype_%@", [self.documentPath pathExtension]];
}


#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self.content appendString:string];
}

@end
