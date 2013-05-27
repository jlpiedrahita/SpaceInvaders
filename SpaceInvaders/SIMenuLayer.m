//
//  HelloWorldLayer.m
//  SpaceInvaders
//
//  Created by Jose Luis Piedrahita on 7/12/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "SIMenuLayer.h"
#import "SIGameLayer.h"

// HelloWorldLayer implementation
@implementation SIMenuLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	SIMenuLayer *layer = [SIMenuLayer node];
	[scene addChild: layer];
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"Space Invaders" fontName:@"Marker Felt" fontSize:64];

		CGSize size = [[CCDirector sharedDirector] winSize];
		titleLabel.position =  ccp( size.width /2 , size.height - 80.0f);
		
		[self addChild: titleLabel];
        
        CCMenuItemFont * playMenuItem = [CCMenuItemFont itemFromString:@"Play" block:^(id sender) { 
            [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5f scene:[SIGameLayer scene]]];
        }];
        
        CCMenuItemFont * scoresMenuItem = [CCMenuItemFont itemFromString:@"Scores"];
        CCMenuItemFont * optionsMenuItem = [CCMenuItemFont itemFromString:@"Options"];
        
        // Create a menu and add your menu items to it
        CCMenu * myMenu = [CCMenu menuWithItems:playMenuItem, scoresMenuItem, optionsMenuItem, nil];
        
        myMenu.position = ccp( size.width /2 , 120.0f);
        [myMenu alignItemsVerticallyWithPadding:10.0f];
        
        // add the menu to your scene
        [self addChild:myMenu];
    }
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

@end
