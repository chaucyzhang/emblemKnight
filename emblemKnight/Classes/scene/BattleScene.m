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
  [self loadArmy];
  [self runBattbleScript];
  [super onEnter];
}

-(void)loadBG
{
  NSString *tex = @"battle_background_grass.png";
  mBG = [CCSprite spriteWithImageNamed:tex];
  [self scaleCharacter:mBG withWidth:self.contentSize.width andHeight:self.contentSize.height];
  mBG.position=ccp(0.5f*self.contentSize.width, 0.5f*self.contentSize.height);
  [self addChild:mBG];
  NSLog(@"%f,%f",self.contentSize.width,self.contentSize.height);
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
                                                                           [CCActionDelay actionWithDuration:defualtBattbleSceneCharacterAnimationDelayTime],
                                                                           nodeActionGo,
                                                                           [CCActionFlipX actionWithFlipX:YES],
                                                                           nodeActionBack,
                                                                           [CCActionCallBlock actionWithBlock:^{
    [_allianceCommander stopBattleMoveAnimation];
  }],
                                                                           [CCActionFlipX actionWithFlipX:NO]
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
                                                                           [CCActionDelay actionWithDuration:defualtBattbleSceneCharacterAnimationDelayTime],
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
 _allianceCommander= [self addSpriteWithNumber:CGPointMake(1, 1) atPosition:CGPointMake(battleSceneSpriteScaleWidth, self.contentSize.height/2) withName:self.allianceCommanderName];
  [_allianceCommander setUserInteractionEnabled:NO];
}

-(void)loadEnemyCommander
{
 _enemyCommander= [self addSpriteWithNumber:CGPointMake(1, 1) atPosition:CGPointMake(self.contentSize.width-battleSceneSpriteScaleWidth, self.contentSize.height/2) withName:self.enemyCommanderName];
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
