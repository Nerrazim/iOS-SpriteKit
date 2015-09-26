//
//  MapTile.m
//  PixelWars
//
//  Created by Gandi Pirkov on 9/19/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import "MapTile.h"
#import "Player.h"

@interface MapTile() {
    
}

@property (nonatomic, assign, readwrite) enum TileType tileType;
@property (nonatomic, assign, readwrite) CGPoint mapPosition;
@property (nonatomic, strong) SKSpriteNode* colorNode;

@end

@implementation MapTile

-(instancetype) initWithImageNamed:(NSString *)name position:(CGPoint)mapPosition andType:(enum TileType) tileType
{
    if(self = [super initWithImageNamed:name]) {
        _tileType = tileType;
        _mapPosition  = mapPosition;
        
        _colorNode = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:self.size];
        [self addChild:_colorNode];
        
        _tileId = [NSString stringWithFormat:@"%d%d",(int)_mapPosition.x, (int)_mapPosition.y];
        [self addSpecialImageForType:_tileType];
        
        self.isThereAgentOnPosition = NO;
    }
    
    return self;
}

- (void)setOwner:(Player *)owner
{
    _owner = owner;
    _colorNode.color = owner.playerColor;
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
