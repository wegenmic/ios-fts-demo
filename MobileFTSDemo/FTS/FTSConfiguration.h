//
//  FTSConfiguration.h
//  MobileAssetFTS
//
//  Created by Michael Wegener on 08/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTSConfiguration : NSObject


// TODO -> Integrate FTS Configuration in current implementation!

// Database
@property (strong, nonatomic) NSString *databasePath;
@property (strong, nonatomic) NSString *tableName;

// Document search
@property (atomic) NSUInteger delayedSearchQueryLength; // x -> delayed search for queries that have less than x characters
@property (atomic) double_t searchDelayInSeconds;

// Queries
@property (strong, nonatomic) NSString *createDatabaseQuery;
@property (strong, nonatomic) NSString *killDatabaseQuery;
@property (strong, nonatomic) NSString *cleanDatabaseQuery;

@property (strong, nonatomic) NSString *addDocumentQuery;
@property (strong, nonatomic) NSString *updateDocumentQuery;
@property (strong, nonatomic) NSString *removeDocumentQuery;
@property (strong, nonatomic) NSString *findDocumentByContentQuery;
@property (strong, nonatomic) NSString *findDocumentByPathQuery;

// Encoding
@property (atomic) NSStringEncoding documentEncoding; // all documents should have the same encoding!

// TODO add more configurable properties!

@end
