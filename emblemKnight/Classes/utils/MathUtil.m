//
//  MathUtil.m
//  emblemKnight
//
//  Created by Administrator on 4/20/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import "MathUtil.h"

@implementation MathUtil

+(float)distanceBetweenPoint1:(CGPoint)p1 andPoint2:(CGPoint)p2
{
  CGFloat xDist = (p2.x - p1.x);
  CGFloat yDist = (p2.y - p1.y);
  CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
  return distance;
}

@end
