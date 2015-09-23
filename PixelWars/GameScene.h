//
//  GameScene.h
//  PixelWars
//

//  Copyright (c) 2015 Gandi Pirkov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MapTile.h"
#import "CastleTile.h"
#import "ResourceTile.h"
#import "AgentTile.h"

@interface GameScene : SKScene <CastleDelegate, AgentDelegate>

-(NSArray*) getVisibleTilesForPosition:(CGPoint)position;
-(void) spawnAgent:(AgentTile*)agent;

@end
