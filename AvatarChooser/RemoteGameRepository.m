//
//  RemoteGameRepository.m
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "RemoteGameRepository.h"

#import "Avatar.h"
#import "Game.h"

@protocol JSONDecodable
- (instancetype)initWithJSON:(id)json;
@end

@interface Game (JSONDecodable) <JSONDecodable>
@end

@interface Avatar (JSONDecodable) <JSONDecodable>
@end

@interface RemoteGameRepository ()
@property (strong, nonatomic) NSURL *baseURL;
@property (strong, nonatomic) NSURLSession *session;
@end

@implementation RemoteGameRepository

- (instancetype)init
{
    if (self = [super init]) {
        self.baseURL = [NSURL URLWithString:@"https://clientupdate-v6.cursecdn.com/Avatars/"];
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    
    return self;
}

- (void)getAllWithCompletionHandler:(void (^)(NSArray<Game *> *))completionHandler {
    NSURL *url = [self.baseURL URLByAppendingPathComponent:@"avatars.json"];
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:url
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // TODO: Error checking
        NSArray *gamesList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray<Game *> *games = [@[] mutableCopy];
        for (NSDictionary *gameJSON in gamesList) {
            [games addObject:[[Game alloc] initWithJSON:gameJSON]];
        }
        
        completionHandler(games);
    }];
    
    [task resume];
}

@end

#pragma mark - Game + JSONDecodable

@implementation Game (JSONDecodable)

- (instancetype)initWithJSON:(NSDictionary *)json {
    NSMutableArray<Avatar *> *avatars = [@[] mutableCopy];
    NSArray *avatarListJSON = json[@"avatars"];
    for (NSDictionary *avatarJSON in avatarListJSON) {
        [avatars addObject:[[Avatar alloc] initWithJSON:avatarJSON]];
    }
    
    return [self initWithName:json[@"name"] avatars:avatars];
}

@end

#pragma mark - Avatar + JSONDecodable

@implementation Avatar (JSONDecodable)

- (instancetype)initWithJSON:(NSDictionary *)json {
    return [self initWithName:json[@"name"] imageLocation:json[@"url"]];
}

@end
