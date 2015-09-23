//
//  WanderingState.m
//  PixelWars
//
//  Created by Gandi Pirkov on 9/23/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import "WanderingState.h"
#import "AgentTile.h"

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
    
    NSArray<NSArray*>* visiblieTiles = [agent getVisibleTilesForPosition];
    
    int i = arc4random_uniform((int)visiblieTiles.count);
    int j = arc4random_uniform((int)visiblieTiles[i].count);
    
    [agent moveToTile:visiblieTiles[arc4random_uniform(i)][j]];
//    for (int i = 0; i < visiblieTiles.count; ++i) {
//        for (int j = 0; j < visiblieTiles[i].count; ++j) {
//            
//        }
//    }
}

-(void) Exit:(AgentTile*)agent
{
    
}

@end
