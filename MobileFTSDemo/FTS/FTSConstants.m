//
//  FTSConfiguration.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 08/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSConstants.h"

@implementation FTSConstants

// Database
NSString* const databasePath = @"UserDatabase.sqlite";
NSString* const tableName = @"nfsdocuments";
NSString* const tableIdColumn = @"path";
NSString* const tableMetadataColumn = @"keywords";
NSString* const tableContentColumn = @"content";

// Document search
NSUInteger const delayedSearchQueryLength = 3;
double_t const searchDelayInSeconds = 1.0;

// Queries
NSString* const createDatabaseQuery = @"CREATE VIRTUAL TABLE IF NOT EXISTS %@ USING fts4(path, keywords, content)";
NSString* const killDatabaseQuery = @"DROP TABLE %@";
NSString* const cleanDatabaseQuery = @"DELETE FROM %@";

NSString* const addDocumentQuery = @"INSERT INTO %@(path, keywords, content) VALUES(?, ?, ?)";
NSString* const updateDocumentQuery = @"UPDATE %@ SET keywords = ?, content = ? WHERE path = ?";
NSString* const removeDocumentQuery = @"DELETE FROM %@ WHERE path = ?";
NSString* const findAllDocumentsQuery = @"SELECT path FROM %@";
NSString* const findDocumentByContentQuery = @"SELECT path FROM %@ WHERE content MATCH ?";
NSString* const findDocumentByPathQuery = @"SELECT path FROM %@ WHERE path = ?";

@end
