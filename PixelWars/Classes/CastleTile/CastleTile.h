//
//  CastleTile.h
//  PixelWars
//
//  Created by Gandi Pirkov on 9/22/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MapTile.h"

@class AgentTile;
@class CastleTile;

@protocol CastleDelegate <NSObject>

-(void) spawnAgentFromCastle:(CastleTile*)castle;

@end

@interface CastleTile : MapTile

@property (nonatomic, weak) id<CastleDelegate> delegate;

-(instancetype) initWithPosition:(CGPoint)mapPosition;

-(void)update:(CFTimeInterval)currentTime;

-(void)didBeginContactWith:(SKPhysicsBody*)physicsBody;

@end
