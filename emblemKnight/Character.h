//
//  Character.h
//  emblemKnight
//
//  Created by Administrator on 4/20/14.
//  Copyright 2014 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Character : CCSprite {
    
}
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)CCSpriteFrame *originalFrame;

-(void)addMoveAnimationWithTextPointInSheet:(CGPoint)spritePoint;
-(void)stopMoveAnimation;
@end
