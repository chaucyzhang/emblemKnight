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
  MPMoviePlayerController *_openingVideoPlayer;
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
	return self;
}

-(void)onEnter{
  [self playOpeningVideo];
  [super onEnter];
}

-(void)loadTitleScreen
{
  CCSprite *logo = [CCSprite spriteWithImageNamed:@"Langrisser2.png"];
  [logo setOpacity:0.0];
  logo.position=ccp(0.5f*self.contentSize.width, 0.5f*self.contentSize.height);
  [logo setScaleX: self.contentSize.width/logo.contentSize.width];
  [logo setScaleY: self.contentSize.height/logo.contentSize.height];
  [self addChild:logo];
 
  [self addPanGesutureFor:@selector(logoTapped:)];
  CCLabelTTF *label = [CCLabelTTF labelWithString:@"Click Screen To Start A New Game" fontName:@"Zapfino" fontSize:12.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor whiteColor];
    label.position = ccp(0.5f, 0.2f);
    [self addChild:label];

  CCActionBlink *blinker = [CCActionBlink actionWithDuration: 1.5 blinks: 1];
  CCActionRepeatForever *repeatingAnimation = [CCActionRepeatForever actionWithAction:blinker];
  _startLabel=label;
  [label runAction:repeatingAnimation];
  [logo runAction:[CCActionFadeIn actionWithDuration:2.0]];
  [self loadOP];

}

-(void)playOpeningVideo
{
  CGSize winSize = [[CCDirector sharedDirector] viewSize];
  
  NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Langrisser2Opening" ofType:@"mp4"]];
  MPMoviePlayerController * mpc;
  mpc = [[MPMoviePlayerController alloc] initWithContentURL:url];
  [mpc setFullscreen:YES animated:NO];
  mpc.shouldAutoplay = YES;
  mpc.view.backgroundColor = [UIColor whiteColor];
  mpc.view.frame = CGRectMake(0.0f, 0.0f, winSize.width, winSize.height);
  
  [mpc setScalingMode:MPMovieScalingModeFill];
  [mpc setControlStyle:MPMovieControlStyleNone];
  [mpc setMovieSourceType:MPMovieSourceTypeFile];
  [mpc setRepeatMode:MPMovieRepeatModeNone];
  _openingVideoPlayer = mpc;
  [[[CCDirector sharedDirector] view] addSubview:mpc.view];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(moviePlayBackDidFinish:)
                                               name:MPMoviePlayerPlaybackDidFinishNotification 
                                             object:mpc];
  [self addPanGesutureOnMoviePlayerFor:@selector(logoTapped:)];
  
  [mpc play];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
  MPMoviePlayerController *player = [notification object];
  [[NSNotificationCenter defaultCenter]
   removeObserver:self
   name:MPMoviePlayerPlaybackDidFinishNotification
   object:player];
  
  if ([player respondsToSelector:@selector(setFullscreen:animated:)])
  {
    [player.view removeFromSuperview];
  }
  _openingVideoPlayer=nil;
  [self loadTitleScreen];
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
  if (_openingVideoPlayer!=nil) {
    [_openingVideoPlayer stop];
   // [self loadTitleScreen];
  }
  else{
  [_startLabel stopAllActions];
  _startLabel=nil;
  [self loadGame];
  }
}

- (UITapGestureRecognizer *)addPanGesutureFor:(SEL)selector {
  UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];

  [[[CCDirector sharedDirector] view] addGestureRecognizer:recognizer];
  _screenTouchGesture=recognizer;
  return recognizer;
  
}

- (UITapGestureRecognizer *)addPanGesutureOnMoviePlayerFor:(SEL)selector {
  UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
  recognizer.delegate=self;
  [[_openingVideoPlayer view] addGestureRecognizer:recognizer];
  _screenTouchGesture=recognizer;
  return recognizer;
  
}



- (void)removePanGesutre:(UIGestureRecognizer *)gr {
  [[[CCDirector sharedDirector] view] removeGestureRecognizer:gr];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
  return YES;
}
// this enables you to handle multiple recognizers on single view
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  return YES;
}

-(void)dealloc{
 // [[OALSimpleAudio sharedInstance] stopBg];
  [self removePanGesutre:_screenTouchGesture];
}

// -----------------------------------------------------------------------
@end
