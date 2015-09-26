//
//  CaptureResourceState.m
//  PixelWars
//
//  Created by Gandi Pirkov on 9/24/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import "CaptureResourceState.h"
#import "AgentTile.h"
#import "Algorithums.h"


@implementation CaptureResourceState

+ (id)sharedInstance
{
    static CaptureResourceState *sharedInstance = nil;
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
