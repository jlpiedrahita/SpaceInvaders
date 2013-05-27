//
//  SIGameLayer.m
//  SpaceInvaders
//
//  Created by Jose Luis Piedrahita on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SIGameLayer.h"
#import "SimpleAudioEngine.h"
#import "CCDrawingPrimitives.h"
#import "SIInvader.h"
#import "GameConfig.h"

@implementation SIGameLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	SIGameLayer *layer = [SIGameLayer node];
	[scene addChild: layer];
	return scene;
}

-(void) setupSpriteSheet
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Invaders.plist"];
    _spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"Invaders.png"];
    [_spriteSheet.texture setAliasTexParameters];
    [self addChild:_spriteSheet];
}

-(CCLabelTTF*) setupLabelWithPosition:(CGPoint) position andText:(NSString*) labelText
{
    CCLabelTTF *label = [CCLabelTTF labelWithString:labelText fontName:@"Space Invaders" fontSize:9];
    label.position = position;
    [label.texture setAliasTexParameters];    
    [self addChild:label];
    return label;
}

-(void) addBarriers
{
    #define BARRIER_LEFT_MARGIN 108
    #define BARRIER_PADDING 88
    for (int i = 0; i < 4; i++) {
        CCSprite *barrier = [CCSprite spriteWithSpriteFrameName:@"Invaders_barrier.png"];
        barrier.position = ccp(i * BARRIER_PADDING + BARRIER_LEFT_MARGIN, 62);
        [_spriteSheet addChild:barrier];
    }
}

-(void) addLifes
{
    #define LIFE_LEFT_MARGIN 19
    #define LIFE_PADDING 16
    for (int i = 0; i < 3; i++) {
        CCSprite *life = [CCSprite spriteWithSpriteFrameName:@"Invaders_life.png"];
        life.position = ccp(i * LIFE_PADDING + LIFE_LEFT_MARGIN, 6);
        [_spriteSheet addChild:life];
    }
}

-(void) addMothership
{
    CCSprite *mothership = [CCSprite spriteWithSpriteFrameName:@"Invaders_mothership.png"];
    mothership.position = ccp(280, 320 - 27);
    [_spriteSheet addChild:mothership];
}

-(void) addSpaceship
{
    spaceship = [CCSprite spriteWithSpriteFrameName:@"Invaders_spaceship.png"];
    spaceship.position = ccp(240.0f , 24.0f);
    [_spriteSheet addChild:spaceship];
}

-(void) addInvaders
{
    #define MARGIN_LEFT 78
    #define MARGIN_TOP 320 - 50
    #define PADDING_HORIZONTAL 32
    #define PADDING_VERTICAL -32
    
    #define INVADERS_ROWS 5
    #define INVADERS_PER_ROWS 11
    
    for (int i = 0; i < INVADERS_ROWS; i++) {
        for (int j = 0; j < INVADERS_PER_ROWS; j++) {
            
            SIInvaderType invaderType = i < 1 ? SIInvaderTypeA : i < 3 ? SIInvaderTypeB : SIInvaderTypeC;
            SIInvader *invader = [SIInvader invaderWithType:invaderType];
            invader.position = ccp(j * PADDING_HORIZONTAL + MARGIN_LEFT, i * PADDING_VERTICAL + MARGIN_TOP);

            [_spriteSheet addChild:invader];
        }
    }
}

#define SCORE_POSITION_X 310.0f
// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init])) {

        self.isTouchEnabled = YES;
        [self scheduleUpdate];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];

        //score
        CCLabelTTF *scoreTextLabel = [self setupLabelWithPosition:ccp(30.0f, SCORE_POSITION_X) andText:@"SCORE: "];        
        scoreLabel = [self setupLabelWithPosition:ccp(scoreTextLabel.position.x + 36.0f, SCORE_POSITION_X) andText:@"00000"];

        //high score
        CCLabelTTF *highScoreTextLabel = [self setupLabelWithPosition:ccp(winSize.width / 2, SCORE_POSITION_X) andText:@"HI-SCORE: "];
        highScoreLabel = [self setupLabelWithPosition:ccp(highScoreTextLabel.position.x + 42, SCORE_POSITION_X) andText:@"00000"];
        
        //credits
        [self setupLabelWithPosition:ccp(440.0f, 5.0f) andText:@"CREDIT: 00"];

        [self setupSpriteSheet];
        
        [self addBarriers];
        [self addLifes];
        [self addMothership];
        [self addSpaceship];
        [self addInvaders];
        
        bullet = [CCSprite spriteWithSpriteFrameName:@"Invaders_bullet.png"];
        bullet.visible = NO;
        [_spriteSheet addChild:bullet];
	}
	return self;
}

- (void)draw
{
    //draw separator
    glColor4f(0.0f, 1.0f, 0.0f, 1.0f);
    glLineWidth(2.0f);
    ccDrawLine(ccp(2.0f, 12.0f), ccp(478.0f, 12.0f));
}

- (void)update:(ccTime)dt 
{    
    if (bullet.visible) {
        CCNode *child;
        CCARRAY_FOREACH(_spriteSheet.children, child) {
            if (child.tag == kSpriteTagInvader) {
                SIInvader *invader = (SIInvader*)child;
                if (CGRectIntersectsRect([bullet boundingBox], [invader boundingBox])) {
                    bullet.visible = NO;
                    [bullet stopAllActions];
                    
                    NSInteger points = [invader kill];
                    score += points;
                    scoreLabel.string = [NSString stringWithFormat:@"%.5d", score];
                    
                    break;
                }	
            }
        }        
    }
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

-(void) fireBullet
{
    bullet.position = ccp(spaceship.position.x, spaceship.position.y + 12.0f);
    bullet.visible = YES;
    
    //bullet sound
    [[SimpleAudioEngine sharedEngine] playEffect:@"shoot.wav"];
    
    //move bullet
    CGSize size = [[CCDirector sharedDirector] winSize];
    id moveBullet = [CCMoveTo actionWithDuration:1 position:ccp(bullet.position.x, size.height)];
    id hideBullet = [CCCallBlock actionWithBlock:^{
        bullet.visible = NO;
    }];
    
    [bullet runAction:[CCSequence actions:moveBullet, hideBullet, nil]];   
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (!bullet.visible && bullet.numberOfRunningActions == 0) {
        [self fireBullet];
    }

    [spaceship stopAllActions];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    [spaceship runAction: [CCMoveTo actionWithDuration:1 position:ccp(location.x, spaceship.position.y)]];    
}

- (void) dealloc
{
    [spaceship release];
    [bullet release];
	[super dealloc];
}

@end
