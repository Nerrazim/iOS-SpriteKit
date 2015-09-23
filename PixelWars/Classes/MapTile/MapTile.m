//
//  MapTile.m
//  PixelWars
//
//  Created by Gandi Pirkov on 9/19/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import "MapTile.h"

@interface MapTile() {
    
}

@property (nonatomic, assign, readwrite) enum TileType tileType;
@property (nonatomic, assign, readwrite) CGPoint mapPosition;

@end

@implementation MapTile

-(instancetype) initWithImageNamed:(NSString *)name position:(CGPoint)mapPosition andType:(enum TileType) tileType
{
    if(self = [super initWithImageNamed:name]) {
        _tileType = tileType;
        _mapPosition  = mapPosition;
        [self addSpecialImageForType:_tileType];
        
    }
    
    return self;
}

-(void) addSpecialImageForType:(enum TileType)tileType
{
    switch (tileType) {
        case TileTypeResource:
            [self addChild:[[SKSpriteNode alloc] initWithImageNamed:@"resource.png"]];
            break;
        case TileTypeWall:
            [self addChild:[[SKSpriteNode alloc] initWithImageNamed:@"debris.png"]];
            break;
        case TileTypeSpawningPoint:
            [self addChild:[[SKSpriteNode alloc] initWithImageNamed:@"castle.png"]];
            break;
        default:
            break;
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    
}

@end
