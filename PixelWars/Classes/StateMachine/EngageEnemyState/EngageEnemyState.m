//
//  EngageEnemyState.m
//  PixelWars
//
//  Created by Gandi Pirkov on 9/26/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import "EngageEnemyState.h"


@implementation EngageEnemyState


+ (id)sharedInstance
{
    static EngageEnemyState *sharedInstance = nil;
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
    
}

-(void) Exit:(AgentTile*)agent
{
    
}


@end
