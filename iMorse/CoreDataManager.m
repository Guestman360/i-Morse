//
//  CoreDataManager.m
//  iMorse
//
//  Created by The Guest Family on 3/24/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

#import "CoreDataManager.h"
#import "UsefulCodes+CoreDataClass.h"

@implementation CoreDataManager

+(CoreDataManager*)sharedInstance {
    static CoreDataManager *sharedObject;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[CoreDataManager alloc] init];
    });
    
    return sharedObject;
}


-(void)storeListFirstTime {
    
    //http://morsecode.scphillips.com/morse.html
    NSArray* presetList = [NSArray arrayWithObjects:@"AS",
                                                   @"BCNU",
                                                   @"CL",
                                                   @"CT",
                                                   @"CUL",
                                                   @"K",
                                                   @"QSL",
                                                   @"QSL?",
                                                   @"QRX?",
                                                   @"QRV",
                                                   @"QRV?",
                                                   @"QTH",
                                                   @"QTH?",
                                                   @"R",
                                                   @"SN",
                                                   @"SOS",
                                                   @"73",
                                                   @"88",
                                                   nil];
    
    
    NSArray* codeDescArray = [NSArray arrayWithObjects:@"Wait",
                                                      @"Be seeing You",
                                                      @"Going off air",
                                                      @"Start Copying",
                                                      @"See you later",
                                                      @"Over",
                                                      @"I acknowledge receipt",
                                                      @"Do you acknowledge",
                                                      @"Should I wait",
                                                      @"Ready to copy",
                                                      @"Are you ready to copy?",
                                                      @"My location is ...",
                                                      @"What is your location?",
                                                      @"Roger",
                                                      @"Understood",
                                                      @"Distress message",
                                                      @"Best regards",
                                                      @"Love and kisses",
                                                      nil];
    
    //Saves the initial list of items
    for(int i = 0; i < presetList.count; i++) {
        NSManagedObjectContext *context = [self context];
        UsefulCodes *codeObj = [NSEntityDescription insertNewObjectForEntityForName:@"UsefulCodes"
                                                             inManagedObjectContext:context];
        codeObj.codeName = [presetList objectAtIndex:i];
        codeObj.codeDescription = [codeDescArray objectAtIndex:i];
        
        //NSLog(@"CODEOBJ: %@", codeObj);
    }
    
    [self saveContext];
}

-(NSArray*)fetchAllRecords {
    
    NSManagedObjectContext *context = [self context]; //this context is conected to persistant container
    NSError *error = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UsefulCodes"];
    NSArray *records = [context executeFetchRequest:request
                                              error:&error];
    
    if(error == nil && records.count > 0) {
        //NSLog(@"Records: %@", records); //THIS IS WHERE THE EXTRA CODES ARE ADDED
        return [records copy];
    }
    else {
        //Handle error by returning new array
        return [NSArray new];
    }
}

-(BOOL)saveNewCode:(NSString*)codeName description:(NSString*)codeDesc {
    
    NSManagedObjectContext *context = [self context];
    NSError *error = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UsefulCodes"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"codeName = %@", codeName];
    request.predicate = predicate;
    
    NSArray *records = [context executeFetchRequest:request
                                              error:&error];
    
    if(error == nil && records.count > 0) {
        UsefulCodes *code = [records firstObject];
        
        //Updating description
        code.codeDescription = codeDesc;
    }
    else {//Add new code Object to table
        NSManagedObjectContext *context = [self context];
        UsefulCodes *codeObj = [NSEntityDescription insertNewObjectForEntityForName:@"UsefulCodes"
                                                             inManagedObjectContext:context];
        codeObj.codeName = codeName;
        codeObj.codeDescription = codeDesc;
    }
    
    //Save changes
    if ([context hasChanges] && ![context save:&error]) {
        //Saved successfully
        return true;
    }
    else {
        //handle error
        return false;
    }
    
    return true;
}

#pragma mark - Core Data stack
//I moved this from the App Delegate and put the core data stack in its own file
@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Model"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support
- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

-(NSManagedObjectContext*)context {
    return self.persistentContainer.viewContext;
}

@end
