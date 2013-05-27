//
//  SIBullet.m
//  SpaceInvaders
//
//  Created by Jose Luis Piedrahita on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SIBullet.h"

@implementation SIBullet

- (id)init
{
    self = [super initWithSpriteFrameName:@"Invaders_bullet.png"];
    if (self) {
        self.visible = NO;
    }
    return self;
}

@end
