//
//  FTSConfiguration.m
//  MobileAssetFTS
//
//  Created by Michael Wegener on 08/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import "FTSConstants.h"

@implementation FTSConstants


#pragma mark - database

NSString* const DATABASE_PATH = @"UserDatabase.sqlite";
NSString* const TABLE_NAME = @"nfsdocuments";
NSString* const TABLE_ID_COLUMN = @"path";
NSString* const TABLE_METADATA_COLUMN = @"keywords";
NSString* const TABLE_CONTENT_COLUMN = @"content";


#pragma mark - document search

NSUInteger const DELAYED_SEARCH_QUERY_LENGTH = 3; // x -> delayed search for queries that have x or less characters
double_t const SEARCH_DELAY_IN_SECONDS = 1.0;


#pragma mark - database queries

NSString* const CREATE_DATABASE_QUERY = @"CREATE VIRTUAL TABLE IF NOT EXISTS %@ USING fts4(path, keywords, content)";
NSString* const DROP_TABLE_DATABASE_QUERY = @"DROP TABLE %@";
NSString* const CLEAN_DATABASE_QUERY = @"DELETE FROM %@";

NSString* const ADD_DOCUMENT_QUERY = @"INSERT INTO %@(path, keywords, content) VALUES(?, ?, ?)";
NSString* const UPDATE_DOCUMENT_QUERY = @"UPDATE %@ SET keywords = ?, content = ? WHERE path = ?";
NSString* const REMOVE_DOCUMENT_QUERY = @"DELETE FROM %@ WHERE path = ?";
NSString* const FIND_ALL_DOCUMENTS_QUERY = @"SELECT path FROM %@";
NSString* const FIND_DOCUMENTS_BY_CONTENT_QUERY = @"SELECT path FROM %@ WHERE content MATCH ?";
NSString* const FIND_DOCUMENT_BY_PATH_QUERY = @"SELECT path FROM %@ WHERE path = ?";

@end
