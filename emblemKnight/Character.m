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
  
  [self runAction:_moveAnimation];
}

-(void)stopMoveAnimation
{
  [self stopAction:_moveAnimation];
  if (self.originalFrame!=nil) {
    [self performSelector:@selector(setSpriteFrame:) withObject:self.originalFrame afterDelay:defaultSpriteAnimationDelayTime];
  }
}


@end
