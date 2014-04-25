//
//  HelloWorldScene.m
//  emblemKnight
//
//  Created by Administrator on 4/20/14.
//  Copyright Administrator 2014. All rights reserved.
//
// -----------------------------------------------------------------------
#define spriteWidth 25.6
#define spriteHeight 28.4

#define characterScaleWidth 32
#define characterScaleHeight 32

#import "HelloWorldScene.h"
#import "IntroScene.h"
#import "CCAnimation.h"
#import "Character.h"
#import "MathUtil.h"




// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
  NSMutableArray *_characterList;
  NSMutableDictionary *_characterPositionInSheetMap;
  CCScrollView *_stageMapView;
  CCSprite *_sprite;
  CCSprite *mBG;
  CCSprite *_activeIcon;
  CCSprite *_activeConversationBox;
  CCSprite *_activeCharacterNameBox;
  CCLabelTTF *_activeConversationTextLabel;
  NSString *_activeCharacterName;

  
  Character *_lancer;
  Character *_elwin;
  Character *_hain;
  Character *_leon;
  Character *_activeCharacter;
  
  int _currentConversationNumber;

  
  NSDictionary *_conversationDictionary;
  
  BOOL _isTryingToMoveCharacter;
  BOOL _isScrollingMap;
}


// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
  return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
  // Apple recommend assigning self with supers return value
  self = [super init];
  if (!self) return(nil);
  
  // Enable touch handling on scene node
  self.userInteractionEnabled = NO;
  [self initAccessories];
  [self registerGameNotifications];
  [self loadConversationInCacheForStage:1];
  [self initBackground];
  [self initCharacterList];
  [self initCharacterPositionInSheetMap];
  [self loadCharacters];
  [self loadBGM];

  return self;
}

-(void)initAccessories
{
  _currentConversationNumber=1;
}

-(void)registerGameNotifications
{
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(conversationEndded:) name:@"conversationEndNotification" object:nil];
}



-(void)initCharacterList
{
  if (_characterList==nil&&_characterList.count==0) {
    _characterList=[NSMutableArray array];
  }
}

-(void)initCharacterPositionInSheetMap
{
  if (_characterPositionInSheetMap==nil) {
    _characterPositionInSheetMap=[NSMutableDictionary dictionary];
  }
}

-(void)initBackground
{
  NSString *tex = @"Stage1.png";
  
  mBG = [CCSprite spriteWithImageNamed:tex];
  CCScrollView *scrollView = [CCScrollView node];
  scrollView.contentNode=mBG;
  scrollView.position = ccp(0, 0);
  scrollView.bounces=NO;
  [scrollView setUserInteractionEnabled:NO];
  _stageMapView=scrollView;
  _stageMapView.delegate=self;
  [self addChild:scrollView];
  
}

-(void)loadBGM
{
  [[OALSimpleAudio sharedInstance] playBg:@"KnightsErrant.mp3" loop:YES];
}

-(void)loadCharacters
{
  
  //  langriss II
  //lancer
//  CGPoint lancerPoint = CGPointMake(0, 0);
//  CGPoint lancerPosition = CGPointMake(self.contentSize.width/3,self.contentSize.height/2);
//  _lancer= [self addSpriteWithNumber:lancerPoint atPosition:lancerPosition withName:@"lancer"];
  
  
  //Elwin
  CGPoint elWinPoint = CGPointMake(14, 3);
  CGPoint elWinPosition = CGPointMake(252,170);
  _elwin=[self addSpriteWithNumber:elWinPoint atPosition:elWinPosition withName:@"艾尔文"];
  
  //Hain
  CGPoint hainPoint = CGPointMake(15, 5);
  CGPoint hainPosition = CGPointMake(252,170-characterScaleHeight);
  _hain=[self addSpriteWithNumber:hainPoint atPosition:hainPosition withName:@"hain"];
  
  [_characterList addObject:_elwin];
 // [_characterList addObject:_lancer];
  [_characterList addObject:_hain];
  
 // [_characterPositionInSheetMap setValue:[NSValue valueWithCGPoint:lancerPoint] forKey:_lancer.name];
  [_characterPositionInSheetMap setValue:[NSValue valueWithCGPoint:elWinPoint] forKey:_elwin.name];
  [_characterPositionInSheetMap setValue:[NSValue valueWithCGPoint:hainPoint] forKey:_hain.name];
}

-(void)scaleCharacter:(CCSprite *)character withWidth:(float)width andHeight:(float)height
{
  [character setScaleX: width/character.contentSize.width];
  [character setScaleY: height/character.contentSize.height];
}

-(Character*)addSpriteWithNumber:(CGPoint)spritePoint atPosition:(CGPoint)spritePositionInScreen withName:(NSString *)name
{
  CCSpriteBatchNode *walkingSheet = [CCSpriteBatchNode batchNodeWithFile:@"langrissa.png"];
  
  [self addChild:walkingSheet];
  
  Character *walkingSprite = [Character spriteWithTexture:walkingSheet.texture rect:CGRectMake((spritePoint.x-1)*spriteWidth, (spritePoint.y-1)*spriteHeight, spriteWidth, spriteHeight)];
  
  //  NSMutableArray *walkAnimFrames = [NSMutableArray array];
  //
  //  for(int i = 0; i <= 1; i++)
  //  {
  //    CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:walkingSheet.texture rectInPixels:CGRectMake(spritePoint.x*spriteWidth, spriteHeight*spritePoint.y+spriteHeight*i, spriteWidth, spriteHeight) rotated:NO offset:ccp(0,0) originalSize:CGSizeMake(spriteWidth, spriteHeight)];
  //    [walkAnimFrames addObject:frame];
  //
  //  }
  //  CCAnimation *walkAnim = [CCAnimation
  //                           animationWithSpriteFrames:walkAnimFrames delay:0.4f];
  [self scaleCharacter:walkingSprite withWidth:characterScaleWidth andHeight:characterScaleHeight];
  [walkingSprite setName:name];
  walkingSprite.position  = ccp(spritePositionInScreen.x,spritePositionInScreen.y);
  
  //  CCActionAnimate *animationAction = [CCActionAnimate actionWithAnimation:walkAnim];
  //  CCActionRepeatForever *repeatingAnimation = [CCActionRepeatForever actionWithAction:animationAction];
  //  [walkingSprite runAction:repeatingAnimation];
  [mBG addChild:walkingSprite];
  return walkingSprite;
}

-(void)loadIconAndConversationBoxForCharacter:(NSString *)characterName {
  _activeCharacterName=characterName;
  CCSprite *characterAvatar = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:(@"%@_icon.gif"),characterName]];
  _activeIcon=characterAvatar;
  [self scaleCharacter:characterAvatar withWidth:64.0 andHeight:64.0];

  
  [characterAvatar setContentSize:CGSizeMake(64.0, 64.0)];
  characterAvatar.position=ccp(self.contentSize.width/5, -mBG.contentSize.height+characterAvatar.boundingBox.size.height/2);
  [self addChild:characterAvatar];
  
  CCSprite *conversationBox = [CCSprite spriteWithImageNamed:@"conversationBox.png"];
  _activeConversationBox=conversationBox;

  [self scaleCharacter:conversationBox withWidth:450.0 andHeight:100.0];
  [conversationBox setContentSize:CGSizeMake(450.0, 100.0)];
  conversationBox.position=ccp(characterAvatar.boundingBox.origin.x+conversationBox.boundingBox.size.width/2-kCommonPadding, -mBG.contentSize.height-characterAvatar.boundingBox.size.height);
  [self addChild:conversationBox];
  
  
  CCSprite *characterNameBox = [CCSprite spriteWithImageNamed:@"conversationNameBox.png"];
  _activeCharacterNameBox=characterNameBox;
  
  [self scaleCharacter:characterNameBox withWidth:100.0 andHeight:30.0];
  [characterNameBox setContentSize:CGSizeMake(100.0, 30.0)];
  characterNameBox.position=ccp(characterAvatar.boundingBox.origin.x+characterAvatar.boundingBox.size.width+characterNameBox.boundingBox.size.width/2-4, -mBG.contentSize.height-characterAvatar.boundingBox.size.height+characterNameBox.boundingBox.size.width/2);
  [self addChild:characterNameBox];
  
  NSString *currentString = [self getCurrentConversationTextFromCache:characterName];
  CCLabelTTF *label = [CCLabelTTF labelWithString:currentString fontName:@"HelveticaNeue-Medium" fontSize:20.0f dimensions:conversationBox.contentSize];
 // label.positionType = CCPositionTypeNormalized;
  label.color = [CCColor whiteColor];
  _activeConversationTextLabel=label;
 //   [label setHorizontalAlignment:CCTextAlignmentCenter];
  
  // [label setVerticalAlignment:CCTextAlignmentCenter];
  [conversationBox addChild:label];


   label.position = ccp(conversationBox.contentSize.width/conversationBox.scaleX/2,conversationBox.contentSize.height/conversationBox.scaleY/2);
  
  
  CCLabelTTF *characterNameLabel = [CCLabelTTF labelWithString:characterName fontName:@"HelveticaNeue-Medium" fontSize:25.0f dimensions:characterNameBox.contentSize];
//  characterNameLabel.positionType = CCPositionTypeNormalized;
  characterNameLabel.color = [CCColor whiteColor];
  [characterNameLabel setHorizontalAlignment:CCTextAlignmentCenter];
  [characterNameLabel setVerticalAlignment:CCTextAlignmentCenter];
  [characterNameBox addChild:characterNameLabel];
  
 
  characterNameLabel.position = ccp(characterNameBox.contentSize.width/characterNameBox.scaleX/2,characterNameBox.contentSize.height/characterNameBox.scaleY/2);
 
  
  [self animateConversationToScreen];
}

-(void)animateConversationToScreen
{
  
  CGPoint iconPoint= ccp(self.contentSize.width/5, self.contentSize.height*6/10);
  CCActionMoveTo *moveIconY = [CCActionMoveTo actionWithDuration:defaultConversationBoxAnimationDuration position:iconPoint];
  
  CGPoint characterNameBoxPoint= ccp(_activeCharacterNameBox.position.x, iconPoint.y-_activeIcon.boundingBox.size.height+_activeConversationBox.boundingBox.size.height/2+kCommonPadding+1);
  CCActionMoveTo *moveCharacterNameBoxY = [CCActionMoveTo actionWithDuration:defaultConversationBoxAnimationDuration position:characterNameBoxPoint];
 
  CGPoint conversationBoxPoint= ccp(_activeConversationBox.position.x, iconPoint.y-_activeIcon.boundingBox.size.height-_activeConversationBox.boundingBox.size.height/2-kCommonPadding);
  CCActionMoveTo *moveConversationBoxY = [CCActionMoveTo actionWithDuration:defaultConversationBoxAnimationDuration position:conversationBoxPoint];
  
  [_activeIcon runAction:moveIconY];
  [_activeCharacterNameBox runAction:moveCharacterNameBoxY];
  [_activeConversationBox runAction:moveConversationBoxY];
  
//  NSTimeInterval delay = defaultConversationBoxAnimationDuration+3.0;
//  [self schedule:@selector(updateText) interval:2.0 repeat:kCCRepeatForever delay:delay];
//  [self performSelector:@selector(animateRemoveConversationFrameScreen) withObject:nil afterDelay:delay];
}

-(void)animateRemoveConversationFrameScreen
{
  CGPoint iconPoint=ccp(self.contentSize.width/5, -mBG.contentSize.height+_activeIcon.boundingBox.size.height/2);
  CCActionMoveTo *moveIconY = [CCActionMoveTo actionWithDuration:1.0 position:iconPoint];
  
  CGPoint conversationBoxPoint= ccp(_activeIcon.boundingBox.origin.x+_activeConversationBox.boundingBox.size.width/2-kCommonPadding, -mBG.contentSize.height-_activeIcon.boundingBox.size.height);;
  CCActionMoveTo *moveConversationBoxY = [CCActionMoveTo actionWithDuration:1.0 position:conversationBoxPoint];

  CGPoint characterNameBoxPoint= ccp(_activeIcon.boundingBox.origin.x+_activeIcon.boundingBox.size.width+_activeCharacterNameBox.boundingBox.size.width/2, -mBG.contentSize.height-_activeIcon.boundingBox.size.height+_activeCharacterNameBox.boundingBox.size.width/2);
  CCActionMoveTo *moveCharacterNameBoxY = [CCActionMoveTo actionWithDuration:1.0 position:characterNameBoxPoint];
  
  
  [_activeIcon runAction:moveIconY];
  [_activeCharacterNameBox runAction:moveCharacterNameBoxY];
  [_activeConversationBox runAction:moveConversationBoxY];
}

-(void)loadConversationInCacheForStage:(int)stageNumber
{
  NSString *path = [[NSBundle mainBundle] pathForResource:@"conversations"
                                                   ofType:@"plist"];
  NSDictionary *dict = [[NSDictionary alloc]
                        initWithContentsOfFile:path];
   NSDictionary *stageDict = [dict objectForKey:[NSString stringWithFormat:(@"Stage%d"),stageNumber]];
  _conversationDictionary= [NSDictionary dictionaryWithDictionary:stageDict];
}

-(NSString*)getCurrentConversationTextFromCache:(NSString *)characterName
{
  NSString *name =characterName;
  if (name==nil||name.length==0) {
    name=_activeCharacterName;
  }
  
  if (_conversationDictionary==nil) {
    [self loadConversationInCacheForStage:1];
  }
  
  NSDictionary *characterDict = [_conversationDictionary objectForKey:name];
  NSString *currentText = [characterDict objectForKey:[NSString stringWithFormat:(@"%d"),_currentConversationNumber]];
  _currentConversationNumber+=1;
  return currentText;
}


-(void)updateText
{
  NSString *newText = [self getCurrentConversationTextFromCache:_activeCharacterName];
  if(newText==nil||newText.length==0)
  {
    //no text should stop timer;
 //   [self unschedule:@selector(updateText)];
    [self animateRemoveConversationFrameScreen];
    [self setUserInteractionEnabled:YES];
    [_stageMapView setUserInteractionEnabled:YES];
    return;
  }
  [_activeConversationTextLabel setString:newText];
}

-(void)resetConversationNumber
{
  _currentConversationNumber=0;
}


-(void)runGameScript
{
  
  //scroll to bottom
  CGPoint newPosition =CGPointMake(0,_stageMapView.contentNode.contentSize.height- self.contentSize.height);
//  CGPoint oldPosition =_stageMapView.scrollPosition;
//  float dist = ccpDistance(newPosition, oldPosition);
  
//  float scrollDuration = clampf(dist / kCCScrollViewSnapDurationFallOff, 0, kCCScrollViewSnapDuration);
  
  [_stageMapView setScrollPosition:newPosition animated:YES];
  
  
  
  [self runInitialConversationScript];
}

-(void)runInitialConversationScript
{

  int conversationDuration = 4.0;

  CCActionSequence *sequence = [CCActionSequence actionWithArray:@[
                                                                   //hain
                              //  [CCActionDelay actionWithDuration:duration],
                                [CCActionCallBlock actionWithBlock:^{
    [self loadHainBox];
                                }],
                                [CCActionDelay actionWithDuration:conversationDuration],
                                [CCActionCallBlock actionWithBlock:^{
    [self RunRemoveConversationBoxScript];
  }],
                                //elwin
                             //   [CCActionDelay actionWithDuration:duration],
                                [CCActionCallBlock actionWithBlock:^{
    [self loadElwinBox];
  }],
                                [CCActionDelay actionWithDuration:conversationDuration],
                                [CCActionCallBlock actionWithBlock:^{
    [self RunRemoveConversationBoxScript];
  }],
//Hain2
                          //      [CCActionDelay actionWithDuration:duration],
                                [CCActionCallBlock actionWithBlock:^{
    [self loadHainBox];
  }],
                                [CCActionDelay actionWithDuration:conversationDuration],
                                [CCActionCallBlock actionWithBlock:^{
    [self RunRemoveConversationBoxScript];
  }],
//Elwin2
                          //      [CCActionDelay actionWithDuration:duration],
                                [CCActionCallBlock actionWithBlock:^{
    [self loadElwinBox];
  }],
                                [CCActionDelay actionWithDuration:conversationDuration],
                                [CCActionCallBlock actionWithBlock:^{
    [self RunRemoveConversationBoxScript];
  }],
                                //leon1
                                
                                [CCActionCallBlock actionWithBlock:^{
    [self loadBlueDragonKnightLeon];
  }],
                                [CCActionDelay actionWithDuration:defaultConversationBoxAnimationDuration],
                                [CCActionCallBlock actionWithBlock:^{
    [self scrollMapToCharacter:_leon withAnimation:YES];
  }],
           
                               
                                [CCActionCallBlock actionWithBlock:^{
    [self loadLeonBox];
  }],

                                [CCActionDelay actionWithDuration:conversationDuration],
                                [CCActionCallBlock actionWithBlock:^{
    [self updateText];
  }],
                                [CCActionDelay actionWithDuration:conversationDuration],
                                [CCActionCallBlock actionWithBlock:^{
    [self RunRemoveConversationBoxScript];
  }],
                                [CCActionCallBlock actionWithBlock:^{
    [self sendConversationEndNotification];
  }],

   

                                ]];
  [self runAction:sequence];
}

-(void)loadElwinBox
{
 [self performSelector:@selector(loadIconAndConversationBoxForCharacter:) withObject:@"艾尔文"];
}

-(void)loadHainBox
{
 [self performSelector:@selector(loadIconAndConversationBoxForCharacter:) withObject:@"海因"];
}

-(void)loadLeonBox
{
[self performSelector:@selector(loadIconAndConversationBoxForCharacter:) withObject:@"里昂"];
}


-(void)loadBlueDragonKnightLeon
{
  CGPoint leonPoint = CGPointMake(9, 17);
  CGPoint leonPosition = CGPointMake(350,350);
  _leon=[self addSpriteWithNumber:leonPoint atPosition:leonPosition withName:@"里昂"];
  [_characterList addObject:_leon];
  [_characterPositionInSheetMap setValue:[NSValue valueWithCGPoint:leonPoint] forKey:_leon.name];
}

-(void)scrollMapToCharacter:(Character *)character withAnimation:(BOOL)animation
{
  NSLog(@"%@",NSStringFromCGPoint(character.position));

 // CGPoint point = [character convertToNodeSpace:character.position];
  CGPoint scrollPoint =ccp(character.position.x-self.contentSize.width/2,[self convertSpriteYtoScrollY: character.position.y+self.contentSize.height/2]);
  
  if (scrollPoint.x>_stageMapView.contentNode.contentSize.width-self.contentSize.width) {
    scrollPoint.x=_stageMapView.contentNode.contentSize.width-self.contentSize.width;
  }
  else if (scrollPoint.x<0){
    scrollPoint.x=0;
  }
  NSLog(@"%f",self.contentSize.height);
  if (scrollPoint.y>_stageMapView.contentNode.contentSize.height-self.contentSize.height) {
    scrollPoint.y=_stageMapView.contentNode.contentSize.height-self.contentSize.height;
  }
  else if (scrollPoint.y<0){
    scrollPoint.y=0;
  }

  [_stageMapView setScrollPosition:scrollPoint animated:YES];

}

-(CGFloat)convertSpriteYtoScrollY:(CGFloat)spriteY
{
  //spriteY should related to stage map
  CGFloat scrollY = _stageMapView.contentNode.contentSize.height-spriteY;
  return scrollY;
}

-(void)sendConversationEndNotification
{
  NSNotification *conversationEndNotification = [NSNotification notificationWithName:@"conversationEndNotification" object:nil];
  [[NSNotificationCenter defaultCenter] performSelector:@selector(postNotification:) withObject:conversationEndNotification];
}

-(void)runConversationScript
{
  [self updateText];
}

-(void)RunRemoveConversationBoxScript
{
  [self animateRemoveConversationFrameScreen];
}


-(void)runConversationScriptWithDelay:(NSTimeInterval)delay
{
  [self performSelector:@selector(updateText) withObject:nil afterDelay:delay];
}

-(void)RunRemoveConversationBoxScriptWithDelay:(NSTimeInterval)delay
{
  [self performSelector:@selector(animateRemoveConversationFrameScreen) withObject:nil afterDelay:delay];
}

// -----------------------------------------------------------------------

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
  // always call super onEnter first
  [super onEnter];
  [_stageMapView setVerticalScrollEnabled:YES];
  [_stageMapView setPagingEnabled:NO];
  

  [self runGameScript];
  
  

  
  // In pre-v3, touch enable and scheduleUpdate was called here
  // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
  // Per frame update is automatically enabled, if update is overridden
  
}

// -----------------------------------------------------------------------

- (void)onExit
{
  // always call super onExit last
  [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------
/*
 -(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
 CGPoint touchLoc = [touch locationInNode:self];
 
 // Log touch location
 CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
 
 // Move our sprite to touch location
 CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:touchLoc];
 [_sprite runAction:actionMove];
 }
 */


-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
 
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{

}

-(void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
  NSLog(@"cancelled");
  [super touchCancelled:touch withEvent:event];
//  if (_isScrollingMap) {
//    if (_activeCharacter==nil) {
//      _isTryingToMoveCharacter=NO;
//    }
//    else{
//      _isTryingToMoveCharacter=YES;
//    }
//  }
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
  BOOL isTouchingCharacter=NO;
  CGPoint touchLocation = [touch locationInNode:mBG];
  if (_activeCharacter==nil) {
    _isTryingToMoveCharacter=NO;
  }
  else{
    _isTryingToMoveCharacter=YES;
  }
  for (Character *character in _characterList) {
    //  CGPoint toL = [character convertToNodeSpace:<#(CGPoint)#>]
    if (CGRectContainsPoint([character boundingBox], touchLocation)){
      isTouchingCharacter=YES;
      if (_activeCharacter!=character) {
        
        [_activeCharacter stopMoveAnimation];
        if (_activeCharacter!=nil) {
          _isTryingToMoveCharacter=NO;
        }
        CGPoint positionInSheet = [[_characterPositionInSheetMap valueForKey:character.name] CGPointValue];
        [character addMoveAnimationWithTextPointInSheet:positionInSheet];
        _activeCharacter=character;
        break;
      }
    }
  }
  if (!isTouchingCharacter&&!_isTryingToMoveCharacter) {
    _isScrollingMap=YES;
    
    
  }
  
  
  if (!_isTryingToMoveCharacter) {
    return;
  }
  if (_isScrollingMap) {
    _isScrollingMap=NO;
    return;
  }

  if (_activeCharacter!=nil) {
    

  CGPoint touchLoc = CGPointMake([touch locationInNode:mBG].x, [touch locationInNode:mBG].y);
  CGPoint currentLoc = CGPointMake( _activeCharacter.position.x,  _activeCharacter.position.y);
  NSTimeInterval duration=0;

  
  CGVector vector = CGVectorMake(currentLoc.x-touchLoc.x, currentLoc.y-touchLoc.y);
    if (vector.dx>vector.dy) {
      CGPoint firstNodePoint =CGPointMake([touch locationInNode:mBG].x, _activeCharacter.position.y);
      CGPoint secondNodePoint = touchLoc;
      CGFloat gap = [MathUtil distanceBetweenPoint1:firstNodePoint andPoint2:currentLoc];
      NSTimeInterval duration1 = gap*0.01f;
      gap = [MathUtil distanceBetweenPoint1:touchLoc andPoint2:firstNodePoint];
      NSTimeInterval duration2 = gap*0.01f;
      duration=duration1+duration2;
      CCActionMoveTo *actionMoveX = [CCActionMoveTo actionWithDuration:duration1 position:firstNodePoint];
      CCActionMoveTo *actionMoveY = [CCActionMoveTo actionWithDuration:duration2 position:secondNodePoint];
      [_activeCharacter runAction:[CCActionSequence actionWithArray:@[actionMoveX,actionMoveY]]];
    }
    else{
      CGPoint firstNodePoint =CGPointMake(_activeCharacter.position.x, [touch locationInNode:mBG].y);
      CGPoint secondNodePoint = touchLoc;
      CGFloat gap = [MathUtil distanceBetweenPoint1:firstNodePoint andPoint2:currentLoc];
      NSTimeInterval duration1 = gap*0.01f;
      gap = [MathUtil distanceBetweenPoint1:touchLoc andPoint2:firstNodePoint];
      NSTimeInterval duration2 = gap*0.01f;
      duration=duration1+duration2;
      CCActionMoveTo *actionMoveY = [CCActionMoveTo actionWithDuration:duration1 position:firstNodePoint];
      CCActionMoveTo *actionMoveX = [CCActionMoveTo actionWithDuration:duration2 position:secondNodePoint];
      [_activeCharacter runAction:[CCActionSequence actionWithArray:@[actionMoveY,actionMoveX]]];
    }
    
//  CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:duration position:touchLoc];
//  [_activeCharacter runAction:actionMove];
  [_activeCharacter performSelector:@selector(stopMoveAnimation) withObject:nil afterDelay:duration];
  _activeCharacter = nil;
  }
}

-(void)conversationEndded:(NSNotification *)notification
{
  self.userInteractionEnabled=YES;
  _stageMapView.userInteractionEnabled=YES;
}


#pragma mark - scrollview delegate
-(void)scrollViewDidScroll:(CCScrollView *)scrollView
{

}

@end
