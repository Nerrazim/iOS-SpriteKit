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
    }
    
    return self;
}

-(void)update:(CFTimeInterval)currentTime
{
    if(self.owner != nil && currentTime > m_lastSpawnTime + m_spawnSpeed * [self.owner getAllResourcesMofier]) {
        m_lastSpawnTime = currentTime;
        [self spawnAgent];
    }
}

-(void) spawnAgent
{
    AgentTile * agent = [[AgentTile alloc] init];
    agent.owner = self.owner;
    agent.xScale = self.xScale;
    agent.yScale = self.yScale;
    agent.position = self.position;
    agent.mapPosition = self.mapPosition;
    
    
    [self.owner.ownedAgents addObject:agent];
    
    [_delegate spawnAgent:agent];
}

@end
