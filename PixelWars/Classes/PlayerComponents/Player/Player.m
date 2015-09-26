//
//  Player.m
//  PixelWars
//
//  Created by Gandi Pirkov on 9/22/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import "Player.h"

@interface Player()

@property (nonatomic, strong, readwrite) NSMutableArray<CastleTile*>* ownedCastles;
@property (nonatomic, strong, readwrite) NSMutableArray<ResourceTile*>* ownedResources;
@property (nonatomic, strong, readwrite) NSMutableArray<AgentTile*>* ownedAgents;

@end

@implementation Player

-(instancetype) initWithColor:(UIColor*)color
{
    if(self = [super init]) {
        _ownedCastles = [NSMutableArray array];
        _ownedResources = [NSMutableArray array];
        _ownedAgents = [NSMutableArray array];
        _playerColor = color;
    }
    
    return self;
}

-(double) getAllResourcesMofier
{
    double modifier = 0;
    
    for (int i = 0; i <_ownedResources.count; ++i) {
        modifier += _ownedResources[i].resourceModifier;
    }
    
    if(modifier <= 0)
        modifier = 1;
    
    return modifier;
}

-(void)update:(CFTimeInterval)currentTime
{
    for(int i = 0; i < _ownedCastles.count; ++i) {
        [_ownedCastles[i] update:currentTime];
    }
    
    for(int i = 0; i < _ownedAgents.count; ++i) {
        [_ownedAgents[i] update:currentTime];
    }
    
    for(int i = 0; i < _ownedResources.count; ++i) {
        [_ownedResources[i] update:currentTime];
    }
}

-(void)addResource:(ResourceTile*)resource
{
    [_ownedResources addObject:resource];
}

-(void)removeResource:(ResourceTile*)resource
{
   [_ownedResources removeObject:resource];
}

-(void)addAgent:(AgentTile*)agent
{
    [_ownedAgents addObject:agent];
}

-(void)removeAgent:(AgentTile*)agent
{
    [_ownedAgents removeObject:agent];
}

-(void)addCastle:(CastleTile*)castle
{
    [_ownedCastles addObject:castle];
}

-(void)removeCastle:(CastleTile*)castle
{
    [_ownedCastles removeObject:castle];
}


@end
