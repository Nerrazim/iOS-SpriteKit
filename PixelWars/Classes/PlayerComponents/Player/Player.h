//
//  Player.h
//  PixelWars
//
//  Created by Gandi Pirkov on 9/22/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CastleTile.h"
#import "ResourceTile.h"
#import "AgentTile.h"

@interface Player : NSObject

@property (nonatomic, assign) int playerId;

@property (nonatomic, strong) NSMutableArray<CastleTile*>* ownedCastles;
@property (nonatomic, strong) NSMutableArray<ResourceTile*>* ownedResources;
@property (nonatomic, strong) NSMutableArray<AgentTile*>* ownedAgents;

-(double) getAllResourcesMofier;

-(void)update:(CFTimeInterval)currentTime;

@end
