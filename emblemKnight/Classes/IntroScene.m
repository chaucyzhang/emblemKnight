//
//  IntroScene.m
//  emblemKnight
//
//  Created by Administrator on 4/20/14.
//  Copyright Administrator 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "HelloWorldScene.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------





@implementation IntroScene{
  UITapGestureRecognizer *_screenTouchGesture;
  CCLabelTTF *_startLabel;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
  CCSprite *logo = [CCSprite spriteWithImageNamed:@"Langrisser2.png"];
  logo.position=ccp(0.5f*self.contentSize.width, 0.5f*self.contentSize.height);
  [logo setScaleX: self.contentSize.width/logo.contentSize.width];
  [logo setScaleY: self.contentSize.height/logo.contentSize.height];
  [self addChild:logo];
 // [self performSelector:@selector(onAppLoad) withObject:nil afterDelay:2.0];
  [self addPanGesutureFor:@selector(logoTapped:)];
  CCLabelTTF *label = [CCLabelTTF labelWithString:@"Click Screen To Start A New Game" fontName:@"Zapfino" fontSize:12.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor whiteColor];
    label.position = ccp(0.5f, 0.2f); // Middle of screen
    [self addChild:label];
 
  CCActionBlink *blinker = [CCActionBlink actionWithDuration: 1.5 blinks: 1];
  CCActionRepeatForever *repeatingAnimation = [CCActionRepeatForever actionWithAction:blinker];
  _startLabel=label;
  [label runAction:repeatingAnimation];
  [self loadOP];
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)loadGame{
    // start spinning scene with transition
    [[OALSimpleAudio sharedInstance] stopBg];
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]
                               withTransition:[CCTransition transitionFadeWithDuration:1.0 ]];
}

-(void)loadOP
{
  [[OALSimpleAudio sharedInstance] playBg:@"openning.mp3" loop:YES];
}

-(void)logoTapped:(UIGestureRecognizer *)gesture
{
  [_startLabel stopAllActions];
  _startLabel=nil;
  [self loadGame];
}

- (UITapGestureRecognizer *)addPanGesutureFor:(SEL)selector {
  UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];

  [[[CCDirector sharedDirector] view] addGestureRecognizer:recognizer];
  _screenTouchGesture=recognizer;
  return recognizer;
}

- (void)removePanGesutre:(UIGestureRecognizer *)gr {
  [[[CCDirector sharedDirector] view] removeGestureRecognizer:gr];
}

-(void)dealloc{
 // [[OALSimpleAudio sharedInstance] stopBg];
  [self removePanGesutre:_screenTouchGesture];
}

// -----------------------------------------------------------------------
@end
