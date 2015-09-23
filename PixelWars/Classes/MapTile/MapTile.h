//
//  MapTile.h
//  PixelWars
//
//  Created by Gandi Pirkov on 9/19/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Player;

enum TileType
{
    TileTypeFree = 0,
    TileTypeWall = 1,
    TileTypeResource = 2,
    TileTypeSpawningPoint = 3,
};

@interface MapTile : SKSpriteNode

@property (nonatomic, strong) Player* owner;
@property (nonatomic, assign, readonly) CGPoint mapPosition;
@property (nonatomic, assign, readonly) enum TileType tileType;


-(instancetype) initWithImageNamed:(NSString *)name position:(CGPoint)mapPosition andType:(enum TileType) tileType;

-(void)update:(CFTimeInterval)currentTime;

@end
