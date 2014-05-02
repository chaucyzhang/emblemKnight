//
//  CharacterObject.h
//  emblemKnight
//
//  Created by Xi Zhang on 5/1/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CharacterObject : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * at;
@property (nonatomic, retain) NSNumber * df;
@property (nonatomic, retain) NSNumber * hp;
@property (nonatomic, retain) NSNumber * mp;
@property (nonatomic, retain) NSString * characterID;

@end
