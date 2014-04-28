//
//  Character.m
//  emblemKnight
//
//  Created by Administrator on 4/20/14.
//  Copyright 2014 Administrator. All rights reserved.
//



#import "Character.h"
#import "cocos2d-ui.h"
#import "CCAnimation.h"
#import "gameConstants.h"




@implementation Character{
  CCSpriteBatchNode *_spriteSheet;
  CCAction *_moveAnimation;
  CCAction *_battbleMoveAnimation;
}

@synthesize originalFrame;

- (void)onEnter {
  self.userInteractionEnabled = TRUE;
  [super onEnter];
}

-(void)addMoveAnimationWithTextPointInSheet:(CGPoint)spritePoint
{
  if (_moveAnimation==nil) {
    

  CCSpriteBatchNode *walkingSheet = [CCSpriteBatchNode batchNodeWithFile:@"langrissa.png"];
  NSMutableArray *walkAnimFrames = [NSMutableArray array];
  
  for(int i = 0; i <= 1; i++)
  {
    CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:walkingSheet.texture rectInPixels:CGRectMake((spritePoint.x-1)*spriteWidth, spriteHeight*(spritePoint.y-1)+spriteHeight*i, spriteWidth, spriteHeight) rotated:NO offset:ccp(0,0) originalSize:CGSizeMake(spriteWidth, spriteHeight)];
    [walkAnimFrames addObject:frame];
    
  }
  CCAnimation *walkAnim = [CCAnimation
                           animationWithSpriteFrames:walkAnimFrames delay:defaultSpriteAnimationDelayTime];
  self.originalFrame=[walkAnimFrames objectAtIndex:0];
  CCActionAnimate *animationAction = [CCActionAnimate actionWithAnimation:walkAnim];
    
  CCActionRepeatForever *repeatingAnimation = [CCActionRepeatForever actionWithAction:animationAction];


  _moveAnimation=repeatingAnimation;
      }
  if (![self isRunningInActiveScene]) {
    [self forceSetInActiveScene];
  }
  [self runAction:_moveAnimation];
}

-(void)stopMoveAnimation
{
  [self stopAction:_moveAnimation];
  if (self.originalFrame!=nil) {
    [self performSelector:@selector(setSpriteFrame:) withObject:self.originalFrame afterDelay:defaultSpriteAnimationDelayTime];
  }
}


-(void)addBattleMoveAnimationWithTextPointInSheet:(CGPoint)spritePoint
{
  if (_battbleMoveAnimation==nil) {
    
    
    CCSpriteBatchNode *walkingSheet = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@_重骑兵.png",self.name]];
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    
    for(int i = 0; i <= 2; i++)
    {
      CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:walkingSheet.texture rectInPixels:CGRectMake((spritePoint.x-1)*battleSceneSpriteWidth+i*battleSceneSpriteWidth, 0, battleSceneSpriteWidth, battleSceneSpriteHeight) rotated:NO offset:ccp(0,0) originalSize:CGSizeMake(battleSceneSpriteWidth, battleSceneSpriteHeight)];
      [walkAnimFrames addObject:frame];
      
    }
    CCAnimation *walkAnim = [CCAnimation
                             animationWithSpriteFrames:walkAnimFrames delay:defaultBattbleSceneCharacterAnimationDelayTime];
    self.originalFrame=[walkAnimFrames objectAtIndex:0];
    CCActionAnimate *animationAction = [CCActionAnimate actionWithAnimation:walkAnim];
    
    CCActionRepeatForever *repeatingAnimation = [CCActionRepeatForever actionWithAction:animationAction];
    
    
    _battbleMoveAnimation=repeatingAnimation;
  }
  
  [self runAction:_battbleMoveAnimation];
}

-(void)stopBattleMoveAnimation
{
  [self stopAction:_battbleMoveAnimation];
  if (self.originalFrame!=nil) {
    [self performSelector:@selector(setSpriteFrame:) withObject:self.originalFrame afterDelay:defaultBattbleSceneCharacterAnimationDelayTime];
  }
}





@end
