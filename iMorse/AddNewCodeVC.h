//
//  AddNewCodeVC.h
//  iMorse
//
//  Created by The Guest Family on 4/5/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCTableViewController.h"

@class AddNewCodeVC;
@protocol addNewCellData <NSObject>
- (void)sendDataToTableView:(NSString*)code codeDesc:(NSString*)desc;
@end

@interface AddNewCodeVC : UIViewController<UITextFieldDelegate> {
    __weak id dataDelegate;
}

//@property(retain,nonatomic)MCTableViewController *mc;
@property(weak,nonatomic)id<addNewCellData>dataDelegate;
@property(strong,nonatomic)UITextField *codeTextfield;
@property(strong,nonatomic)UITextField *descTextfield;
@property(strong,nonatomic)NSMutableArray *preset;
@property(strong,nonatomic)NSMutableArray *codeDesc;

@end
