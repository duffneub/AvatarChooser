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
@property (copy, nonatomic) NSString *imageLocation;
@end

@implementation Avatar

- (instancetype)initWithName:(NSString *)name imageLocation:(NSString *)location {
    if (self = [super init]) {
        self.name = name;
        self.imageLocation = location;
    }
    
    return self;
}

- (NSString *)imageName {
    NSString *extension = [NSURL fileURLWithPath:self.imageLocation].pathExtension;
    return [[NSURL fileURLWithPath:self.name] URLByAppendingPathExtension:extension].lastPathComponent;
}
@end
