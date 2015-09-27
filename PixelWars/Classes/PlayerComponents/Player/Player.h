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
@property (nonatomic, strong) UIColor* playerColor;

@property (nonatomic, strong, readonly) NSMutableArray<CastleTile*>* ownedCastles;
@property (nonatomic, strong, readonly) NSMutableArray<ResourceTile*>* ownedResources;
@property (nonatomic, strong, readonly) NSMutableArray<AgentTile*>* ownedAgents;

-(instancetype) initWithColor:(UIColor*)color;

//Returns spawnSpeed modifer depending on the player resource count
-(double) getAllResourcesMofier;

-(void)update:(CFTimeInterval)currentTime;

-(void)addResource:(ResourceTile*)resource;
-(void)removeResource:(ResourceTile*)resource;

-(void)addAgent:(AgentTile*)agent;
-(void)removeAgent:(AgentTile*)agent;

-(void)addCastle:(CastleTile*)castle;
-(void)removeCastle:(CastleTile*)castle;

@end
