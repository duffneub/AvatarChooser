//
//  GameDetailsCLI.m
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "GameDetailsCLI.h"

#include <iostream>
using namespace std;

@implementation GameDetailsCLI
@synthesize presenter;

- (void)run {
    [self.presenter attachView:self];
}

- (void)reloadAvatarSuggestions {
    cout << "Suggested Avatars for '" << [self.presenter nameOfGame].UTF8String << "':\n";
    
    NSUInteger numberOfAvatars = [self.presenter numberOfAvatars];
    for (int i = 0; i < numberOfAvatars; i++) {
        NSString *name = [self.presenter nameOfAvatarAtIndex:i];
        NSString *filename = [[self.presenter locationOfAvatarAtIndex:i] lastPathComponent];
        printf("\t%d. %s (%s)\n", i + 1, name.UTF8String, filename.UTF8String);
    }
    
    // Display help?
//    cout << "\n";
//    cout << "To choose an avatar:     \tEnter a number between 1 and " << avatars.count << "\n";
//    cout << "To see more avatars:     \tEnter '>'\n";
//    cout << "To see previous avatars: \tEnter '<'\n";
//    cout << "To change game:          \tEnter '0'\n";
        
    char input;
    cin >> input;
    int inputAsInt = input - '0';
    
    if (input == '>') {
        [self.presenter suggestNewAvatars];
    } else if (input == '<') {
        [self.presenter suggestPreviousAvatars];
    } else if (input == '0') {
        [self.presenter chooseDifferentGame];
    } else if (1 <= inputAsInt && inputAsInt <= numberOfAvatars ) {
        [self.presenter selectAvatarAtIndex:inputAsInt - 1];
    }
}

@end
