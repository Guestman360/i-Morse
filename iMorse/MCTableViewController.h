//
//  MCTableViewController.h
//  iMorse
//
//  Created by The Guest Family on 3/24/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AddNewCodeVC.h"
#import "MainViewController.h"

@protocol addNewCellData;

@protocol sendDataProtocol <NSObject>
- (void)sendDataToMain:(NSString*)text;
@end

@class MainViewController;
@class AddNewCodeVC; //removed delegate and datasource for tableview
@interface MCTableViewController : UITableViewController<addNewCellData> {
    __weak id selectDataDelegate;
}

@property (readonly, strong) NSPersistentContainer *persistentContainer;
//@property(strong,nonatomic)NSManagedObjectContext *context;
@property(strong,nonatomic)NSMutableArray *presetList;
@property(strong,nonatomic)NSMutableArray *codeDescArray;
@property(nonatomic,weak)id<sendDataProtocol> selectedDataDelegate;
@property(strong,nonatomic)UILabel *codeTitle;
@property(strong,nonatomic)UILabel *codeDesc;

@end

//use assign if not using ARC, weak if ARC is used
