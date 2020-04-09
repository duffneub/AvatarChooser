//
//  ChooseAvatarSceneSplitViewController.h
//  AvatarChooser
//
//  Created by Duff Neubauer on 4/7/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ChooseAvatarSceneBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseAvatarSceneSplitViewController : NSSplitViewController
- (instancetype)initWithBuilder:(ChooseAvatarSceneBuilder *)builder;
@end

NS_ASSUME_NONNULL_END
