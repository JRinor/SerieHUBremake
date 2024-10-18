//
//  SeriesHUBremakeUITests.m
//  SeriesHUBremakeUITests
//
//  Created by Rayan Mammeri on 18/10/2024.
//

#import <XCTest/XCTest.h>

@interface SeriesHUBremakeUITests : XCTestCase

@end

@implementation SeriesHUBremakeUITests

- (void)setUp {
    // Mettre en place le code ici. Cette méthode est appelée avant chaque test de la classe.
    self.continueAfterFailure = NO;

    // Lancer l'application pour chaque test.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
}

- (void)tearDown {
    // Mettre le code de nettoyage ici. Cette méthode est appelée après chaque test de la classe.
}



- (void)testTrendingSeriesSectionExists {
    // Vérifier que la section des "Tendances" est bien visible

    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    // Attendre que la section "Tendances" apparaisse
    XCUIElement *trendingSection = app.staticTexts[@"Tendances"];
    XCTAssertTrue([trendingSection waitForExistenceWithTimeout:5]);
}

- (void)testTopRatedSeriesSectionExists {
    // Vérifier que la section des "Les mieux notées" est visible

    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    // Attendre que la section "Les mieux notées" apparaisse
    XCUIElement *topRatedSection = app.staticTexts[@"Les mieux notées"];
    XCTAssertTrue([topRatedSection waitForExistenceWithTimeout:5]);
}

- (void)testSeriesPlatformsSectionExists {
    // Vérifier l'affichage des plateformes (Disney+, Netflix, etc.)

    XCUIApplication *app = [[XCUIApplication alloc] init];

    // Vérifier que la section "Disney+" est visible
    XCUIElement *disneySection = app.staticTexts[@"Disney+"];
    XCTAssertTrue([disneySection waitForExistenceWithTimeout:5]);

    // Vérifier que la section "Netflix" est visible
    XCUIElement *netflixSection = app.staticTexts[@"Netflix"];
    XCTAssertTrue([netflixSection waitForExistenceWithTimeout:5]);

    // Vérifier que la section "Prime Video" est visible
    XCUIElement *primeSection = app.staticTexts[@"Prime Video"];
    XCTAssertTrue([primeSection waitForExistenceWithTimeout:5]);
}

- (void)testLaunchPerformance {
    if (@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *)) {
        // Mesurer le temps de lancement de l'application.
        [self measureWithMetrics:@[[[XCTApplicationLaunchMetric alloc] init]] block:^{
            [[[XCUIApplication alloc] init] launch];
        }];
    }
}

@end
