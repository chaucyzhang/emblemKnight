//
//  HelloWorldScene.h
//  emblemKnight
//
//  Created by Administrator on 4/20/14.
//  Copyright Administrator 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "gameConstants.h"
#import "CharacterBattleMenu.h"



// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface HelloWorldScene : CCScene<CCScrollViewDelegate>

// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene;
- (id)init;

// -----------------------------------------------------------------------
@end