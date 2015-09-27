//
//  CastleTile.m
//  PixelWars
//
//  Created by Gandi Pirkov on 9/22/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import "CastleTile.h"
#import "Player.h"

@interface CastleTile() {
    double m_spawnSpeed;
    double m_lastSpawnTime;
}

@end

@implementation CastleTile

-(instancetype) initWithPosition:(CGPoint)mapPosition
{
    if(self = [super initWithImageNamed:@"square.png" position:mapPosition andType:TileTypeSpawningPoint]) {
        m_spawnSpeed = 5;
        m_lastSpawnTime = 0;
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width/2, self.size.height/2)];
        self.physicsBody.collisionBitMask = 0;
        self.physicsBody.contactTestBitMask = agentsCategory;
        self.physicsBody.categoryBitMask = spawningPointsCategory;
        self.physicsBody.dynamic = YES;
    }
    
    return self;
}

-(void)didBeginContactWith:(SKPhysicsBody*)physicsBody
{
    Player* owner = ((AgentTile*)physicsBody.node).owner;
    if(self.owner != owner) {
        [owner addCastle:self];
        [self.owner removeCastle:self];
        self.owner = owner;
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    CGFloat adjsutedSpawnSpeed = m_spawnSpeed - m_spawnSpeed * [self.owner getAllResourcesMofier];
    
    if (adjsutedSpawnSpeed <= 0) {
        adjsutedSpawnSpeed = 1;
    }

    if(self.owner != nil && currentTime > m_lastSpawnTime + adjsutedSpawnSpeed) {
        m_lastSpawnTime = currentTime;
        [self spawnAgent];
    }
}

-(void) spawnAgent
{
    if(self.owner.ownedAgents.count < 80)
        [_delegate spawnAgentFromCastle:self];
}


@end
