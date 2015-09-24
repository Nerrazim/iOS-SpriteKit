//
//  WanderingState.m
//  PixelWars
//
//  Created by Gandi Pirkov on 9/23/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import "WanderingState.h"
#import "AgentTile.h"
#import "Algorithums.h"

@interface WanderingState() 

@end

@implementation WanderingState

+ (id)sharedInstance
{
    static WanderingState *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void) Enter:(AgentTile*)agent
{
    
}



-(void) Execute:(AgentTile*)agent
{
    
    NSArray<NSArray*>* map = [agent getMap];
    
    MapTile* tileToMoveTo = nil;
    
    NSArray* tiles = [Algorithums getNodeNeighborNodes:agent.parentTile forMap:map withAgent:agent].allObjects;
    tileToMoveTo = tiles[arc4random_uniform((int)tiles.count)];
    [agent moveToTile:tileToMoveTo];
}

-(void) Exit:(AgentTile*)agent
{
    
}

@end
