//
//  SIGameLayer.h
//  SpaceInvaders
//
//  Created by Jose Luis Piedrahita on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SIBullet.h"

@interface SIGameLayer : CCLayer {
    CCSpriteBatchNode *_spriteSheet;
    
    CCSprite *spaceship;
    CCSprite *bullet;
    
    CCLabelTTF *scoreLabel;
    CCLabelTTF *highScoreLabel;
    
    NSInteger score;
    NSInteger hiscore;
}

+(CCScene *) scene;

@end
