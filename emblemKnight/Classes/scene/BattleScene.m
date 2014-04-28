//
//  BattleScene.m
//  emblemKnight
//
//  Created by Administrator on 4/25/14.
//  Copyright 2014 Administrator. All rights reserved.
//

#import "BattleScene.h"



@implementation BattleScene{
  Character *_allianceCommander;
  Character *_enemyCommander;
  CCSprite *mBG;

}
@synthesize allianceCommanderName;
@synthesize enemyCommanderName;

+ (BattleScene *)battleScene
{
  return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
  // Apple recommend assigning self with supers return value
  self = [super init];
  if (!self) return(nil);

 
 
  
  return self;
}

-(id)initWithAllianceCommander:(NSString *)allianceName andEnemyCommander:(NSString *)enemyName
{
  self = [self init];
  self.allianceCommanderName=allianceName;
  self.enemyCommanderName=enemyName;
  return self;
}

-(void)onEnter
{
  self.userInteractionEnabled = NO;
  [self loadBG];
  [self loadAvatarsAndTexts];
  [self loadArmy];
  [self runBattbleScript];
 // [self performSelector:@selector(sendBattleSceneEndNotification) withObject:nil afterDelay:4 ];
  [super onEnter];
}

-(void)loadBG
{
  NSString *tex = @"battle_background_grass.png";
  mBG = [CCSprite spriteWithImageNamed:tex];
  [self scaleCharacter:mBG withWidth:self.contentSize.width andHeight:self.contentSize.height];
  mBG.position=ccp(0.5f*self.contentSize.width, 0.5f*self.contentSize.height);
  [self addChild:mBG];

}

-(void)loadAvatarsAndTexts
{
  [self loadAllianceAvatar];
  [self loadEnemyAvatar];
  [self loadAllianceNameText];
  [self loadEnemyNameText];
}

-(void)loadAllianceAvatar
{
  CCSprite *allianceAvatar = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%@_icon.gif",self.allianceCommanderName]];
  allianceAvatar.position=ccp(allianceAvatar.contentSize.width+battleSceneAvatarPaddingX,allianceAvatar.contentSize.height/2+battleSceneAvatarPaddingY);
  [mBG addChild:allianceAvatar];
}

-(void)loadEnemyAvatar
{
  CCSprite *enemyAvatar = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%@_icon.gif",self.enemyCommanderName]];
  enemyAvatar.position=ccp(self.contentSize.width - enemyAvatar.contentSize.width-battleSceneAvatarPaddingX,enemyAvatar.contentSize.height/2+battleSceneAvatarPaddingY);
  [mBG addChild:enemyAvatar];
}


-(void)loadAllianceNameText
{
  CCLabelTTF *label = [CCLabelTTF labelWithString:self.allianceCommanderName fontName:@"HelveticaNeue-Medium" fontSize:14.0f dimensions:CGSizeMake(64, 20)];
  label.position=ccp(64+battleSceneAvatarPaddingX, 64+battleSceneAvatarPaddingY+10);
  label.color = [CCColor whiteColor];
  [label setVerticalAlignment:CCTextAlignmentCenter];
  [label setHorizontalAlignment:CCTextAlignmentCenter];
  [mBG addChild:label];
}

-(void)loadEnemyNameText
{
  CCLabelTTF *label = [CCLabelTTF labelWithString:self.enemyCommanderName fontName:@"HelveticaNeue-Medium" fontSize:14.0f dimensions:CGSizeMake(64, 20)];
  label.position=ccp(self.contentSize.width-64-battleSceneAvatarPaddingX, 64+battleSceneAvatarPaddingY+10);
  label.color = [CCColor whiteColor];
  [label setVerticalAlignment:CCTextAlignmentCenter];
  [label setHorizontalAlignment:CCTextAlignmentCenter];
  [mBG addChild:label];
}


-(void)sendBattleSceneEndNotification
{
  NSNotification *battleSceneEndNotification = [NSNotification notificationWithName:@"battleSceneEndNotification" object:nil];
  [[NSNotificationCenter defaultCenter] performSelector:@selector(postNotification:) withObject:battleSceneEndNotification];
}


-(void)loadArmy
{
  [self loadAllianceCommander];
  [self loadEnemyCommander];
}

-(void)runBattbleScript
{
  [self loadAllianceMoveScript];
  [self loadEnemyMoveScript];
  
  int accessoryAnimationDuration = 2.0;
  [self performSelector:@selector(sendBattleSceneEndNotification) withObject:nil afterDelay:defaultBattleSceneAnimationDuration+accessoryAnimationDuration];
  

}

-(void)loadAllianceMoveScript
{
  //elwin test script
  CGPoint originPoint = _allianceCommander.position;
  CGPoint nodePointGo = ccp(self.contentSize.width-battleSceneSpriteScaleWidth, _allianceCommander.position.y);
  CCAction *nodeActionGo =[CCActionMoveTo actionWithDuration:1.0 position:nodePointGo];
  
  CCAction *nodeActionBack = [CCActionMoveTo actionWithDuration:1.0 position:originPoint];
  [_allianceCommander addBattleMoveAnimationWithTextPointInSheet:CGPointMake(1, 1)];
  CCActionSequence *allianceSequence =[CCActionSequence  actionWithArray:@[
                                                                           [CCActionDelay actionWithDuration:defaultBattbleSceneCharacterAnimationDelayTime],
                                                                           nodeActionGo,
                                                                           [CCActionFlipX actionWithFlipX:YES],
                                                                           nodeActionBack,
                                                                           [CCActionCallBlock actionWithBlock:^{
    [_allianceCommander stopBattleMoveAnimation];
  }],
                                                                           [CCActionFlipX actionWithFlipX:NO],
                                                                        
                                                                           
                                                                           ]];
  [_allianceCommander runAction:allianceSequence];
}

-(void)loadEnemyMoveScript
{
  //leon test script
  CGPoint originPoint = _enemyCommander.position;
  CGPoint nodePointGo = ccp(battleSceneSpriteScaleWidth, _enemyCommander.position.y);
  CCAction *nodeActionGo =[CCActionMoveTo actionWithDuration:1.0 position:nodePointGo];
  
  CCAction *nodeActionBack = [CCActionMoveTo actionWithDuration:1.0 position:originPoint];
  [_enemyCommander addBattleMoveAnimationWithTextPointInSheet:CGPointMake(1, 1)];
  CCActionSequence *enemySequence =[CCActionSequence  actionWithArray:@[
                                                                           [CCActionFlipX actionWithFlipX:YES],
                                                                           [CCActionDelay actionWithDuration:defaultBattbleSceneCharacterAnimationDelayTime],
                                                                           nodeActionGo,
                                                                           [CCActionFlipX actionWithFlipX:NO],
                                                                           nodeActionBack,
                                                                           [CCActionCallBlock actionWithBlock:^{
    [_enemyCommander stopBattleMoveAnimation];
  }],
                                                                           [CCActionFlipX actionWithFlipX:YES]
                                                                           ]];
  [_enemyCommander runAction:enemySequence];
}

-(void)loadAllianceCommander
{
 _allianceCommander= [self addSpriteWithNumber:CGPointMake(1, 1) atPosition:CGPointMake(battleSceneSpriteScaleWidth, battleSceneCharacterOriginY) withName:self.allianceCommanderName];
  [_allianceCommander setUserInteractionEnabled:NO];
}

-(void)loadEnemyCommander
{
 _enemyCommander= [self addSpriteWithNumber:CGPointMake(1, 1) atPosition:CGPointMake(self.contentSize.width-battleSceneSpriteScaleWidth, battleSceneCharacterOriginY) withName:self.enemyCommanderName];
  [_enemyCommander setUserInteractionEnabled:NO];
}


-(Character*)addSpriteWithNumber:(CGPoint)spritePoint atPosition:(CGPoint)spritePositionInScreen withName:(NSString *)name
{
  CCSpriteBatchNode *walkingSheet = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@_重骑兵.png",name]];
  
  [self addChild:walkingSheet];
  
  Character *walkingSprite = [Character spriteWithTexture:walkingSheet.texture rect:CGRectMake((spritePoint.x-1)*battleSceneSpriteWidth, (spritePoint.y-1)*battleSceneSpriteHeight, battleSceneSpriteWidth, battleSceneSpriteHeight)];

  [self scaleCharacter:walkingSprite withWidth:battleSceneSpriteScaleWidth andHeight:battbleSceneSpriteScaleHeight];
  [walkingSprite setName:name];
  walkingSprite.position  = ccp(spritePositionInScreen.x,spritePositionInScreen.y);
  

  [self addChild:walkingSprite];
  return walkingSprite;
}

-(void)scaleCharacter:(CCSprite *)character withWidth:(float)width andHeight:(float)height
{
  [character setScaleX: width/character.contentSize.width];
  [character setScaleY: height/character.contentSize.height];
}





@end
