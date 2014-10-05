// PDFStringParser.m
// https://gist.github.com/regexident/5a49e11555594bf6ed7e

#import "PDFStringParser.h"

@interface PDFStringParser ()

@property (readwrite, strong, nonatomic) NSURL *fileURL;
@property (readwrite, strong, nonatomic) NSMutableString *pageString;

@end

@implementation PDFStringParser

- (instancetype)initWithFileAtURL:(NSURL *)fileURL {
	NSParameterAssert(fileURL);
	self = [super init];
	if (self) {
		self.fileURL = fileURL;
	}
	return self;
}

- (void)parseWithCallbackBlock:(PDFStringParserPageCallback)callbackBlock {
	NSParameterAssert(callbackBlock);
	CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef)self.fileURL);
	NSAssert(pdf != nil, nil);
	CGPDFDocumentRef document = CGPDFDocumentRetain(pdf);
	CFRelease(pdf);
	CGPDFOperatorTableRef table = CGPDFOperatorTableCreate();
	CGPDFOperatorTableSetCallback(table, "TJ", arrayCallback);
	CGPDFOperatorTableSetCallback(table, "Tj", stringCallback);
	size_t pageCount = CGPDFDocumentGetNumberOfPages(document);
	for (NSUInteger pageIndex = 1; pageIndex <= pageCount; pageIndex++) {
		self.pageString = [NSMutableString string];
		CGPDFPageRef page = CGPDFDocumentGetPage(document, pageIndex);
		CGPDFContentStreamRef stream = CGPDFContentStreamCreateWithPage(page);
		CGPDFScannerRef scanner = CGPDFScannerCreate(stream, table, (__bridge void *)self);
		CGPDFScannerScan(scanner);
		CGPDFScannerRelease(scanner);
		CGPDFContentStreamRelease(stream);
		callbackBlock(pageIndex - 1, self.pageString);
	}
	if (document) {
		CGPDFDocumentRelease(document);
	}
}

@end

void arrayCallback(CGPDFScannerRef inScanner, void *userInfo) {
	PDFStringParser *parser = (__bridge PDFStringParser *)userInfo;
	CGPDFArrayRef array;
	bool success = CGPDFScannerPopArray(inScanner, &array);
	for (size_t n = 0; n < CGPDFArrayGetCount(array); n += 2) {
		if (n >= CGPDFArrayGetCount(array)) {
			continue;
		}
		CGPDFStringRef pdfString;
		success = CGPDFArrayGetString(array, n, &pdfString);
		if (success) {
			NSString *string = (__bridge_transfer NSString *)CGPDFStringCopyTextString(pdfString);
			[parser.pageString appendFormat:@"%@ ", string];
		}
	}
}

void stringCallback(CGPDFScannerRef inScanner, void *userInfo) {
	PDFStringParser *searcher = (__bridge PDFStringParser *)userInfo;
	CGPDFStringRef pdfString;
	bool success = CGPDFScannerPopString(inScanner, &pdfString);
	if (success) {
		NSString *string = (__bridge_transfer NSString *)CGPDFStringCopyTextString(pdfString);
		[searcher.pageString appendFormat:@"%@ ", string];
	}
}