//
//  Avatar.m
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "Avatar.h"

@interface Avatar ()
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *path;
@end

@implementation Avatar

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super init]) {
        self.name = json[@"name"];
        self.path = json[@"url"];
    }
    
    return self;
}

- (NSString *)imageName {
    NSString *extension = [NSURL fileURLWithPath:self.path].pathExtension;
    return [[NSURL fileURLWithPath:self.name] URLByAppendingPathExtension:extension].lastPathComponent;
}
@end
