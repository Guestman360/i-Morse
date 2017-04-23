//
//  AddNewCodeVC.m
//  iMorse
//
//  Created by The Guest Family on 4/5/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

#import "AddNewCodeVC.h"
#import "CoreDataManager.h"

@interface AddNewCodeVC ()

@property(strong,nonatomic)UIButton *saveButton;

@end

@implementation AddNewCodeVC

@synthesize dataDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MCTableViewController *tableVC = [[MCTableViewController alloc] init];
    self.preset = [tableVC presetList];
    self.codeDesc = [tableVC codeDescArray];
    
    self.navigationItem.title = @"Add a New Morse Code";
    self.view.backgroundColor = [UIColor colorWithRed:214/255.0 green:206/255.0  blue:195/255.0  alpha:1.0];
    
    //CONFORMING TO DELEGATES
    self.codeTextfield.delegate = self;
    self.descTextfield.delegate = self;
    
    //CREATING AND ADDING TEXTFIELDS TO VIEW
    self.codeTextfield = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width-300)/2,
                                                                       (self.view.frame.size.height)/7, 300, 30.0)];
    self.codeTextfield.borderStyle = UITextBorderStyleRoundedRect;
    self.codeTextfield.font = [UIFont fontWithName:@"Avenir Next" size:20];
    self.codeTextfield.textAlignment = NSTextAlignmentCenter;
    self.codeTextfield.placeholder = @"Type a New Morse Code Here";
    [self.codeTextfield addTarget:self action:@selector(dismissKeyboardCode) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.codeTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    self.codeTextfield.spellCheckingType = UITextSpellCheckingTypeNo;
    self.codeTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.codeTextfield setReturnKeyType:UIReturnKeyDone];
    [self.view addSubview:self.codeTextfield];
    
    //CREATING THE DESCRIPTION TEXTFIELD
    self.descTextfield = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width-300)/2,
                                                                      (self.view.frame.size.height)/4.5, 300, 30.0)];
    self.descTextfield.borderStyle = UITextBorderStyleRoundedRect;
    self.descTextfield.font = [UIFont fontWithName:@"Avenir Next" size:20];
    self.descTextfield.textAlignment = NSTextAlignmentCenter;
    self.descTextfield.placeholder = @"Type a Description Here";
    [self.descTextfield addTarget:self action:@selector(dismissKeyboardDesc) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.descTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    self.descTextfield.spellCheckingType = UITextSpellCheckingTypeNo;
    self.descTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.descTextfield setReturnKeyType:UIReturnKeyDone];
    [self.view addSubview:self.descTextfield];
    
    //CREATE THE SAVE BUTTON TO PASS BACK DATA
    self.saveButton = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-300)/2,
                                                                  (self.view.frame.size.height)/3, 300, 55.0)];
    self.saveButton.layer.masksToBounds = YES;
    self.saveButton.layer.cornerRadius = 8.0;
    self.saveButton.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self.saveButton setTitle:@"SAVE" forState:normal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveNewCode) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.saveButton.hidden = YES;
    [self.view addSubview:self.saveButton];
    
    //CREATE THE CANCEL BUTTON TO LEAVE VIEW
    UIImage *imageLeft = [UIImage imageNamed:@"cancel"];
    CGRect frameimg = CGRectMake(0, 0, imageLeft.size.width, imageLeft.size.height);
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:frameimg];
    [cancelButton setBackgroundImage:imageLeft forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelBtnPressed)
        forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *cancelBarButton =[[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    self.navigationItem.leftBarButtonItem = cancelBarButton;
}

-(id)init {
    self = [super init];
    if(self) {
        //do your object initialization here
        self.preset = [NSMutableArray array];
        self.codeDesc = [NSMutableArray array];
    }
    return self;
}

- (void)dismissKeyboardCode {
    [self.codeTextfield resignFirstResponder];
    NSLog(@"CODE: %@", self.codeTextfield.text);
}

- (void)dismissKeyboardDesc {
    [self unhideButton];
    [self.descTextfield resignFirstResponder];
    NSLog(@"DESC: %@", self.descTextfield.text);
}

- (void)saveNewCode {
    [self.dataDelegate sendDataToTableView:self.codeTextfield.text codeDesc:self.descTextfield.text];
    //ADD OBJECTS TO PRESETLIST AND CODEDESCARRAY
    [self.preset addObject:self.codeTextfield.text];
    [self.codeDesc addObject:self.descTextfield.text];
    NSLog(@"CODE: %@", self.codeTextfield.text);
    NSLog(@"DESC: %@", self.descTextfield.text);    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)unhideButton {
    if(![self.codeTextfield isEqual:@""] && ![self.descTextfield isEqual:@""]){
        self.saveButton.hidden = YES;
        self.saveButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.saveButton.hidden = NO;
            self.saveButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            NSLog(@"success");
            self.saveButton.transform = CGAffineTransformMakeScale(1, 1);
        }];
        self.saveButton.hidden = NO;
    }
}

- (void)cancelBtnPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
