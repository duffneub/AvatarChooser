//
//  AppDelegate.m
//  AvatarChooser
//
//  Created by Duff Neubauer on 4/7/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "AppDelegate.h"

#import "ChooseGameService.h"
#import "RemoteGameRepository.h"
#import "GameDetailsPresenter.h"
#import "GamesListPresenter.h"
#import "PersistentImageRepository.h"
#import "SuggestAvatarService.h"

#import "ChooseAvatarSceneSplitViewController.h"
#import "GameDetailsViewController.h"
#import "GamesListViewController.h"

@interface AppDelegate () <GamesListRouter>

@property (weak) IBOutlet NSWindow *window;
@property (strong) ChooseAvatarSceneSplitViewController *chooseAvatarSplitVC;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.chooseAvatarSceneBuilder = [[ChooseAvatarSceneBuilder alloc] initWithDownloadLocation:[NSURL fileURLWithPath:@"/Users/duff/Downloads/Avatars"]];
    
    self.chooseAvatarSplitVC = [[ChooseAvatarSceneSplitViewController alloc] initWithBuilder:self.chooseAvatarSceneBuilder];
    self.window.contentViewController = self.chooseAvatarSplitVC;
}

- (NSViewController *)makePlaceholderViewController {
    NSViewController *placeholderVC = [[NSViewController alloc] init];
    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 500, 400)];
    NSTextField *label = [NSTextField labelWithString:@"No Game Selected"];

    label.textColor = NSColor.secondaryLabelColor;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:label];
    
    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]
    ]];
    placeholderVC.view = view;
    
    return placeholderVC;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (void)showAvatarsForGame:(nonnull Game *)game {
}

@end
