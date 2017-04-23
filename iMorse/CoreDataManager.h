//
//  CoreDataManager.h
//  iMorse
//
//  Created by The Guest Family on 3/24/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;
//@property(strong,nonatomic)NSManagedObjectContext *context; //added last, maybe remove

- (void)saveContext;

+(CoreDataManager*)sharedInstance;

-(void)storeListFirstTime; //This will save your initial list of content

-(NSArray*)fetchAllRecords;//get All the record from your table

-(BOOL)saveNewCode:(NSString*)codeName description:(NSString*)codeDesc;

@end
