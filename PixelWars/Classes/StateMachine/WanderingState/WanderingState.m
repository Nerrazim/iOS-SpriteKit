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
    
    //Checks if there is any special objects in range
    if(objectsInRange.count > 0)
    {
        MapTile* closestObject;
        MapTile* enemyInRangeObject;
        
        CGFloat xDist;
        CGFloat yDist;
        CGFloat distance;
        CGFloat previousDistance = INT_MAX;
        
        //Gets the closest special object in range
        for(int i = 0; i < objectsInRange.count; ++i)
        {
            xDist = (agent.mapPosition.x - objectsInRange[i].mapPosition.x);
            yDist = (agent.mapPosition.y - objectsInRange[i].mapPosition.y);
            distance = sqrt((xDist * xDist) + (yDist * yDist));
            
            if(distance < previousDistance) {
                closestObject = objectsInRange[i];
            }
            
            if(objectsInRange[i].agentOnPosition != nil) {
                enemyInRangeObject = objectsInRange[i];
            }
        }
        
        
        //Calculates the distance between the special object and the enemy
        xDist = (agent.mapPosition.x - enemyInRangeObject.mapPosition.x);
        yDist = (agent.mapPosition.y - enemyInRangeObject.mapPosition.y);
        
        CGFloat distanceToEnemy = sqrt((xDist * xDist) + (yDist * yDist));
        CGFloat distanceToClosestObject = sqrt((xDist * xDist) + (yDist * yDist));
        
        //If the special object is closer remove the enemy and go for the resource
        if(distanceToClosestObject < distanceToEnemy) {
            enemyInRangeObject = nil;
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
        else if(enemyInRangeObject != nil) {
            agent.currentTarget = enemyInRangeObject;
            [agent.stateMachine changeState:[EngageEnemyState sharedInstance]];
        }
        else {
            [agent moveBlind];
        }
        
        
    }
    else
    {
        //Moves the agent blindly
        [agent moveBlind];
    }
}

-(void) Exit:(AgentTile*)agent
{
    
}

@end
