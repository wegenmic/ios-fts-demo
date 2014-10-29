//
//  FTSConfiguration.h
//  MobileAssetFTS
//
//  Created by Michael Wegener on 08/09/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTSConstants : NSObject


#pragma mark - database

extern NSString* const DATABASE_PATH;
extern NSString* const TABLE_NAME;
extern NSString* const TABLE_ID_COLUMN;
extern NSString* const TABLE_METADATA_COLUMN;
extern NSString* const TABLE_CONTENT_COLUMN;


#pragma mark - document search

extern NSUInteger const DELAYED_SEARCH_QUERY_LENGTH;
extern double_t const SEARCH_DELAY_IN_SECONDS;


#pragma mark - database queries

extern NSString* const CREATE_DATABASE_QUERY;
extern NSString* const DROP_TABLE_DATABASE_QUERY;
extern NSString* const CLEAN_DATABASE_QUERY;

extern NSString* const ADD_DOCUMENT_QUERY;
extern NSString* const UPDATE_DOCUMENT_QUERY;
extern NSString* const REMOVE_DOCUMENT_QUERY;
extern NSString* const FIND_ALL_DOCUMENTS_QUERY;
extern NSString* const FIND_DOCUMENTS_BY_CONTENT_QUERY;
extern NSString* const FIND_DOCUMENT_BY_PATH_QUERY;

@end
