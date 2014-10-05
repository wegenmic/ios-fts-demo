// PDFStringParser.h
// https://gist.github.com/regexident/5a49e11555594bf6ed7e

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

void arrayCallback(CGPDFScannerRef inScanner, void *userInfo);
void stringCallback(CGPDFScannerRef inScanner, void *userInfo);

typedef void (^PDFStringParserPageCallback)(NSUInteger pageIndex, NSString *pageString);

@interface PDFStringParser : NSObject

@property (readonly, strong, nonatomic) NSURL *fileURL;

- (instancetype)initWithFileAtURL:(NSURL *)fileURL;
- (void)parseWithCallbackBlock:(PDFStringParserPageCallback)callbackBlock;
    
@end