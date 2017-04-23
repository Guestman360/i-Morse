//
//  MorseCodeConverter.m
//  iMorse
//
//  Created by The Guest Family on 3/24/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

#import "MorseCodeConverter.h"
#import "MainViewController.h"

@interface MorseCodeConverter()

@property(nonatomic, strong) NSDictionary *MorseCodeDict; //same as the on in intmorse conversion

@end

@implementation MorseCodeConverter

- (id)init {
    self = [super init];
    if(self != nil) {
        [self initMorseConversion];
    }
    return self;
}

- (NSArray*)convertStringToMorse: (NSString*)inputString {
    NSMutableArray *convertedMorseCodeArray = [@[] mutableCopy];
    
    for(int index = 0; index < inputString.length; index++) {
        NSString *charString = [[inputString lowercaseString] substringWithRange:NSMakeRange(index, 1)];
        NSArray *charMorseCodes = self.MorseCodeDict[charString];
        
        [charMorseCodes enumerateObjectsUsingBlock:^(NSNumber *morseCodeCharNums, NSUInteger idx, BOOL *stop) {
            [convertedMorseCodeArray addObject:morseCodeCharNums];
            NSLog(@"chars: %@", morseCodeCharNums);
        }];
        
        if (index < (inputString.length-1)) {
            [convertedMorseCodeArray addObject:@(MorseCodeSingleSpace)];
        }
    }
    
    return convertedMorseCodeArray;
}

- (void)initMorseConversion {
    
    //http://morsecode.scphillips.com/morse.html - Reference for this project
    NSMutableDictionary *MorseCodeDict = [[NSMutableDictionary alloc]init];
    
    MorseCodeDict[@"   "] = @[@(MorseCodeThreeSpaces)];
    MorseCodeDict[@"a"] = @[@(MorseCodeDot),@(MorseCodeDash)];
    MorseCodeDict[@"b"] = @[@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot)];
    MorseCodeDict[@"c"] = @[@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDot)];
    MorseCodeDict[@"d"] = @[@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDot)];
    MorseCodeDict[@"e"] = @[@(MorseCodeDot)];
    MorseCodeDict[@"f"] = @[@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDot)];
    MorseCodeDict[@"g"] = @[@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDot)];
    MorseCodeDict[@"h"] = @[@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot)];
    MorseCodeDict[@"i"] = @[@(MorseCodeDot),@(MorseCodeDot)];
    MorseCodeDict[@"j"] = @[@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDash)];
    MorseCodeDict[@"k"] = @[@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDash)];
    MorseCodeDict[@"l"] = @[@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDot)];
    MorseCodeDict[@"m"] = @[@(MorseCodeDash),@(MorseCodeDash)];
    MorseCodeDict[@"n"] = @[@(MorseCodeDash),@(MorseCodeDot)];
    MorseCodeDict[@"o"] = @[@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDash)];
    MorseCodeDict[@"p"] = @[@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDot)];
    MorseCodeDict[@"q"] = @[@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDash)];
    MorseCodeDict[@"r"] = @[@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDot)];
    MorseCodeDict[@"s"] = @[@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot)];
    MorseCodeDict[@"t"] = @[@(MorseCodeDash)];
    MorseCodeDict[@"u"] = @[@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDash)];
    MorseCodeDict[@"v"] = @[@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDash)];
    MorseCodeDict[@"w"] = @[@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDash)];
    MorseCodeDict[@"x"] = @[@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDash)];
    MorseCodeDict[@"y"] = @[@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDash)];
    MorseCodeDict[@"z"] = @[@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDot)];
    
    MorseCodeDict[@"1"] = @[@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDash)];
    MorseCodeDict[@"2"] = @[@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDash)];
    MorseCodeDict[@"3"] = @[@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDash)];
    MorseCodeDict[@"4"] = @[@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDash)];
    MorseCodeDict[@"5"] = @[@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot)];
    MorseCodeDict[@"6"] = @[@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot)];
    MorseCodeDict[@"7"] = @[@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot)];
    MorseCodeDict[@"8"] = @[@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDot)];
    MorseCodeDict[@"9"] = @[@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDot)];
    MorseCodeDict[@"0"] = @[@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDash)];
    
    MorseCodeDict[@"."] = @[@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDash)];
    MorseCodeDict[@","] = @[@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDash)];
    MorseCodeDict[@":"] = @[@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot)];
    MorseCodeDict[@";"] = @[@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDot)];
    MorseCodeDict[@"?"] = @[@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDot)];
    MorseCodeDict[@"'"] = @[@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDot)];
    MorseCodeDict[@"-"] = @[@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDash)];
    MorseCodeDict[@"/"] = @[@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDot)];
    MorseCodeDict[@")"] = @[@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDash)];
    MorseCodeDict[@"("] = @[@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDash)];
    MorseCodeDict[@"\""] = @[@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDash)];
    MorseCodeDict[@"@"] = @[@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDot)];
    MorseCodeDict[@"="] = @[@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDash)];
    MorseCodeDict[@"!"] = @[@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDot)];
    MorseCodeDict[@"["] = @[@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDot)];
    MorseCodeDict[@"]"] = @[@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDash),@(MorseCodeDash),@(MorseCodeDot)];
    MorseCodeDict[@"+"] = @[@(MorseCodeDash),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDot),@(MorseCodeDash)];

    self.MorseCodeDict = MorseCodeDict;
}


@end
