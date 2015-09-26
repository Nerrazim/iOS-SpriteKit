//
//  CaptureCastleState.m
//  PixelWars
//
//  Created by Gandi Pirkov on 9/24/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import "CaptureCastleState.h"
#import "AgentTile.h"
#import "Algorithums.h"

@implementation CaptureCastleState

+ (id)sharedInstance
{
    static CaptureCastleState *sharedInstance = nil;
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
    if(agent.currentTarget != nil && agent.currentTarget.owner != agent.owner)
    {
        [agent moveToTarget];
    }
    else
    {
        [agent.stateMachine changeState:[WanderingState sharedInstance]];
    }
}

-(void) Exit:(AgentTile*)agent
{
    
}

@end
