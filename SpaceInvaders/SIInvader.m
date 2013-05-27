//
//  SIInvader.m
//  SpaceInvaders
//
//  Created by Jose Luis Piedrahita on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SIInvader.h"
#import "SimpleAudioEngine.h"
#import "GameConfig.h"

@implementation SIInvader

@synthesize type = _type;
@synthesize speed = _speed;
@synthesize moveDirection = _moveDirection;

- (id) initWithType:(SIInvaderType) type
{
    self = [super initWithSpriteFrameName:[NSString stringWithFormat:@"Invaders_invader_%d_1.png", type]];
    if (self) {
        _type = type;
        self.speed = 1.0f;    
        self.moveDirection = SIInvaderMoveDirectionRight;
        
        self.tag = kSpriteTagInvader;
        
        NSMutableArray *animationFrames = [NSMutableArray array];
        
        [animationFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                                    [NSString stringWithFormat:@"Invaders_invader_%d_1.png", self.type]]];
        [animationFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                                    [NSString stringWithFormat:@"Invaders_invader_%d_2.png", self.type]]];

        //animation
        id animation = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:animationFrames delay:1.0f]];
        
        [self runAction:[CCRepeatForever actionWithAction:animation]];
        
        //movement
        CCMoveBy *waitAction = [CCDelayTime actionWithDuration:1.0f];
        CCMoveBy *moveAction = [CCMoveBy actionWithDuration:0.0f position:ccp(8.0f, 0.0f)]; 
        CCCallFunc *chechDirection = [CCCallFunc actionWithTarget:self selector:@selector(_checkDirection)];
        [self runAction:[CCRepeatForever actionWithAction:[CCSequence actions:waitAction, moveAction, chechDirection, nil]]];
    }
    return self;
}

- (void) _checkDirection
{
    
}

+ (id) invaderWithType:(SIInvaderType) type
{
    return [[[self alloc] initWithType:type] autorelease];
}

- (void) dealloc 
{
    [super dealloc];
}

- (NSInteger) kill
{    
    [[SimpleAudioEngine sharedEngine] playEffect:@"invaderkilled.wav"];
    
    NSMutableArray *animationFrames = [NSMutableArray array];                
    [animationFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Invaders_explosion.png"]];
    
    id killedAnimation = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:animationFrames delay:0.5f] restoreOriginalFrame:NO];
    id killedAction = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    
    [self runAction:[CCSequence actions:killedAnimation, killedAction, nil]]; 
    
    switch (self.type) {
        case SIInvaderTypeA:
            return 500;
        case SIInvaderTypeB:
            return 200;
        default:
            return 100;
    }
}

@end
