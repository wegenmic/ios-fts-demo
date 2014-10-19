//
//  FTSQueryPreprocessor.m
//  MobileFTSDemo
//
//  Created by Michael Wegener on 19/10/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FTSQueryPreprocessor.h"

@interface FTSQueryPreprocessorTests : XCTestCase

@end

@implementation FTSQueryPreprocessorTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testShouldProcessQuery {
    NSString *query = @"Test Query";
    FTSQueryPreprocessor *processor = [[FTSQueryPreprocessor alloc] init];
    NSString *processedQuery = [processor processQuery:query];
    XCTAssert([processedQuery isEqualToString:@"Test* Query* "], @"Pass");
}

- (void)testShouldProcessEmptyQuery {
    NSString *query = @"";
    FTSQueryPreprocessor *processor = [[FTSQueryPreprocessor alloc] init];
    NSString *processedQuery = [processor processQuery:query];
    XCTAssert([processedQuery isEqualToString:query], @"Pass");
}

@end
