//
//  FTSConfiguration.h
//  MobileAssetFTS
//
//  Created by Michael Wegener on 08/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTSConstants : NSObject

// Database
extern NSString* const databasePath;
extern NSString* const tableName;
extern NSString* const tableIdColumn;
extern NSString* const tableMetadataColumn;
extern NSString* const tableContentColumn;

// Document search
extern NSUInteger const delayedSearchQueryLength; // x -> delayed search for queries that have less than x characters
extern double_t const searchDelayInSeconds;

// Queries
extern NSString* const createDatabaseQuery;
extern NSString* const dropTableDatabaseQuery;
extern NSString* const cleanDatabaseQuery;

extern NSString* const addDocumentQuery;
extern NSString* const updateDocumentQuery;
extern NSString* const removeDocumentQuery;
extern NSString* const findAllDocumentsQuery;
extern NSString* const findDocumentByContentQuery;
extern NSString* const findDocumentByPathQuery;

@end
