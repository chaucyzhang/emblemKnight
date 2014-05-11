//
//  CharacterBattleMenu.h
//  emblemKnight
//
//  Created by Xi Zhang on 5/10/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d-ui.h"
#import "CharacterObject.h"

@interface CharacterBattleMenu : CCNode

@property (strong, nonatomic) CCNode *responseDelegate;
@property (strong, nonatomic) CCNode *mapNode;
@property (strong, nonatomic) CharacterObject *characterDataObject;


-(CharacterBattleMenu *)initWithCharacter:(CharacterObject *)character delegateNode:(CCNode*)delegate andMapNode:(CCNode *)mapNode;
-(void)popBattleMenuForPoint:(CGPoint)point;
-(void)dismissBattleMenu;

@end
