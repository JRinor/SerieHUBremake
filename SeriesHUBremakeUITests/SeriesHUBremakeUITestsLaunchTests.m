//
//  SeriesHUBremakeUITestsLaunchTests.m
//  SeriesHUBremakeUITests
//
//  Created by Rayan Mammeri on 18/10/2024.
//

#import <XCTest/XCTest.h>

@interface SeriesHUBremakeUITestsLaunchTests : XCTestCase

@end

@implementation SeriesHUBremakeUITestsLaunchTests

+ (BOOL)runsForEachTargetApplicationUIConfiguration {
    return YES;
}

- (void)setUp {
    self.continueAfterFailure = NO;
}

- (void)testLaunch {
    // Tester le lancement de l'application

    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // Vérifier que l'application est bien lancée
    XCTAttachment *attachment = [XCTAttachment attachmentWithScreenshot:XCUIScreen.mainScreen.screenshot];
    attachment.name = @"Launch Screen";
    attachment.lifetime = XCTAttachmentLifetimeKeepAlways;
    [self addAttachment:attachment];
}

@end
