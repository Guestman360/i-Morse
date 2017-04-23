//
//  MCTableViewController.m
//  iMorse
//
//  Created by The Guest Family on 3/24/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

#import "MCTableViewController.h"
#import "MainViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CoreDataManager.h"
#import "UsefulCodes+CoreDataClass.h"

@interface MCTableViewController ()

@end

@implementation MCTableViewController {
    CoreDataManager *cdm;
}

@synthesize selectedDataDelegate;

- (instancetype)init {
    self = [super init];
    if (self) {
        //http://morsecode.scphillips.com/morse.html
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Useful Codes";
    self.tableView.backgroundColor = [UIColor colorWithRed:214/255.0 green:206/255.0  blue:195/255.0  alpha:1.0];
    
    //ADDING THE EXIT BUTTON
    UIImage* imageLeft = [UIImage imageNamed:@"arrow2"];
    CGRect frameimg = CGRectMake(0, 0, imageLeft.size.width, imageLeft.size.height);
    
    UIButton *refButton = [[UIButton alloc] initWithFrame:frameimg];
    [refButton setBackgroundImage:imageLeft forState:UIControlStateNormal];
    [refButton addTarget:self action:@selector(dismissView)
        forControlEvents:UIControlEventTouchUpInside];
    [refButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithCustomView:refButton];
    
    self.navigationItem.leftBarButtonItem = infoButton;
    
    //ADDING THE ADD CODE BUTTON
    UIImage* imageRight = [UIImage imageNamed:@"plus"];
    CGRect frameimgRight = CGRectMake(0, 0, imageRight.size.width, imageRight.size.height);
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:frameimgRight];
    [addButton setBackgroundImage:imageRight forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonPressed)
        forControlEvents:UIControlEventTouchUpInside];
    [addButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *plusButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    self.navigationItem.rightBarButtonItem = plusButton;
    
    //Declare new NSMutableArray in the two properties below
    self.presetList = [NSMutableArray new];
    self.codeDescArray = [NSMutableArray new];

    //Loading data from DB
    [self reloadDataset];
}

- (void)dismissView {
    NSLog(@"TOTAL: %lu", (unsigned long)self.presetList.count);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addButtonPressed {
    AddNewCodeVC *addVC = [[AddNewCodeVC alloc] init];
    addVC.dataDelegate = self;
    UINavigationController *navBar = [[UINavigationController alloc]initWithRootViewController:addVC];
    [self.navigationController presentViewController:navBar animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.presetList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"morseCell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if ([cell.contentView subviews]){
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    
    //CELL LABELS
    UILabel *codeTitle;
    CGRect myframe = CGRectMake(20.0, codeTitle.frame.size.height / 2 + 10, 150.0, 25.0);
    codeTitle = [[UILabel alloc] initWithFrame:myframe];
    codeTitle.font = [UIFont fontWithName:@"Avenir-Next" size:18];
    [cell.contentView addSubview:codeTitle];
    
    UILabel *codeDesc;
    CGRect descframe = CGRectMake(cell.frame.size.width - 220, codeDesc.frame.size.height / 2 + 10, 220.0, 25.0);
    codeDesc = [[UILabel alloc] initWithFrame:descframe];
    codeDesc.font = [UIFont fontWithName:@"Avenir-Next" size:18];
    codeDesc.adjustsFontSizeToFitWidth = YES;
    [codeDesc setLineBreakMode:NSLineBreakByClipping];
    codeDesc.numberOfLines = 2;
    codeDesc.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:codeDesc];
    
//    [self.presetList sortUsingSelector:@selector(compare:)];
//    [self.codeDescArray sortUsingSelector:@selector(compare:)];
    
    codeTitle.text = self.presetList[indexPath.row];
    codeDesc.text = self.codeDescArray[indexPath.row];
    
    return cell;
}
//http://stackoverflow.com/questions/5210535/passing-data-between-view-controllers?rq=1
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectedDataDelegate sendDataToMain:self.presetList[indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //Only allow custom rows to be deleted, the rest are there by default
    if(indexPath.row <= 17){
        return NO;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //GET ALL THE CELLS CURRENTLY STORED
        NSArray *array = [[CoreDataManager sharedInstance] fetchAllRecords];
        //GET THE SPECIFIC INDEX OF THE STORED ARRAYS
        NSManagedObject *selectedObject = [array objectAtIndex:[indexPath row]];
        [selectedObject.managedObjectContext deleteObject:selectedObject];
        NSError *saveError;
        [selectedObject.managedObjectContext save:&saveError];
    
        [self.presetList removeObjectAtIndex:[indexPath row]];
        //NSLog(@"Index: %lu",indexPath.row);
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    }
}
//I WASNT GETTING THE PERSISTANT STORE CONTAINER?
-(NSManagedObjectContext*)context {
    return self.persistentContainer.viewContext;
}

#pragma mark - Delegate for receiving new data
- (void)sendDataToTableView:(NSString*)code codeDesc:(NSString*)desc {
    
    NSString *codes = code;
    NSString *descriptions = desc;
    //MUST PASS CODE & DESC AS THEY HOLD THE VALUES
    [self.presetList addObject:codes];
    [self.codeDescArray addObject:descriptions];
    //NSLog(@"PRESET LIST: %lu", (unsigned long)self.presetList.count);
    
    //Adding new record OR
    //If codeName is same, updating description in database
    [[CoreDataManager sharedInstance] saveNewCode:codes description:descriptions]; //formerly code, now codes?
    
    [self reloadDataset];
}

#pragma mark - Reloading table data from database
-(void)reloadDataset {
    
    NSArray *array = [[CoreDataManager sharedInstance] fetchAllRecords];
    
    //Removing all objects from current list
    [self.presetList removeAllObjects];
    [self.codeDescArray removeAllObjects];
    
    for (UsefulCodes *code in array) {
        [self.presetList addObject: code.codeName];
        [self.codeDescArray addObject: code.codeDescription];
    }
    
    [self.tableView reloadData];
}

@end
