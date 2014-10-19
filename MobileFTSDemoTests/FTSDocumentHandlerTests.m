//
//  FTSDocumentHandlertests.m
//  MobileFTSDemo
//
//  Created by Michael Wegener on 19/10/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <AGAsyncTestHelper/AGAsyncTestHelper.h>
#import "FTSDocumentHandler.h"
#import "FTSDatabaseHandler.h"
#import "FTSFindDocumentAction.h"
#import "FTSRemoveDocumentAction.h"
#import "FTSAddDocumentAction.h"

@interface FTSDocumentHandlerTests : XCTestCase

@property (strong, nonatomic) FTSDatabaseHandler *dbHandler;
@property (strong, nonatomic) FTSDocumentHandler *docHandler;
@property (strong, nonatomic) NSURL *plaintextFileUrl;
@property (strong, nonatomic) NSMutableArray *removedDocuments;
@property (strong, nonatomic) NSMutableArray *updatedDocuments;
@property (strong, nonatomic) NSMutableArray *addedDocuments;
@property (strong, nonatomic) NSMutableArray *foundDocuments;

@end

@implementation FTSDocumentHandlerTests

- (void)setUp {
    [super setUp];
    NSString *targetDatabasePath = @"TestUserDatabase.sqlite";
    self.docHandler = [FTSDocumentHandler sharedFTSDocumentHandlerWithDelegate:self];
    self.dbHandler = [FTSDatabaseHandler sharedFTSDatabaseHandler];
    self.dbHandler.workingDatabasePath = targetDatabasePath;
    
    [self.dbHandler prepareDatabaseConnection];
    [self.dbHandler prepareDatabase];
    
    
    self.plaintextFileUrl = [[NSBundle mainBundle] URLForResource:@"document" withExtension:@"txt"];
    
    self.removedDocuments = [NSMutableArray array];
    self.updatedDocuments = [NSMutableArray array];
    self.addedDocuments = [NSMutableArray array];
    self.foundDocuments = [NSMutableArray array];
}

- (void)tearDown {
    [super tearDown];
    [self.dbHandler cleanDatabase];
    [self.dbHandler deleteDatabase];
}

- (void)testShouldAddDocument {
    XCTAssertEqual(0, [self.addedDocuments count], @"no document should have been added at the beginning of the test");
    [self.docHandler addDocument:self.plaintextFileUrl];
    
    AGWW_WAIT_WHILE([self.addedDocuments count] != 1, 1);
}

- (void)testShouldAddDocuments {
    XCTAssertEqual(0, [self.addedDocuments count], @"no document should have been added at the beginning of the test");
    [self.docHandler addDocuments:[NSArray arrayWithObject:self.plaintextFileUrl]];
    
    AGWW_WAIT_WHILE([self.addedDocuments count] != 1, 1);
}

- (void)testShouldUpdateDocument {
    XCTAssertEqual(0, [self.updatedDocuments count], @"no document should have been updated at the beginning of the test");
    [self.docHandler addDocument:self.plaintextFileUrl];
    [self.docHandler addDocument:self.plaintextFileUrl];
    AGWW_WAIT_WHILE([self.updatedDocuments count] != 1, 1);
}

- (void)testShouldUpdateDocuments {
    XCTAssertEqual(0, [self.updatedDocuments count], @"no document should have been updated at the beginning of the test");
    [self.docHandler addDocuments:[NSArray arrayWithObject:self.plaintextFileUrl]];
    [self.docHandler addDocuments:[NSArray arrayWithObject:self.plaintextFileUrl]];
    AGWW_WAIT_WHILE([self.updatedDocuments count] != 1, 1);
}

- (void)testShouldRemoveDocument {
    XCTAssertEqual(0, [self.updatedDocuments count], @"no document should have been removed at the beginning of the test");
    [self.docHandler addDocument:self.plaintextFileUrl];
    [self.docHandler removeDocument:self.plaintextFileUrl];
    AGWW_WAIT_WHILE([self.removedDocuments count] != 1, 1);
}

- (void)testShouldRemoveDocuments {
    XCTAssertEqual(0, [self.updatedDocuments count], @"no document should have been removed at the beginning of the test");
    [self.docHandler addDocuments:[NSArray arrayWithObject:self.plaintextFileUrl]];
    [self.docHandler removeDocuments:[NSArray arrayWithObject:self.plaintextFileUrl]];
    AGWW_WAIT_WHILE([self.removedDocuments count] != 1, 1);
}

- (void)testShouldFindDocuments {
    XCTAssertEqual(0, [self.foundDocuments count], @"no document should have been found at the beginning of the test");
    [self.docHandler addDocument:self.plaintextFileUrl];
    
    AGWW_WAIT_WHILE([self.addedDocuments count] != 1, 1);
    
    [self.docHandler findDocuments:@"universal"];
    
    AGWW_WAIT_WHILE([self.foundDocuments count] != 1, 1);
}

-(void)ftsDocumentAction:(FTSFindDocumentAction *)action didFindDocuments:(NSArray *)documentPaths forSearch:(NSString *)query
{
    [self.foundDocuments addObject:documentPaths];
}

-(void)ftsDocumentAction:(FTSRemoveDocumentAction *)action didRemoveDocument:(NSURL *)pathToDocument
{
   [self.removedDocuments addObject:pathToDocument];
}

-(void)ftsDocumentAction:(FTSAddDocumentAction *)action didAddDocument:(NSURL *)pathToDocument
{
    [self.addedDocuments addObject:pathToDocument];
}

-(void)ftsDocumentAction:(FTSAddDocumentAction *)action didUpdateDocument:(NSURL *)pathToDocument
{
    [self.updatedDocuments addObject:pathToDocument];
}

@end
