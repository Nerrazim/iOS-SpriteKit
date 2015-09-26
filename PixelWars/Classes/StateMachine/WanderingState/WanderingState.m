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
    NSArray<MapTile*>* objectsInRange = [agent specialObjectsInRange];
    
    if(objectsInRange.count > 0)
    {
        MapTile* closestObject;
        CGFloat xDist;
        CGFloat yDist;
        CGFloat distance;
        CGFloat previousDistance = INT_MAX;
        
        for(int i = 0; i < objectsInRange.count; ++i)
        {
            xDist = (agent.mapPosition.x - objectsInRange[i].mapPosition.x); //[2]
            yDist = (agent.mapPosition.y - objectsInRange[i].mapPosition.y); //[3]
            distance = sqrt((xDist * xDist) + (yDist * yDist));
            if(distance < previousDistance) {
                closestObject = objectsInRange[i];
            }
        }
        
        if(closestObject.tileType == TileTypeResource)
        {
            agent.currentTarget = closestObject;
            [agent.stateMachine changeState:[CaptureResourceState sharedInstance]];

        }
        else if(closestObject.tileType == TileTypeSpawningPoint)
        {
            agent.currentTarget = closestObject;
            [agent.stateMachine changeState:[CaptureCastleState sharedInstance]];
        } 
    }
    else
    {
        MapTile* tileToMoveTo = nil;
        NSArray* tiles = [agent objectsInRange];

        tileToMoveTo = tiles[arc4random_uniform((int)tiles.count)];
        agent.currentTarget = tileToMoveTo;
        [agent moveToTarget];
    }
}

-(void) Exit:(AgentTile*)agent
{
    
}

@end
