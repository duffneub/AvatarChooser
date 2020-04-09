//
//  ChooseAvatarSceneSplitViewController.m
//  AvatarChooser
//
//  Created by Duff Neubauer on 4/7/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "ChooseAvatarSceneSplitViewController.h"

#import "GamesListViewController.h"
#import "GameDetailsViewController.h"

@interface ChooseAvatarSceneSplitViewController ()  <GamesListRouter, GameDetailsRouter>
@property (strong, nonatomic, nullable) ChooseAvatarSceneBuilder *builder;
@end

@implementation ChooseAvatarSceneSplitViewController

- (instancetype)initWithBuilder:(ChooseAvatarSceneBuilder *)builder {
    if (self = [super init]) {
        self.builder = builder;
        [self setUpInitialScene];
    }
    
    return self;
}

- (void)setUpInitialScene {
    NSViewController *placeholderVC = [[NSViewController alloc] init];
    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 550, 400)];
    NSTextField *label = [NSTextField labelWithString:@"No Game Selected"];

    label.textColor = NSColor.secondaryLabelColor;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:label];
    
    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]
    ]];
    placeholderVC.view = view;
    
    GamesListViewController *gamesListView = [[GamesListViewController alloc] init];
    [self.builder buildGamesListSceneWithView:gamesListView router:self];
    
    self.splitViewItems = @[
        [NSSplitViewItem sidebarWithViewController:gamesListView],
        [NSSplitViewItem splitViewItemWithViewController:placeholderVC]
    ];
    [self.splitViewItems[0] setMaximumThickness:250];
}

#pragma mark - GamesListRouter

- (void)showAvatarsForGame:(Game *)game {
    GameDetailsViewController *gameDetailsView = [[GameDetailsViewController alloc] init];
    [self.builder buildGameDetailsSceneWithGame:game view:gameDetailsView router:self];
    
    NSSplitViewItem *detailItem = self.splitViewItems[1];
    NSRect detailFrame = detailItem.viewController.view.frame;
    [self removeSplitViewItem:detailItem];
    
    gameDetailsView.view.frame = detailFrame;
    detailItem.viewController = gameDetailsView;
    [self addSplitViewItem:detailItem];
}

#pragma mark - GameDetailsRouter

- (void)showGamesList {
    // noop
}

- (void)didChooseAvatar {
    // noop
}

@end
