//
//  GameTests.m
//  AvatarChooserTests
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Avatar.h"
#import "Game.h"

@interface GameTests : XCTestCase
@end

@implementation GameTests

- (void)testNextAndPreviousSuggestedAvatars {
    Game *subject = [self makeGameWithNumberOfAvatars:18];
    
    NSArray<Avatar *> *firstSuggestion = [subject suggestNewAvatars];
    XCTAssertEqual(5, firstSuggestion.count);
    
    NSArray<Avatar *> *secondSuggestion = [subject suggestNewAvatars];
    XCTAssertEqual(5, secondSuggestion.count);
    
    NSArray<Avatar *> *thirdSuggestion = [subject suggestNewAvatars];
    XCTAssertEqual(5, thirdSuggestion.count);
    
    NSArray<Avatar *> *fourthSuggestion = [subject suggestNewAvatars];
    XCTAssertEqual(3, fourthSuggestion.count); // There's only 3 left
    XCTAssertEqualObjects(@[], [subject suggestNewAvatars]);
    XCTAssertEqualObjects(@[], [subject suggestNewAvatars]);
    
    XCTAssertEqualObjects(fourthSuggestion, [subject suggestPreviousAvatars]);
    XCTAssertEqualObjects(thirdSuggestion, [subject suggestPreviousAvatars]);
    XCTAssertEqualObjects(secondSuggestion, [subject suggestPreviousAvatars]);
    XCTAssertEqualObjects(firstSuggestion, [subject suggestPreviousAvatars]);
    XCTAssertEqualObjects(@[], [subject suggestPreviousAvatars]);
    XCTAssertEqualObjects(@[], [subject suggestPreviousAvatars]);
    
    XCTAssertEqualObjects(firstSuggestion, [subject suggestNewAvatars]);
    XCTAssertEqualObjects(secondSuggestion, [subject suggestNewAvatars]);
    XCTAssertEqualObjects(thirdSuggestion, [subject suggestNewAvatars]);
    XCTAssertEqualObjects(fourthSuggestion, [subject suggestNewAvatars]);
    XCTAssertEqualObjects(@[], [subject suggestNewAvatars]);
}

- (void)testPreviousSuggestedAvatarsWorksEvenAfterMultipleEmptySuggestions {
    Game *subject = [self makeGameWithNumberOfAvatars:10];

    XCTAssertEqual(5, [subject suggestNewAvatars].count);
    XCTAssertEqual(5, [subject suggestNewAvatars].count);
    XCTAssertEqual(0, [subject suggestNewAvatars].count);
    XCTAssertEqual(0, [subject suggestNewAvatars].count);
    XCTAssertEqual(0, [subject suggestNewAvatars].count);
    XCTAssertEqual(5, [subject suggestPreviousAvatars].count);
}

- (void)testNextSuggestedAvatarsWorksEvenAfterMultiplePreviousEmptySuggestions {
    Game *subject = [self makeGameWithNumberOfAvatars:5];
    
    XCTAssertEqual(0, [subject suggestPreviousAvatars].count);
    XCTAssertEqual(0, [subject suggestPreviousAvatars].count);
    XCTAssertEqual(0, [subject suggestPreviousAvatars].count);
    XCTAssertEqual(5, [subject suggestNewAvatars].count);
}

- (Game *)makeGameWithNumberOfAvatars:(NSUInteger)count {
    NSMutableArray<Avatar *> *avatars = [@[] mutableCopy];
    for (int i = 1; i <= count; i++) {
        NSString *name = [NSString stringWithFormat:@"%d", i];
        [avatars addObject:[[Avatar alloc] initWithName:name imageLocation:[NSURL fileURLWithPath:@"/path"]]];
    }
    return [[Game alloc] initWithName:@"game" avatars:avatars];
}

@end
