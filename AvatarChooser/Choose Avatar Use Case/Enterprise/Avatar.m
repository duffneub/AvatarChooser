//
//  Avatar.m
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "Avatar.h"

@interface Avatar ()
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSURL *imageLocation;
@end

@implementation Avatar

- (instancetype)initWithName:(NSString *)name imageLocation:(NSURL *)location {
    if (self = [super init]) {
        self.name = name;
        self.imageLocation = location;
    }
    
    return self;
}

@end
