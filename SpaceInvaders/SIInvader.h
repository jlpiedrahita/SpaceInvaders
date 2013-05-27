//
//  SIInvader.h
//  SpaceInvaders
//
//  Created by Jose Luis Piedrahita on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

typedef enum {
    SIInvaderTypeA = 1,
    SIInvaderTypeB,
    SIInvaderTypeC
} SIInvaderType;

typedef enum {
    SIInvaderMoveDirectionRight = 1,
    SIInvaderMoveDirectionDown,
    SIInvaderMoveDirectionLeft
} SIInvaderMoveDirection;

@interface SIInvader : CCSprite {
    SIInvaderType _type;
    SIInvaderMoveDirection _moveDirection;
    double _speed;
}

@property (nonatomic, readonly) SIInvaderType type;
@property (nonatomic) SIInvaderMoveDirection moveDirection;
@property (nonatomic) double speed;

+ (id)invaderWithType:(SIInvaderType) type;
- (NSInteger)kill;

@end
