//
//  AppDelegate.h
//  AvatarChooser
//
//  Created by Duff Neubauer on 4/7/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ChooseAvatarSceneBuilder;

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (strong, nullable) ChooseAvatarSceneBuilder *chooseAvatarSceneBuilder;
@end

