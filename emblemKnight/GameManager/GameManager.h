//
//  GameManager.h
//  emblemKnight
//
//  Created by Xi Zhang on 5/1/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CharacterObject.h"

@interface GameManager : NSObject
{

}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+(GameManager *)manager;

#pragma mark - Context save/merge related methods

- (NSManagedObjectContext *)createManagedObjectContextWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (void)saveManagedObjectContextResolveAnyConflicts:(NSManagedObjectContext *)managedObjectContext;
- (void)saveContext;


#pragma mark - character related
-(CharacterObject *)insertCharacterIntoDB;
-(CharacterObject*)getCharacterObjectByID:(NSString*)characterID;
-(CharacterObject*)getCharacterObjectByName:(NSString*)characterName;

@end
