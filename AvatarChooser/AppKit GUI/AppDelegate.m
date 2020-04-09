//
//  AppDelegate.m
//  AvatarChooser
//
//  Created by Duff Neubauer on 4/7/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "AppDelegate.h"

#import "ChooseAvatarSceneSplitViewController.h"

@interface AppDelegate ()

@property (weak, nonatomic) IBOutlet NSWindow *window;
@property (strong, nonatomic) ChooseAvatarSceneSplitViewController *chooseAvatarSplitVC;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.chooseAvatarSplitVC = [[ChooseAvatarSceneSplitViewController alloc] initWithBuilder:self.chooseAvatarSceneBuilder];
    self.window.contentViewController = self.chooseAvatarSplitVC;
}

@end
