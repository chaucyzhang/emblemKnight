//
//  GameManager.m
//  emblemKnight
//
//  Created by Xi Zhang on 5/1/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import "GameManager.h"

static GameManager *globalInstance = nil;

@interface GameManager(){
    NSMutableDictionary *_managedObjectContexts;
    NSMutableDictionary *_managedObjectContextThreads;
}

@end

@implementation GameManager

@synthesize managedObjectContext=__managedObjectContext;
@synthesize managedObjectModel=__managedObjectModel;
@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;


+ (GameManager *)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalInstance = [[GameManager alloc] init];
    });
    
    return globalInstance;
}


- (NSManagedObjectContext *)managedObjectContext
{
    
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        //		__managedObjectContext = [[NSManagedObjectContext alloc] init];
        //		[__managedObjectContext setPersistentStoreCoordinator:coordinator];
        __managedObjectContext = [self createManagedObjectContextWithPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    //    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"eReader" withExtension:@"momd"];
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"Model" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths objectAtIndex:0];
    NSURL *storeUrl = [NSURL fileURLWithPath: [documentPath stringByAppendingPathComponent: @"database.sqlite"]];
    
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
    						 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
    						 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        // Handle error
        NSLog(@"%@",error);
    }

   
    return __persistentStoreCoordinator;
}


- (NSManagedObjectContext *)createManagedObjectContextWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (nil == persistentStoreCoordinator) return nil;
    
    NSManagedObjectContext *context = nil;
    if (__managedObjectContext!=nil) {
        [__managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
        return __managedObjectContext;
    }
    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
    [context setPersistentStoreCoordinator:persistentStoreCoordinator];
    
    return context;
}



- (void)saveManagedObjectContextResolveAnyConflicts:(NSManagedObjectContext *)managedObjectContext {
    
    NSError *saveError = nil;
    
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&saveError]) {
        NSDictionary *userInfo = [saveError userInfo];
        NSArray *conflictList = [userInfo objectForKey:@"conflictList"];
        
        if (conflictList && [conflictList count]) {
            NSInteger numberOfFalseConflicts = 0;
            
            //BOOL shouldChangePolicy = NO;
            
            
            for (NSMergeConflict *conflict in conflictList) {
                NSManagedObject *sourceObject = [conflict sourceObject];
                NSDictionary *objectSnapshot = [conflict objectSnapshot];
                NSDictionary *cachedSnapshot = [conflict cachedSnapshot];
                
                if ([objectSnapshot isEqualToDictionary:cachedSnapshot]) {
                    // No change in values, refresh the object and save again.
                    [managedObjectContext refreshObject:sourceObject mergeChanges:YES];
                    numberOfFalseConflicts++;
                } else {
                    
                    NSLog(@"Change...");
                }
            }
            
            //if (shouldChangePolicy) {
            //	[managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
            //}
            
            if ([conflictList count] == numberOfFalseConflicts) {
                NSLog(@"Merge conflict occured. Trying to save again...\n%@", saveError);
                [self saveManagedObjectContextResolveAnyConflicts:managedObjectContext];
            } else {
                NSLog(@"Merge conflict error.\n%@", saveError);
            }
        } else {
            NSLog(@"Other Core Data Error: %@", saveError);
        }
    }
}


- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    [self saveManagedObjectContextResolveAnyConflicts:managedObjectContext];
    return;

    NSError *error = nil;
    if (managedObjectContext != nil && [managedObjectContext hasChanges]) {
        @try{
            [managedObjectContext lock];
            [managedObjectContext save:&error];
            
            if(error) {
                NSLog(@"error in saving context %@", error);
            }
            
        }
        @catch (NSException *ex) {
            NSLog(@"Exception handled: %@ Desc: %@",NSStringFromSelector(_cmd),[ex description]);
            NSLog(@"%@",[ex description]);
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            if(error)
                abort();
        }
        @finally {
            [managedObjectContext unlock];
        }
    }
    //    });
}

-(CharacterObject *)insertCharacterIntoDB
{
     CharacterObject *newCharacter = [NSEntityDescription insertNewObjectForEntityForName:@"CharacterObject" inManagedObjectContext:self.managedObjectContext];
    [newCharacter setCharacterID:[self generateUuidString]];
    [self saveContext];
    return newCharacter;
}


-(CharacterObject*)getCharacterObjectByID:(NSString*)characterID
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"CharacterObject" inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"characterID = %@",characterID];
    
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *fetchResults = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:request error:&error]];
    
    if([fetchResults count]) {
        return [fetchResults lastObject];
    }
    
    return nil;
    
}

-(CharacterObject*)getCharacterObjectByName:(NSString*)characterName
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"CharacterObject" inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",characterName];
    
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *fetchResults = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:request error:&error]];
    
    if([fetchResults count]) {
        return [fetchResults lastObject];
    }
    
    return nil;
    
}




- (NSString *)generateUuidString
{
    // returns a new autoreleased UUID string
    
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    // transfer ownership of the string
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}


-(void)calculateAllianceLife:(int*)allianceLife andEnemyLife:(int*)enemyLife byAllianceObject:(CharacterObject *)allianceObject andEnemyObject:(CharacterObject *)enemyObject
{
    int allianceAT = [allianceObject.at intValue];
    int enemyAT = [enemyObject.at intValue];
    int allianceDF = [allianceObject.df intValue];
    int enemyDF = [enemyObject.df intValue];
    int randomPoint = arc4random()%2;
    
    int allianceLifeLeft =enemyAT- allianceDF;
    int enemyLifeLeft = allianceAT - enemyDF;
    if (allianceLifeLeft<0) {
        allianceLifeLeft =0;
    }
    if (enemyLifeLeft<0) {
        enemyLifeLeft =0;
    }
    
    int allianceLifeDown = allianceLifeLeft+randomPoint;
    if (allianceLifeDown<0) {
        allianceLifeDown=0;
    }
    
    *allianceLife = *allianceLife - allianceLifeDown;
    randomPoint = arc4random()%2;
    int enemyLifeDown = enemyLifeLeft+randomPoint;
    if (enemyLifeDown<0) {
        enemyLifeDown=0;
    }
    *enemyLife = *enemyLife - enemyLifeDown;
    
    if (*allianceLife<0) {
        *allianceLife=0;
    }
    if (*enemyLife<0) {
        *enemyLife=0;
    }
    
}


@end
