//
//  CharacterBattleMenu.m
//  emblemKnight
//
//  Created by Xi Zhang on 5/10/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import "CharacterBattleMenu.h"


@implementation CharacterBattleMenu{
    CCLayoutBox *_menuBox;
}

-(CharacterBattleMenu *)initWithCharacter:(CharacterObject *)character delegateNode:(CCNode*)delegate andMapNode:(CCNode *)mapNode;
{
    self = [super init];
    if (self) {
        self.responseDelegate=delegate;
        self.characterDataObject=character;
        self.mapNode=mapNode;
    }
    return self;
}

-(void)popBattleMenuForPoint:(CGPoint)point
{
    CCLayoutBox *layoutBox = [CCLayoutBox  node];
    layoutBox.direction=CCLayoutBoxDirectionVertical;
    layoutBox.anchorPoint = ccp(0.5f, 0.5f);
    layoutBox.spacing=0.5f;

    CCButton *attackButton = [CCButton buttonWithTitle:@"攻击"];
    CCButton *defenseButton = [CCButton buttonWithTitle:@"防御"];
    CCButton *magicButton = [CCButton buttonWithTitle:@"魔法"];
    CCButton *endButton = [CCButton buttonWithTitle:@"待机/结束"];
    
    [layoutBox addChild:endButton];
    [layoutBox addChild:magicButton];
    [layoutBox addChild:defenseButton];
    [layoutBox addChild:attackButton];
    
    layoutBox.position=point;
    _menuBox=layoutBox;
    
    [self.mapNode addChild:layoutBox];
    
}

-(void)dismissBattleMenu
{
    [_menuBox stopAllActions];
    [self.mapNode removeChild:_menuBox];
    _menuBox=nil;
}

@end
