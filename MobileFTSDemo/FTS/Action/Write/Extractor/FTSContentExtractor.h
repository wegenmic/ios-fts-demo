//
//  FTSContentExtractor.h
//  MobileAssetFTS
//
//  Created by Michael Wegener on 08/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTSContentExtractor : NSObject

@property (strong, nonatomic) NSURL *documentPath;
@property (strong, nonatomic) NSData *data;

-(instancetype)initWithDocumentPath:(NSURL *)documentPath;
-(NSString *)extractContent;
-(NSString *)extractMetadata;

@end
