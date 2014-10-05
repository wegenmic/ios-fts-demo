//
//  FTSXmlContentExtractor.h
//  MobileAssetFTS
//
//  Created by Michael Wegener on 08/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSContentExtractor.h"

@interface FTSXmlContentExtractor : FTSContentExtractor <NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableString *content;

@end
