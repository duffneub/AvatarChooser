//
//  AvatarCollectionViewItem.m
//  AvatarChooser
//
//  Created by Duff Neubauer on 4/8/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "AvatarCollectionViewItem.h"

@interface AvatarCollectionViewItem ()

@end

@implementation AvatarCollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.wantsLayer = YES;
    self.view.layer.borderColor = NSColor.controlAccentColor.CGColor;
    self.view.layer.borderWidth = 0.0;
    self.view.layer.cornerRadius = 8.0;
    
    self.imageView.wantsLayer = YES;
    self.imageView.layer.backgroundColor = NSColor.controlBackgroundColor.CGColor;
}

- (void)setSelected:(BOOL)selected {
    self.view.layer.borderWidth = selected ? 2.0 : 0.0;
    [super setSelected:selected];
}

@end
