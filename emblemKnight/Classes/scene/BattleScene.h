//
//  BattleScene.h
//  emblemKnight
//
//  Created by Administrator on 4/25/14.
//  Copyright 2014 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Character.h"
#import "gameConstants.h"

@interface BattleScene : CCScene {
    
}

@property (strong,nonatomic)NSString *allianceCommanderName;
@property (strong,nonatomic)NSString *enemyCommanderName;



+ (BattleScene *)battleScene;
//- (id)init;
-(id)initWithAllianceCommander:(NSString *)allianceName andEnemyCommander:(NSString *)enemyName;
@end
