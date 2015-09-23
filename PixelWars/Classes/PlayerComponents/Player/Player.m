//
//  Player.m
//  PixelWars
//
//  Created by Gandi Pirkov on 9/22/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import "Player.h"

@implementation Player

-(instancetype) init
{
    if(self = [super init]) {
        _ownedCastles = [NSMutableArray array];
        _ownedResources = [NSMutableArray array];
        _ownedAgents = [NSMutableArray array];
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


@end
