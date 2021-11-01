//
//  ios_livevideosdk_quickdemoUITestsLaunchTests.m
//  ios-livevideosdk-quickdemoUITests
//
//  Created by xuefeng on 2021/10/26.
//

#import <XCTest/XCTest.h>

@interface ios_livevideosdk_quickdemoUITestsLaunchTests : XCTestCase

@end

@implementation ios_livevideosdk_quickdemoUITestsLaunchTests

+ (BOOL)runsForEachTargetApplicationUIConfiguration {
    return YES;
}

- (void)setUp {
    self.continueAfterFailure = NO;
}

- (void)testLaunch {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // Insert steps here to perform after app launch but before taking a screenshot,
    // such as logging into a test account or navigating somewhere in the app

    XCTAttachment *attachment = [XCTAttachment attachmentWithScreenshot:XCUIScreen.mainScreen.screenshot];
    attachment.name = @"Launch Screen";
    attachment.lifetime = XCTAttachmentLifetimeKeepAlways;
    [self addAttachment:attachment];
}

@end
