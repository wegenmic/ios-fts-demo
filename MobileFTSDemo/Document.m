//
//  Document.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "Document.h"

@implementation Document

- (instancetype)initWithPath:(NSURL *)path {
    self.path = path;
    self.title = [[[path absoluteString] componentsSeparatedByString:@"/"] lastObject];
    
    return self;
}

@end
