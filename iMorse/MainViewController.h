//
//  ViewController.h
//  iMorse
//
//  Created by The Guest Family on 3/24/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCTableViewController.h"

@protocol sendDataProtocol;
@class MCTableViewController;
@interface MainViewController : UIViewController<UITextFieldDelegate, CAAnimationDelegate, sendDataProtocol>

//@property(strong,nonatomic)MCTableViewController *tableVC;
//@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property(strong,nonatomic)UITextField *morseTextfield;
@property(strong,nonatomic)UILabel *outputLabel;
@property(strong,nonatomic)NSArray *preset;
@property(nonatomic)int num;

@end

