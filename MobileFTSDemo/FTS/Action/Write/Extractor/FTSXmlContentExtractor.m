//
//  FTSXmlContentExtractor.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 08/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSXmlContentExtractor.h"

@implementation FTSXmlContentExtractor

-(NSString *)extractContent {
    self.content = [[NSMutableString alloc] init];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.data];
    [parser setDelegate:self];
    BOOL successful = [parser parse];
    
    if(successful) {
        return self.content;
    } else {
        // TODO add error handling
        NSLog(@"Could not parse Document [%@]", self.documentPath);
        return @"";
    }
}

-(NSString *)extractMetadata {
    // TODO should add Tag names as metadata?
    return [[NSString alloc] initWithFormat:@"filetype_%@", [self.documentPath pathExtension]];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self.content appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    // TODO handle parse error
    NSLog(@"parseErrorOccurred: %@", parseError);
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    // TODO handle validation error
    NSLog(@"validationErrorOccurred: %@", validationError);
}


@end
