//
//  ChooseAvatarUseCaseTests.m
//  AvatarChooserTests
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Avatar.h"
#import "ChooseGameService.h"
#import "CLIChooseAvatarUseCase.h"
#import "Game.h"
#import "GamesListPresenter.h"
#import "PersistentImageRepository.h"
#import "RemoteGameRepository.h"
#import "SuggestAvatarService.h"

@interface MockNetworkClient : NSObject <NetworkClient>
@property (readonly, copy, nonatomic, nullable) NSURL *url;
- (instancetype)initWithJSON:(NSArray *)json;
@end

@interface MockGameRepository : NSObject <GameRepository>
- (instancetype)initWithGames:(NSArray *)games;
@end

@interface MockGamesListView : NSObject <GamesListView>
@property (readonly, nonatomic) BOOL shouldReloadGamesList;
@end

@interface MockGamesListRouter : NSObject <GamesListRouter>
@property (readonly, nonatomic, nullable) Game *chosenGame;
@end

/// Integration tests to verify that our steps of our use case are being carried out according to spec
@interface ChooseAvatarUseCaseTests : XCTestCase
@end

@implementation ChooseAvatarUseCaseTests

- (void)testUserCanChooseGameFromAList {
    // Set up games list scene
    NSURL *baseURL = [NSURL fileURLWithPath:@"/the/cloud/"];
    NSArray *json = [self allGamesJSON];
    MockNetworkClient *client = [[MockNetworkClient alloc] initWithJSON:json];
    RemoteGameRepository *repo = [[RemoteGameRepository alloc] initWithBaseURL:baseURL networkClient:client];
    ChooseGameService *service = [[ChooseGameService alloc] initWithGameRepository:repo];
    MockGamesListRouter *router = [[MockGamesListRouter alloc] init];
    GamesListPresenter *presenter = [[GamesListPresenter alloc] initWithService:service router:router];
    NSURL *expectedURL = [baseURL URLByAppendingPathComponent:@"avatars.json"];
    MockGamesListView *view = [[MockGamesListView alloc] init];
    
    // Verify scene state before testing
    XCTAssertFalse(view.shouldReloadGamesList);
    
    // View is displayed to user
    [presenter presentView:view];
    
    // System should fetch games from the network
    XCTAssertEqualObjects(expectedURL, client.url);
    XCTAssertTrue(view.shouldReloadGamesList);

    XCTAssertLessThan(0, json.count); // Sanity check to make sure enumeration block asserts are called

    // System should present games list to user
    XCTAssertEqual(json.count, presenter.numberOfGames);
    [json enumerateObjectsUsingBlock:^(NSDictionary<NSString *, id> *gameJSON, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // System should display name and # of avatars
        XCTAssertEqualObjects(gameJSON[@"name"], [presenter nameOfGameAtIndex:idx]);
        XCTAssertEqual(((NSArray *)gameJSON[@"avatars"]).count, [presenter numberOfAvatarsForGameAtIndex:idx]);
        
        // User can choose a game from the list
        [presenter userDidSelectGameAtIndex:idx];
        XCTAssertEqualObjects(gameJSON[@"name"], [router chosenGame].name);
        XCTAssertEqual(((NSArray *)gameJSON[@"avatars"]).count, [router chosenGame].numberOfAvatars);
    }];
}

- (NSArray *)allGamesJSON {
    NSString *pathToJSON = [[NSBundle bundleForClass:[self class]] pathForResource:@"avatars" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:pathToJSON];
    
    return [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
}

- (void)testUserCanChooseAvatar {
    XCTFail("Not implemented");
}

- (void)testErrorPaths {
    XCTFail("Not implemented");
}

@end

#pragma mark - MockNetworkClient

@interface MockNetworkClient ()
@property (readwrite) NSURL *url;
@property (strong, nonatomic) NSData *data;
@end

@interface MockNetworkTask : NSObject <NetworkTask>
+ (instancetype)dataTaskWithOnResumeHandler:(void (^)(void))handler;
@end

@implementation MockNetworkClient

- (instancetype)initWithJSON:(NSArray *)json {
    if (self = [super init]) {
        self.data = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
    }
    
    return self;
}

- (id<NetworkTask>)dataTaskWithURL:(NSURL *)url
                 completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    self.url = url;
    return [MockNetworkTask dataTaskWithOnResumeHandler:^{
        completionHandler(self.data, nil, nil);
    }];
}

@end

#pragma mark - MockNetworkTask

@interface MockNetworkTask ()
@property (copy, nonatomic) void (^onResumeHandler)(void);
@end

@implementation MockNetworkTask

+ (instancetype)dataTaskWithOnResumeHandler:(void (^)(void))handler {
    MockNetworkTask *task = [[MockNetworkTask alloc] init];
    task.onResumeHandler = handler;
    
    return task;
}

- (void)resume {
    self.onResumeHandler();
}

@end

#pragma mark - MockGameRepository

@interface MockGameRepository ()
@property (strong, nonatomic) NSArray *games;
@end

@implementation MockGameRepository

- (instancetype)initWithGames:(NSArray *)games {
    if (self = [super init]) {
        self.games = games;
    }
    
    return self;
}

- (void)getAllWithCompletionHandler:(void (^)(NSArray<Game *> * _Nonnull))completionHandler {
    completionHandler(self.games);
}

@end

#pragma mark - MockGamesListView

@interface MockGamesListView ()
@property (readwrite) BOOL shouldReloadGamesList;
@end

@implementation MockGamesListView

- (instancetype)init {
    if (self = [super init]) {
        self.shouldReloadGamesList = NO;
    }
    
    return self;
}

- (void)setGamesList:(NSArray<GameViewModel *> *)games {}

- (void)reloadGamesList {
    self.shouldReloadGamesList = YES;
}

@end

#pragma mark - MockGamesListRouter

@interface MockGamesListRouter ()
@property (readwrite) Game *chosenGame;
@end

@implementation MockGamesListRouter

- (void)showAvatarsForGame:(Game *)game {
    self.chosenGame = game;
}

@end
