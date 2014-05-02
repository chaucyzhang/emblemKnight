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
  CCLabelTTF *_allianceLife;
  CCLabelTTF *_enemyLife;
  
  CCAction *_allianceMoveAction;
  CCAction *_enemyMoveAction;
  
  int _allianceLifeData;
  int _enemyLifeData;
  
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
  [self setLifeDatas];
  [self runBattbleScript];
  [self runLifeCalculationScript];
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

-(void)setLifeDatas
{
    _allianceLifeData = [_allianceCommander.characterObject.hp intValue];
    _enemyLifeData = [_enemyCommander.characterObject.hp intValue];;
}

-(void)loadAvatarsAndTexts
{
  [self loadAllianceAvatar];
  [self loadEnemyAvatar];
  [self loadAllianceNameText];
  [self loadEnemyNameText];
  [self loadAllianceProperties];
  [self loadEnemyProperties];
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

-(void)loadAllianceProperties
{
  NSString *atString =@"25 + 0";
  UIFont *commonFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0];
  CGSize size = [atString sizeWithFont:commonFont];
  CCLabelTTF *atlabel = [CCLabelTTF labelWithString:atString fontName:@"HelveticaNeue-Medium" fontSize:18.0f dimensions:size];
  atlabel.position=ccp(self.contentSize.width/2-battleSceneDataXpaddingFromCenter-atlabel.contentSize.width/2, battleSceneATYpadding);
  atlabel.color = [CCColor whiteColor];
  [atlabel setVerticalAlignment:CCTextAlignmentCenter];
  [atlabel setHorizontalAlignment:CCTextAlignmentCenter];
  [mBG addChild:atlabel];
  NSString *dfString =@"17 + 0";
 
  size = [dfString sizeWithFont:commonFont];
  
  CCLabelTTF *dflabel = [CCLabelTTF labelWithString:dfString fontName:@"HelveticaNeue-Medium" fontSize:18.0f dimensions:size];
  dflabel.position=ccp(self.contentSize.width/2-battleSceneDataXpaddingFromCenter-dflabel.contentSize.width/2, battleSceneDFYpadding);
  dflabel.color = [CCColor whiteColor];
  [dflabel setVerticalAlignment:CCTextAlignmentCenter];
  [dflabel setHorizontalAlignment:CCTextAlignmentCenter];
  [mBG addChild:dflabel];
  
  NSString *terrainString =@"0 + 0";
  commonFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0];
  size = [terrainString sizeWithFont:commonFont];

  
  CCLabelTTF *terrainlabel = [CCLabelTTF labelWithString:terrainString fontName:@"HelveticaNeue-Medium" fontSize:18.0f dimensions:size];
  terrainlabel.position=ccp(self.contentSize.width/2-battleSceneDataXpaddingFromCenter-terrainlabel.contentSize.width/2, battleSceneTerrainYpadding);
  terrainlabel.color = [CCColor whiteColor];
  [terrainlabel setVerticalAlignment:CCTextAlignmentCenter];
  [terrainlabel setHorizontalAlignment:CCTextAlignmentCenter];
  [mBG addChild:terrainlabel];
  
  NSString *lifeString = @"10";
  commonFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:34.0];
  size = [terrainString sizeWithFont:commonFont];
  CCLabelTTF *life =[CCLabelTTF labelWithString:lifeString fontName:@"HelveticaNeue-Medium" fontSize:34.0f dimensions:size];
  life.position=ccp(battleSceneLifeXPadding, battleSceneLifeYPadding);
  life.color = [CCColor whiteColor];
  _allianceLife=life;
  [life setVerticalAlignment:CCTextAlignmentCenter];
  [life setHorizontalAlignment:CCTextAlignmentCenter];
  [mBG addChild:life];
  
}

-(void)loadEnemyProperties
{
  NSString *atString =@"37 + 0";
  UIFont *commonFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0];
  CGSize size = [atString sizeWithFont:commonFont];
  CCLabelTTF *atlabel = [CCLabelTTF labelWithString:atString fontName:@"HelveticaNeue-Medium" fontSize:18.0f dimensions:size];
  atlabel.position=ccp(self.contentSize.width/2+battleSceneDataXpaddingFromCenter+atlabel.contentSize.width/2, battleSceneATYpadding);
  atlabel.color = [CCColor whiteColor];
  [atlabel setVerticalAlignment:CCTextAlignmentCenter];
  [atlabel setHorizontalAlignment:CCTextAlignmentCenter];
  [mBG addChild:atlabel];
  NSString *dfString =@"27 + 0";
  
  size = [dfString sizeWithFont:commonFont];
  
  CCLabelTTF *dflabel = [CCLabelTTF labelWithString:dfString fontName:@"HelveticaNeue-Medium" fontSize:18.0f dimensions:size];
  dflabel.position=ccp(self.contentSize.width/2+battleSceneDataXpaddingFromCenter+dflabel.contentSize.width/2, battleSceneDFYpadding);
  dflabel.color = [CCColor whiteColor];
  [dflabel setVerticalAlignment:CCTextAlignmentCenter];
  [dflabel setHorizontalAlignment:CCTextAlignmentCenter];
  [mBG addChild:dflabel];
  
  NSString *terrainString =@"0 + 0";
  commonFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0];
  size = [terrainString sizeWithFont:commonFont];
  
  
  CCLabelTTF *terrainlabel = [CCLabelTTF labelWithString:terrainString fontName:@"HelveticaNeue-Medium" fontSize:18.0f dimensions:size];
  terrainlabel.position=ccp(self.contentSize.width/2+battleSceneDataXpaddingFromCenter+terrainlabel.contentSize.width/2, battleSceneTerrainYpadding);
  terrainlabel.color = [CCColor whiteColor];
  [terrainlabel setVerticalAlignment:CCTextAlignmentCenter];
  [terrainlabel setHorizontalAlignment:CCTextAlignmentCenter];
  [mBG addChild:terrainlabel];
  
  NSString *lifeString = @"10";
  commonFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:34.0];
  size = [terrainString sizeWithFont:commonFont];
  CCLabelTTF *life =[CCLabelTTF labelWithString:lifeString fontName:@"HelveticaNeue-Medium" fontSize:34.0f dimensions:size];
  life.position=ccp(self.contentSize.width- battleSceneLifeXPadding, battleSceneLifeYPadding);
  life.color = [CCColor whiteColor];
  _enemyLife=life;
  [life setVerticalAlignment:CCTextAlignmentCenter];
  [life setHorizontalAlignment:CCTextAlignmentCenter];
  [mBG addChild:life];
  
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
  
  int accessoryAnimationDuration = 4.0;
  [self performSelector:@selector(sendBattleSceneEndNotification) withObject:nil afterDelay:defaultBattleSceneAnimationDuration+accessoryAnimationDuration];
}

-(void)runLifeCalculationScript
{
  int oldAllianceLife = _allianceLifeData;
  _allianceLifeData=3;
  NSMutableArray *lifeDownArray =[NSMutableArray array];
  [lifeDownArray addObject:[CCActionDelay actionWithDuration:0.5]];
  for (int i=oldAllianceLife; i>=_allianceLifeData; i--) {
    //add life numbers as string into array
//    [lifeDownArray addObject:[NSString stringWithFormat:@"%d",i]];
    [lifeDownArray addObject:[CCActionDelay actionWithDuration:0.03]];
    [lifeDownArray addObject:
     [CCActionCallBlock actionWithBlock:^{
      [_allianceLife setString:[NSString stringWithFormat:@"%d",i]];
    }]];
  }
  
  CCActionSequence *updateSequence = [CCActionSequence actionWithArray:lifeDownArray];
  [_allianceLife runAction:updateSequence];
  
  int oldEnemyLife = _enemyLifeData;
  _enemyLifeData=0;
  
 
  
  NSMutableArray *enemylifeDownArray =[NSMutableArray array];
  [enemylifeDownArray addObject:[CCActionDelay actionWithDuration:0.5]];
  for (int i=oldEnemyLife; i>=_enemyLifeData; i--) {
    //add life numbers as string into array
    //    [lifeDownArray addObject:[NSString stringWithFormat:@"%d",i]];
    [enemylifeDownArray addObject:[CCActionDelay actionWithDuration:0.03]];
    [enemylifeDownArray addObject:
     [CCActionCallBlock actionWithBlock:^{
      [_enemyLife setString:[NSString stringWithFormat:@"%d",i]];
    }]];

  }
//    [enemylifeDownArray addObject:[CCActionCallBlock actionWithBlock:^{
//         }]];
  

  CCActionSequence *updateEnemySequence = [CCActionSequence actionWithArray:enemylifeDownArray];
  [self runAction:updateEnemySequence];
  
 
  [self performSelector:@selector(runEnemyDownAnimation) withObject:nil afterDelay:1.25];

}


-(void)runEnemyDownAnimation
{
  if(_enemyLifeData==0){
//    [_enemyCommander stopAction:_enemyMoveAction];
//    [_enemyCommander stopBattleMoveAnimation];
    [_enemyCommander stopAllActions];
  
    CCSpriteFrame *enemyCommanderDownFrame = [_enemyCommander getBattleDieSpriteWithName:_enemyCommander.name andTextPointInSheet:CGPointMake(5, 1)];
    CGPoint previousEnemyPoint = _enemyCommander.position;
    previousEnemyPoint=ccp((int)previousEnemyPoint.x, (int)previousEnemyPoint.y);
    //    [enemyCommanderDownSprite setPosition:previousEnemyPoint];
//    [_enemyCommander performSelector:@selector(setSpriteFrame:) withObject:enemyCommanderDownFrame afterDelay:defaultBattbleSceneCharacterAnimationDelayTime];
    [_enemyCommander setSpriteFrame:enemyCommanderDownFrame];
    ccBezierConfig curve;
    
    curve.controlPoint_1=ccp(previousEnemyPoint.x, previousEnemyPoint.y+100);
    curve.controlPoint_2=ccp(previousEnemyPoint.x+100, previousEnemyPoint.y+100);
    curve.endPosition=ccp(previousEnemyPoint.x+100, previousEnemyPoint.y-24);
    id bezierCurveAction = [CCActionBezierTo actionWithDuration:0.6 bezier:curve];
    
    CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:1.0];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[bezierCurveAction,fadeOut]];
    [_enemyCommander runAction:sequence];
//    [_enemyCommander performSelector:@selector(runAction:) withObject:bezierCurveAction afterDelay:defaultBattbleSceneCharacterAnimationDelayTime];
  }


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
  _allianceMoveAction=allianceSequence;
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
//                                                                           [CCActionFlipX actionWithFlipX:YES],
                                                                           [CCActionDelay actionWithDuration:defaultBattbleSceneCharacterAnimationDelayTime],
                                                                           nodeActionGo,
                                                                           [CCActionFlipX actionWithFlipX:NO],
                                                                           nodeActionBack,
                                                                           [CCActionCallBlock actionWithBlock:^{
    [_enemyCommander stopBattleMoveAnimation];
  }],
                                                                           [CCActionFlipX actionWithFlipX:YES]
                                                                           ]];
  _enemyMoveAction=enemySequence;
  [_enemyCommander runAction:enemySequence];
}

-(void)loadAllianceCommander
{
   _allianceCommander= [self addSpriteWithNumber:CGPointMake(1, 1) atPosition:CGPointMake(battleSceneSpriteScaleWidth, battleSceneCharacterOriginY) withName:self.allianceCommanderName];
  [_allianceCommander setUserInteractionEnabled:NO];
    CharacterObject *elwin;
    elwin=[[GameManager manager] getCharacterObjectByName:self.allianceCommanderName];
    if (elwin==nil) {
        elwin = [[GameManager manager] insertCharacterIntoDB];
        [elwin setName:self.allianceCommanderName];
        [elwin setHp:[NSNumber numberWithInteger:10]];
        [elwin setMp:[NSNumber numberWithInteger:0]];
        [elwin setAt:[NSNumber numberWithInteger:25]];
        [elwin setDf:[NSNumber numberWithInteger:17]];
        [[GameManager manager] saveContext];
    }

    [_allianceCommander setCharacterObject:elwin];
    
}

-(void)loadEnemyCommander
{
 _enemyCommander= [self addSpriteWithNumber:CGPointMake(1, 1) atPosition:CGPointMake(self.contentSize.width-battleSceneSpriteScaleWidth, battleSceneCharacterOriginY) withName:self.enemyCommanderName];
   [_enemyCommander setFlipX:YES];
  [_enemyCommander setUserInteractionEnabled:NO];
    CharacterObject *leon;
    
    leon=[[GameManager manager] getCharacterObjectByName:self.enemyCommanderName];
    if (leon==nil) {
    CharacterObject *leon = [[GameManager manager] insertCharacterIntoDB];
    [leon setName:self.enemyCommanderName];
    [leon setHp:[NSNumber numberWithInteger:10]];
    [leon setMp:[NSNumber numberWithInteger:0]];
    [leon setAt:[NSNumber numberWithInteger:32]];
    [leon setDf:[NSNumber numberWithInteger:24]];
    [[GameManager manager] saveContext];
    }
     [_enemyCommander setCharacterObject:leon];

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
