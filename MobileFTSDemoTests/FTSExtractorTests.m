//
//  FTSExtractorTests.m
//  MobileFTSDemo
//
//  Created by Michael Wegener on 19/10/14.
//  Copyright (c) 2014 Namics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FTSContentExtractor.h"
#import "FTSDefaultContentExtractor.h"
#import "FTSXmlContentExtractor.h"
#import "FTSHtmlContentExtractor.h"
#import "FTSPdfContentExtractor.h"
#import "FTSJsonContentExtractor.h"

@interface FTSExtractorTests : XCTestCase

@property (strong, nonatomic) NSURL *plaintextFileUrl;
@property (strong, nonatomic) NSURL *htmlFileUrl;
@property (strong, nonatomic) NSURL *jsonFileUrl;
@property (strong, nonatomic) NSURL *pdfFileUrl;
@property (strong, nonatomic) NSURL *xmlFileUrl;

@end

@implementation FTSExtractorTests

- (void)setUp {
    [super setUp];
    self.plaintextFileUrl = [[NSBundle mainBundle] URLForResource:@"document" withExtension:@"txt"];
    self.htmlFileUrl = [[NSBundle mainBundle] URLForResource:@"css_zen_garden" withExtension:@"html"];
    self.jsonFileUrl = [[NSBundle mainBundle] URLForResource:@"sample" withExtension:@"json"];
    self.pdfFileUrl = [[NSBundle mainBundle] URLForResource:@"example" withExtension:@"pdf"];
    self.xmlFileUrl = [[NSBundle mainBundle] URLForResource:@"books" withExtension:@"xml"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExtractContentShouldFailOnContentExtractor {
    FTSContentExtractor *extractor = [[FTSContentExtractor alloc] initWithDocumentPath:self.plaintextFileUrl];
    XCTAssertThrowsSpecific([extractor extractContent], NSException, @"should throw an exception");
}

- (void)testextractMetadataShouldFailOnContentExtractor {
    FTSContentExtractor *extractor = [[FTSContentExtractor alloc] initWithDocumentPath:self.plaintextFileUrl];
    XCTAssertThrowsSpecific([extractor extractMetadata], NSException, @"should throw an exception");
}

- (void)testShouldExtractContentOnDefaultContentExtractor {
    FTSDefaultContentExtractor *extractor = [[FTSDefaultContentExtractor alloc] initWithDocumentPath:self.plaintextFileUrl];
    NSString *content = [extractor extractContent];
    NSRange range = [content rangeOfString:@"ownCloud" options:0];
    XCTAssertTrue(range.location != NSNotFound, "should process plaintext content");
}

- (void)testShouldExtractMetadataOnDefaultContentExtractor {
    FTSDefaultContentExtractor *extractor = [[FTSDefaultContentExtractor alloc] initWithDocumentPath:self.plaintextFileUrl];
    NSString *content = [extractor extractMetadata];
    XCTAssertTrue([content isEqualToString:@"filetype_txt"], "should process plaintext metadata");
}

- (void)testShouldExtractContentOnHtmlContentExtractor {
    FTSHtmlContentExtractor *extractor = [[FTSHtmlContentExtractor alloc] initWithDocumentPath:self.htmlFileUrl];
    NSString *content = [extractor extractContent];
    NSRange range = [content rangeOfString:@"CSS Zen Garden: The Beauty of CSS Design" options:0];
    XCTAssertTrue(range.location != NSNotFound, "should process html content");
}

- (void)testShouldExtractMetadataOnHtmlContentExtractor {
    FTSHtmlContentExtractor *extractor = [[FTSHtmlContentExtractor alloc] initWithDocumentPath:self.htmlFileUrl];
    NSString *content = [extractor extractMetadata];
    XCTAssertTrue([content isEqualToString:@"filetype_html"], "should process html metadata");
}

- (void)testShouldExtractContentOnJsonContentExtractor {
    FTSJsonContentExtractor *extractor = [[FTSJsonContentExtractor alloc] initWithDocumentPath:self.jsonFileUrl];
    NSString *content = [extractor extractContent];
    NSRange range = [content rangeOfString:@"540e09b7db36d348867d8d57" options:0];
    XCTAssertTrue(range.location != NSNotFound, "should process json content");
}

- (void)testShouldExtractMetadataOnJsonContentExtractor {
    FTSJsonContentExtractor *extractor = [[FTSJsonContentExtractor alloc] initWithDocumentPath:self.jsonFileUrl];
    NSString *content = [extractor extractMetadata];
    XCTAssertTrue([content isEqualToString:@"filetype_json"], "should process json metadata");
}

- (void)testShouldExtractContentOnPdfContentExtractor {
    FTSPdfContentExtractor *extractor = [[FTSPdfContentExtractor alloc] initWithDocumentPath:self.pdfFileUrl];
    NSString *content = [extractor extractContent];
    NSLog(@"pdf content: %@", content);
    NSRange range = [content rangeOfString:@"Adobe PDF/" options:0];
    XCTAssertTrue(range.location != NSNotFound, "should process pdf content");
}

- (void)testShouldExtractMetadataOnPdfContentExtractor {
    FTSPdfContentExtractor *extractor = [[FTSPdfContentExtractor alloc] initWithDocumentPath:self.pdfFileUrl];
    NSString *content = [extractor extractMetadata];
    XCTAssertTrue([content isEqualToString:@"filetype_pdf"], "should process pdf metadata");
}

- (void)testShouldExtractContentOnXmlContentExtractor {
    FTSDefaultContentExtractor *extractor = [[FTSDefaultContentExtractor alloc] initWithDocumentPath:self.xmlFileUrl];
    NSString *content = [extractor extractContent];
    NSRange range = [content rangeOfString:@"Gambardella, Matthew" options:0];
    XCTAssertTrue(range.location != NSNotFound, "should process xml content");
}

- (void)testShouldExtractMetadataOnXmlContentExtractor {
    FTSDefaultContentExtractor *extractor = [[FTSDefaultContentExtractor alloc] initWithDocumentPath:self.xmlFileUrl];
    NSString *content = [extractor extractMetadata];
    XCTAssertTrue([content isEqualToString:@"filetype_xml"], "should process xml metadata");
}



@end
