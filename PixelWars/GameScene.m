//
//  GameScene.m
//  PixelWars
//
//  Created by Gandi Pirkov on 9/22/15.
//  Copyright (c) 2015 Gandi Pirkov. All rights reserved.
//

#import "GameScene.h"
#import "Player.h"
#import "Algorithums.h"

@interface GameScene() {
    BOOL isGameOver;
    SKLabelNode* gameOver;
}

@property (nonatomic, strong) NSMutableArray<NSMutableArray*>* map;
@property (nonatomic, strong) NSMutableArray<CastleTile*>* castles;
@property (nonatomic, strong) NSMutableArray<Player*>* players;

@end

@implementation GameScene

//Init the scene
-(void)didMoveToView:(SKView *)view
{
    isGameOver = NO;
    
    self.physicsWorld.gravity = CGVectorMake(0,0);
    self.physicsWorld.contactDelegate = self;
    
    _map = [NSMutableArray array];
    _castles = [NSMutableArray array];
    _players = [NSMutableArray array];
    
    [self loadMapFromFile];
    [self loadMapInScene];
    [self initPlayers];
    
    gameOver = [[SKLabelNode alloc] initWithFontNamed:@"Halvetica"];
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
//            Debug showing tilesPositions
            SKLabelNode* node = [[SKLabelNode alloc] initWithFontNamed:@"Halvetica"];
            [node setText:[NSString stringWithFormat:@" %d,%d", i, j]];
            [tile addChild:node];
            
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
            tile.zPosition = 2;
            tile.position = CGPointMake((tile.size.width/2 + j * tile.size.width) + 30, (tile.size.height/2 + (_map.count - i) * tile.size.height) - 20);
            
            SKSpriteNode * grass = [[SKSpriteNode alloc] initWithImageNamed:@"grass.jpg"];
            grass.xScale = 0.3;
            grass.yScale = 0.3;
            grass.position = tile.position;
            grass.zPosition = 1;
            
            [self addChild:grass];
            [self addChild:tile];
        }
    }
}

-(void) initPlayers
{
    Player* playerOne = [[Player alloc] initWithColor:[UIColor redColor]];
    playerOne.playerId = 0;
    _castles.firstObject.owner = playerOne;
    [playerOne.ownedCastles addObject:_castles.firstObject];
    
    [_players addObject:playerOne];
    
    if(_castles.count > 1) {
        Player* playerTwo = [[Player alloc] initWithColor:[UIColor blueColor]];
         playerTwo.playerId = 1;
        _castles.lastObject.owner = playerTwo;
        [playerTwo.ownedCastles addObject:_castles.lastObject];
        [_players addObject:playerTwo];
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody* firstBody = nil;
    SKPhysicsBody* secondBody = nil;
    
    if(secondBody.categoryBitMask == agentsCategory) {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    } else {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    
    if([firstBody.node respondsToSelector:@selector(didBeginContactWith:)])
        [firstBody.node performSelector:@selector(didBeginContactWith:) withObject:secondBody afterDelay:0];
    
    if([secondBody.node respondsToSelector:@selector(didBeginContactWith:)])
        [secondBody.node performSelector:@selector(didBeginContactWith:) withObject:firstBody afterDelay:0];
}

-(void)update:(CFTimeInterval)currentTime
{
    if(!isGameOver) {
        for(int i = 0; i < _players.count; ++i) {
            if(_players[i].ownedCastles.count <= 0) {
                if(_players[i].playerId == 0) {
                    isGameOver = YES;
                    [gameOver setText:@"Player 2 Wins!"];
                    [self addChild:gameOver];
                } else {
                    [gameOver setText:@"Player 1 Wins!"];
                    [self addChild:gameOver];
                }
            }
            
            [_players[i] update:currentTime];
        }
    }
    
}

-(NSArray*) getMap
{
    return _map;
}

-(void) spawnAgentFromCastle:(CastleTile*)castle
{
    AgentTile * agent = [[AgentTile alloc] init];
    agent.owner = castle.owner;
    agent.xScale = castle.xScale;
    agent.yScale = castle.yScale;
    agent.zPosition = castle.zPosition + 1;
    
    [castle.owner addAgent:agent];
    agent.delegate = self;
    
    MapTile* spawnPosition = [Algorithums getNodeNeighborNodes:castle forMap:_map withAgent:agent].anyObject;
    
    agent.position = spawnPosition.position;
    agent.mapPosition = spawnPosition.mapPosition;
    agent.parentTile = spawnPosition;
    
    [self addChild:agent];
}


@end

