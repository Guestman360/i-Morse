//
//  MCReferenceTableVC.m
//  iMorse
//
//  Created by The Guest Family on 3/24/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

#import "MCReferenceTableVC.h"
#import "MainViewController.h"

@interface MCReferenceTableVC ()

@property(strong,nonatomic)NSDictionary *refDict;
@property(strong,nonatomic)NSArray *refArray;
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UIView *topPanel;

@end

@implementation MCReferenceTableVC

@dynamic tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refDict = @{@"a":@".-",
                     @"b":@"-...",
                     @"c":@"-.-.",
                     @"d":@"-..",
                     @"e":@".",
                     @"f":@"..-.",
                     @"g":@"--.",
                     @"h":@"....",
                     @"i":@"..",
                     @"j":@".---",
                     @"k":@"-.-",
                     @"l":@".-..",
                     @"m":@"--",
                     @"n":@"-.",
                     @"o":@"---",
                     @"p":@".--.",
                     @"q":@"--.-",
                     @"r":@".-.",
                     @"s":@"...",
                     @"t":@"-",
                     @"u":@"..-",
                     @"v":@"...-",
                     @"w":@".--",
                     @"x":@"-..-",
                     @"y":@"-.--",
                     @"z":@"--..",
                     @"1":@".----",
                     @"2":@"..---",
                     @"3":@"...--",
                     @"4":@"....-",
                     @"5":@".....",
                     @"6":@"-....",
                     @"7":@"--...",
                     @"8":@"---..",
                     @"9":@"----.",
                     @"0":@"-----"};
    
    self.refArray = [[self.refDict allKeys]sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    self.navigationItem.title = @"Morse Practice"; //change font later
    self.tableView.backgroundColor = [UIColor colorWithRed:214/255.0 green:206/255.0  blue:195/255.0  alpha:1.0];
    
    //NAV BAR
    UIImage* imageRight = [UIImage imageNamed:@"arrow"];
    CGRect frame = CGRectMake(0, 0, imageRight.size.width, imageRight.size.height);
    
    UIButton *refButton = [[UIButton alloc] initWithFrame:frame];
    [refButton setBackgroundImage:imageRight forState:UIControlStateNormal];
    [refButton addTarget:self action:@selector(dismissView)
        forControlEvents:UIControlEventTouchUpInside];
    [refButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithCustomView:refButton];
    
    self.navigationItem.rightBarButtonItem = returnBtn;
}

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.refArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *letter = self.refArray[indexPath.row]; //GRABS ALL KEYS
    
    static NSString *cellID = @"refCell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if ([cell.contentView subviews]){
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    
    UILabel *morseLetter;
    CGRect morseframe = CGRectMake(20.0, morseLetter.frame.size.height / 2 + 10, 220.0, 25.0);
    morseLetter = [[UILabel alloc] initWithFrame:morseframe];
    morseLetter.font = [UIFont fontWithName:@"Avenir-Next" size:18];
    [cell.contentView addSubview:morseLetter];
    
    UILabel *morseTranslation;
    CGRect translationframe = CGRectMake(cell.frame.size.width - 220, morseTranslation.frame.size.height / 2 + 10, 220.0, 25.0);
    morseTranslation = [[UILabel alloc] initWithFrame:translationframe];
    morseTranslation.font = [UIFont fontWithName:@"Avenir-Next" size:18];
    morseTranslation.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:morseTranslation];
    
    morseLetter.text = letter;
    morseTranslation.text = self.refDict[letter];
    
    return cell;
}

@end
