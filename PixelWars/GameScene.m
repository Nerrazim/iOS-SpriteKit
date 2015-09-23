//
//  GameScene.m
//  PixelWars
//
//  Created by Gandi Pirkov on 9/22/15.
//  Copyright (c) 2015 Gandi Pirkov. All rights reserved.
//

#import "GameScene.h"
#import "Player.h"

@interface GameScene() {
    
}

@property (nonatomic, strong) NSMutableArray<NSMutableArray*>* map;
@property (nonatomic, strong) NSMutableArray<CastleTile*>* castles;
@property (nonatomic, strong) NSMutableArray<Player*>* players;

@end

@implementation GameScene

//Init the scene
-(void)didMoveToView:(SKView *)view
{
    _map = [NSMutableArray array];
    _castles = [NSMutableArray array];
    _players = [NSMutableArray array];
    
    [self loadMapFromFile];
    [self loadMapInScene];
    [self initPlayers];
}


//Reads and Loads the map from the file
-(void) loadMapFromFile
{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"Map" ofType:@"txt"];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    
    NSArray<NSString*> *mapArray = [fileContents componentsSeparatedByString:@"\n"];
    
    for(int i = 0; i < (int)mapArray.count; ++i) {
        
        NSArray<NSString*> *lineContent = [mapArray[i] componentsSeparatedByString:@","];
        
        [_map addObject:[NSMutableArray<MapTile*> array]];
        
        for(int j = 0; j < (int)lineContent.count; ++j) {
            MapTile * tile;
            
            if([lineContent[j] intValue] == TileTypeFree) {
                tile = [[MapTile alloc] initWithImageNamed:@"square.png" position:CGPointMake(i, j) andType:TileTypeFree];
            } else if([lineContent[j] intValue] == TileTypeWall) {
                tile = [[MapTile alloc] initWithImageNamed:@"square.png" position:CGPointMake(i, j) andType:TileTypeWall];
            } else if([lineContent[j] intValue] == TileTypeSpawningPoint) {
                tile = [[CastleTile alloc] initWithPosition:CGPointMake(i, j)];
                ((CastleTile*)tile).delegate = self;
                [_castles addObject:(CastleTile*)tile];
            } else if([lineContent[j] intValue] == TileTypeResource) {
                tile = [[ResourceTile alloc] initWithPosition:CGPointMake(i, j)];
            }
            
            [_map[i] addObject:tile];
        }
    }
}

//Loads the map in the scene
-(void) loadMapInScene
{
    for(int i = 0; i < _map.count; ++i) {
        for(int j = 0; j < (int)_map[i].count; ++j) {
            MapTile* tile = _map[i][j];
            tile.xScale = 0.3;
            tile.yScale = 0.3;
            
            tile.position = CGPointMake((tile.size.width/2 + j * tile.size.width) + 30, (tile.size.height/2 + (_map.count - i) * tile.size.height) - 20);
            
            SKSpriteNode * grass = [[SKSpriteNode alloc] initWithImageNamed:@"grass.jpg"];
            grass.xScale = 0.3;
            grass.yScale = 0.3;
            grass.position = tile.position;
            
            [self addChild:grass];
            [self addChild:tile];
        }
    }
}

-(void) initPlayers
{
    Player* playerOne = [[Player alloc] init];
    playerOne.playerId = 0;
    _castles.firstObject.owner = playerOne;
    [playerOne.ownedCastles addObject:_castles.firstObject];
    
    [_players addObject:playerOne];
    
    if(_castles.count > 1) {
        Player* playerTwo = [[Player alloc] init];
         playerTwo.playerId = 1;
        _castles.lastObject.owner = playerTwo;
        [playerTwo.ownedCastles addObject:_castles.lastObject];
        [_players addObject:playerTwo];
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    for(int i = 0; i < _players.count; ++i) {
        [_players[i] update:currentTime];
    }
}

-(NSArray*) getVisibleTilesForPosition:(CGPoint)position
{
    int visibilityRange = AGENT_VISIBILITY_RANGE;
    
    NSMutableArray<NSMutableArray*>* visibleTiles = [NSMutableArray array];
    
    int visibleTilesVerticalIndex = 0;
    
    for(int i = position.x - visibilityRange; i < position.x + visibilityRange; ++i)
    {
        
        if(i < 0 || i  > _map.count - 1) continue;
        
        [visibleTiles addObject:[NSMutableArray array]];
        
        for(int j = position.y - visibilityRange; j < position.y + visibilityRange; ++j)
        {
            if(j < 0 || j  > _map[i].count - 1) continue;
            
            [visibleTiles[visibleTilesVerticalIndex] addObject:_map[i][j]];
        }
        
        ++visibleTilesVerticalIndex;
    }
    
    return visibleTiles;
}

-(void) spawnAgent:(AgentTile*)agent
{
    agent.delegate = self;
    
    [self addChild:agent];
}


@end

