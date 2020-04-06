//
//  AvatarChooser.m
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "AvatarChooser.h"

#include <iostream>
using namespace std;

#import "Game.h"
#import "Avatar.h"

#import "AvatarChooserService.h"
#import "GamesListPresenter.h"
#import "RemoteGameRepository.h"

@interface AvatarChooser () <GamesListView>
@property (strong, nonatomic) NSURL *downloadsDirectory;
@property (strong, nonatomic) Game *selectedGame;
@property (strong, nonatomic) Avatar *selectedAvatar;
@property (strong, nonatomic) GamesListPresenter *presenter;

// UI State
@property (strong, nonatomic) NSArray<GameViewModel *> *games;
@end

@implementation AvatarChooser

- (instancetype)initWithDownloadsDirectory:(NSURL *)directory {
    if (self = [super init]) {
        self.downloadsDirectory = directory;
        
        id<GameRepository> gameRepo = [[RemoteGameRepository alloc] init];
        AvatarChooserService *service = [[AvatarChooserService alloc] initWithGameRepository:gameRepo];
        self.presenter = [[GamesListPresenter alloc] initWithAvatarChooserService:service];
    }
    
    return self;
}

- (void)run {
    BOOL success = [self createDirectoryIfNeeded:self.downloadsDirectory];
    if (!success) {
        exit(-1);
    }
    
    /* FOR TESTING PURPOSES, REMOVE FOR PROD */
    NSArray<NSURL *> *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:self.downloadsDirectory includingPropertiesForKeys:nil options:0 error:nil];
    for (NSURL *file in contents) {
        [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
    }
    
    NSLog(@"Duff -- Fetch all games");
    [self.presenter presentView:self];
}

- (BOOL)createDirectoryIfNeeded:(NSURL *)directory {
    BOOL success = YES;
    BOOL isDir;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:directory.path isDirectory:&isDir];
    
    if (fileExists && !isDir) {
        cout << "Error: '" << directory.path.UTF8String << "' is not a directory.\n";
        success = NO;
    } else if (!fileExists) {
        success = [[NSFileManager defaultManager] createDirectoryAtURL:directory withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
//        NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:directory includingPropertiesForKeys:nil options:0 error:nil];
//        success = contents.count == 0;
//        cout << "Error: '" << directory.path.UTF8String << "' must be empty.\n";
    }
    
    return success;
}

- (void)waitForUserToChooseGame {
    int gamePlace;
    
    cout << "Please enter an integer between 1 and " << self.games.count << ":\n";
    cin >> gamePlace;
    
    self.selectedGame = self.games[gamePlace - 1].base;
    [self.selectedGame resetAvatarSuggestions];
    cout << "Showing avatars for '" << self.selectedGame.name.UTF8String << "'...\n";
    
    NSArray<Avatar *> *avatars = [self.selectedGame suggestNewAvatars];
    [self displayAvatars:avatars];
}

- (void)displayAvatars:(NSArray<Avatar *> *)avatars {
    NSArray<NSURL *> *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:self.downloadsDirectory includingPropertiesForKeys:nil options:0 error:nil];
    for (NSURL *file in contents) {
        [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
    }
    
    [avatars enumerateObjectsUsingBlock:^(Avatar * _Nonnull avatar, NSUInteger idx, BOOL * _Nonnull stop) {
        printf("\t%ld. %s\n", idx + 1, avatar.name.UTF8String);
        
        NSURL *base = [NSURL URLWithString:@"https://clientupdate-v6.cursecdn.com/Avatars/"];
        NSURL *imageLocation = [base URLByAppendingPathComponent:avatar.imageLocation];

        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDownloadTask *task = [session downloadTaskWithURL:imageLocation
                                                    completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSURL *destination = [self.downloadsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%ld. %@", idx + 1, avatar.imageName]];
            [[NSFileManager defaultManager] moveItemAtURL:location toURL:destination error:nil];
        }];
        [task resume];
    }];
    
    cout << "\n";
    cout << "To choose an avatar:     \tEnter a number between 1 and " << avatars.count << "\n";
    cout << "To see more avatars:     \tEnter '>'\n";
    cout << "To see previous avatars: \tEnter '<'\n";
    cout << "To change game:          \tEnter '0'\n";
    
    char input;
    cin >> input;
    if (input == '>') {
        [self showMoreAvatars];
    } else if (input == '<') {
        [self showPreviousAvatars];
    } else if (input == '0') {
        [self displayGamesList];
        [self waitForUserToChooseGame];
    } else if (1 <= (input - '0') && (input - '0') <= avatars.count ) {
        int index = (input - '0') - 1;
        self.selectedAvatar = avatars[index];
        
        NSArray<NSURL *> *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:self.downloadsDirectory includingPropertiesForKeys:nil options:0 error:nil];
        for (NSURL *file in contents) {
            if ([file.lastPathComponent hasSuffix:self.selectedAvatar.imageName]) {
                continue;
            }
            
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        
        cout << "Selected Avatar: " << self.selectedAvatar.name.UTF8String << "\n";
        exit(0);
    }
}

- (void)showMoreAvatars {
    cout << "Show More Avatars:\n";
    NSArray<Avatar *> *avatars = [self.selectedGame suggestNewAvatars];
    [self displayAvatars:avatars];
}

- (void)showPreviousAvatars {
    cout << "Show Previous Avatars:\n";
    NSArray<Avatar *> *avatars = [self.selectedGame previousAvatarSuggestion];
    [self displayAvatars:avatars];
}

#pragma mark - GamesListView

- (void)setGamesList:(NSArray<GameViewModel *> *)games {
    self.games = games;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self displayGamesList];
        [self waitForUserToChooseGame];
    });
}

- (void)displayGamesList {
    [self removeDownloadedAvatarImages];

    cout << "Games with Avatars:\n";
    
    [self.games enumerateObjectsUsingBlock:^(GameViewModel * _Nonnull game, NSUInteger idx, BOOL * _Nonnull stop) {
        printf("\t%ld. %s\n", idx + 1, game.gameDescription.UTF8String);
    }];
}

// Where does this go?
- (void)removeDownloadedAvatarImages {
    NSArray<NSURL *> *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:self.downloadsDirectory includingPropertiesForKeys:nil options:0 error:nil];
    for (NSURL *file in contents) {
        [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
    }
}

@end
