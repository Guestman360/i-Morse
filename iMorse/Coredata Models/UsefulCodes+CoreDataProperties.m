//
//  UsefulCodes+CoreDataProperties.m
//  iMorse
//
//  Created by The Guest Family on 3/24/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "UsefulCodes+CoreDataProperties.h"

@implementation UsefulCodes (CoreDataProperties)

+ (NSFetchRequest<UsefulCodes *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"UsefulCodes"];
}

@dynamic codeDescription;
@dynamic codeName;

@end
