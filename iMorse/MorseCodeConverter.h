//
//  MorseCodeConverter.h
//  iMorse
//
//  Created by The Guest Family on 3/24/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum morseCodeData:NSUInteger{
    MorseCodeSingleSpace, //Adds 1 pause
    MorseCodeDot,         //Short Beep
    MorseCodeDash,        //Long Beep
    MorseCodeThreeSpaces //3 pauses
} morseCodeData;

static NSString * const kMorseCodeSingleSpace = @" ";
static NSString * const kMorseCodeDot = @".";
static NSString * const kMorseCodeDash = @"-";
static NSString * const kMorseCodeThreeSpaces = @"   ";

@interface MorseCodeConverter : NSObject

- (NSArray*)convertStringToMorse: (NSString*)inputString;

@end
