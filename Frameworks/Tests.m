#import <XCTest/XCTest.h>

@import GCDWebServer;

#pragma clang diagnostic ignored "-Weverything"  // Prevent "messaging to unqualified id" warnings

@interface Tests : XCTestCase
@end

@interface GCDWebUploader (Tests)
- (GCDWebServerResponse*)uploadFile:(GCDWebServerMultiPartFormRequest*)request;
@end

@implementation Tests

- (void)testWebServer {
  GCDWebServer* server = [[GCDWebServer alloc] init];
  XCTAssertNotNil(server);
}

- (void)testDAVServer {
  GCDWebDAVServer* server = [[GCDWebDAVServer alloc] init];
  XCTAssertNotNil(server);
}

- (void)testWebUploader {
  GCDWebUploader* server = [[GCDWebUploader alloc] init];
  XCTAssertNotNil(server);
}

- (void)testWebUploaderRejectsRequestWithoutFile {
  GCDWebUploader* server = [[GCDWebUploader alloc] initWithUploadDirectory:NSTemporaryDirectory()];
  NSURL* url = [NSURL URLWithString:@"http://localhost/upload"];
  NSDictionary* headers = @{
    @"Accept" : @"application/json",
    @"Content-Type" : @"multipart/form-data; boundary=boundary"
  };
  GCDWebServerMultiPartFormRequest* request = [[GCDWebServerMultiPartFormRequest alloc] initWithMethod:@"POST" url:url headers:headers path:@"/upload" query:@{}];

  GCDWebServerResponse* response = [server uploadFile:request];

  XCTAssertEqual(response.statusCode, kGCDWebServerHTTPStatusCode_BadRequest);
}

- (void)testPaths {
  XCTAssertEqualObjects(GCDWebServerNormalizePath(@""), @"");
  XCTAssertEqualObjects(GCDWebServerNormalizePath(@"/foo/"), @"/foo");
  XCTAssertEqualObjects(GCDWebServerNormalizePath(@"foo/bar"), @"foo/bar");
  XCTAssertEqualObjects(GCDWebServerNormalizePath(@"foo//bar"), @"foo/bar");
  XCTAssertEqualObjects(GCDWebServerNormalizePath(@"foo/bar//"), @"foo/bar");
  XCTAssertEqualObjects(GCDWebServerNormalizePath(@"foo/./bar"), @"foo/bar");
  XCTAssertEqualObjects(GCDWebServerNormalizePath(@"foo/bar/."), @"foo/bar");
  XCTAssertEqualObjects(GCDWebServerNormalizePath(@"foo/../bar"), @"bar");
  XCTAssertEqualObjects(GCDWebServerNormalizePath(@"/foo/../bar"), @"/bar");
  XCTAssertEqualObjects(GCDWebServerNormalizePath(@"/foo/.."), @"/");
  XCTAssertEqualObjects(GCDWebServerNormalizePath(@"/.."), @"/");
  XCTAssertEqualObjects(GCDWebServerNormalizePath(@"."), @"");
  XCTAssertEqualObjects(GCDWebServerNormalizePath(@".."), @"");
  XCTAssertEqualObjects(GCDWebServerNormalizePath(@"../.."), @"");
}

@end
