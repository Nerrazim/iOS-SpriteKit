//
//  MapTile.h
//  PixelWars
//
//  Created by Gandi Pirkov on 9/19/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Constants.h"

@class Player;
@class AgentTile;

enum TileType
{
    TileTypeFree = 0,
    TileTypeWall = 1,
    TileTypeResource = 2,
    TileTypeSpawningPoint = 3,
};

@interface MapTile : SKSpriteNode

//Contains the tile owner if any
@property (nonatomic, weak) Player* owner;
//Tile id
@property (nonatomic, strong) NSString* tileId;
//Position in the map array
@property (nonatomic, assign, readonly) CGPoint mapPosition;
// Type of the tile from enum TileType
@property (nonatomic, assign, readonly) enum TileType tileType;
//Indicates if there is agent on the current tile
@property (nonatomic, assign) AgentTile* agentOnPosition;

-(instancetype) initWithImageNamed:(NSString *)name position:(CGPoint)mapPosition andType:(enum TileType) tileType;

-(void)update:(CFTimeInterval)currentTime;

@end
