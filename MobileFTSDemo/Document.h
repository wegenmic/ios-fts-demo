//
//  Document.h
//  MobileAssetFTS
//
//  Created by Michael Wegener on 05/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Document : NSObject

@property (strong, nonatomic) NSURL *path;
@property (strong, nonatomic) NSString *title;

- (instancetype)initWithPath:(NSURL *)path;

@end
