//
//  AgentTile.m
//  PixelWars
//
//  Created by Gandi Pirkov on 9/22/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import "AgentTile.h"
#import "Player.h"
#import "CastleTile.h"
#import "ResourceTile.h"
#import "Algorithums.h"

@interface AgentTile() {
    double m_attackSpeed;
    double m_lastAttackTime;
    BOOL m_canAttack;
}

@property (nonatomic, strong)  SKPhysicsBody* contactBody;
@property (nonatomic, strong)  SKPhysicsBody* attackBody;

@end

@implementation AgentTile

-(instancetype)init
{
    if(self = [super initWithImageNamed:@"warrior.png"]) {
        self.stateMachine = [[StateMachine alloc] initWithOwner:self
                                                   currentState:[WanderingState sharedInstance]
                                                  previousState:nil
                                                    globalState:nil];
        m_attackSpeed = 5;
        m_lastAttackTime = 0;
        m_canAttack = YES;
        
        int randomGuardGenerator = arc4random_uniform(10);
        
        _contactBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width/1.5, self.size.height/1.5)];
        _contactBody.contactTestBitMask = agentsAttackCategory | resourcesCategory | spawningPointsCategory;
        _contactBody.categoryBitMask = agentsCategory;
        
        self.physicsBody = _contactBody;
        self.physicsBody.collisionBitMask = 0;
        
        self.physicsBody.dynamic = YES;
        
        SKSpriteNode * combatNode = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(self.size.width * 5, self.size.height* 7)];
        [self addChild:combatNode];
        
        _attackBody = [SKPhysicsBody bodyWithRectangleOfSize:combatNode.size];
        _attackBody.contactTestBitMask = agentsCategory;
        _attackBody.categoryBitMask = agentsAttackCategory;
        
        combatNode.physicsBody = _attackBody;
        combatNode.physicsBody.collisionBitMask = 0;
        
        combatNode.physicsBody.dynamic = YES;
        
    }
    
    return self;
}

-(void) destroy
{
    self.parentTile.agentOnPosition = nil;
    [self.owner removeAgent:self];
    [self removeFromParent];
    
}

-(NSArray<MapTile *> *)specialObjectsInRange
{
    NSArray<NSArray<MapTile*>*>* map = [self getMap];
    NSMutableArray* foundObjects = [NSMutableArray array];
    
    for(int i = self.mapPosition.x - AGENT_VISIBILITY_RANGE; i < self.mapPosition.x + AGENT_VISIBILITY_RANGE; ++i) {
        if(i < 0 || i > map.count - 1) {
            continue;
        }
        
        for(int j = self.mapPosition.y - AGENT_VISIBILITY_RANGE; j < self.mapPosition.y + AGENT_VISIBILITY_RANGE; ++j) {
            if(j < 0 || j > map[i].count - 1) {
                continue;
            }
            
            MapTile* tile = map[i][j];
            
            if(tile.agentOnPosition != nil && tile.agentOnPosition.owner != self.owner) {
                [foundObjects addObject:tile.agentOnPosition.parentTile];
            } else if (tile.tileType == TileTypeResource && tile.owner != self.owner) {
                [foundObjects addObject:tile];
            } else if (tile.tileType == TileTypeSpawningPoint && tile.owner != self.owner) {
                [foundObjects addObject:tile];
            }
        }
    }
    
    return foundObjects;
}

-(NSArray<MapTile*>*) getNeighbourNodes
{
    NSMutableArray<MapTile*>* nodes = [NSMutableArray array];
    NSArray<NSArray<MapTile*>*>* map = [self getMap];
    MapTile* tile = nil;
    
    if(_mapPosition.x < map.count - 1)
    {
        tile = map[(int)_mapPosition.x + 1][(int)_mapPosition.y];
        [nodes addObject:tile];
    }
    
    if(_mapPosition.x > 0)
    {
        tile = map[(int)_mapPosition.x - 1][(int)_mapPosition.y];
        [nodes addObject:tile];
    }
    
    if(_mapPosition.y < map[(int)_mapPosition.x].count - 1)
    {
        tile = map[(int)_mapPosition.x][(int)_mapPosition.y + 1];
        [nodes addObject:tile];
    }
    
    if(_mapPosition.y > 0)
    {
        tile = map[(int)_mapPosition.x][(int)_mapPosition.y - 1];
        [nodes addObject:tile];
    }
    
    return nodes;
}

-(void) moveBlind
{
    self.currentTarget = [self getRandomEnemyHolding];
    [self moveToTarget];
}

-(MapTile*) getRandomEnemyHolding
{
    NSArray<Player*>* players = [_delegate getPlayers];
    NSArray* neighbours = [self getNeighbourNodes];
    NSArray* enemyPlayerCastles = nil;
    MapTile* tile = nil;
    
    for (int i = 0; i < players.count; ++i) {
        if(players[i].playerId != self.owner.playerId) {
            enemyPlayerCastles = players[i].ownedCastles;
            break;
        }
    }
    
    if(enemyPlayerCastles.count <= 0 && neighbours.count > 0) {
        //No enemy holdings return random tile
        tile = neighbours[arc4random_uniform((int)neighbours.count)];
    } else {
         tile = enemyPlayerCastles[arc4random_uniform((int)enemyPlayerCastles.count)];
    }
    
    return tile;
}

-(NSArray<MapTile *> *)objectsInRange
{
    NSArray<NSArray<MapTile*>*>* map = [self getMap];
    NSMutableArray* foundObjects = [NSMutableArray array];
    
    for(int i = self.mapPosition.x - AGENT_VISIBILITY_RANGE; i < self.mapPosition.x + AGENT_VISIBILITY_RANGE; ++i) {
        if(i < 0 || i > map.count - 1) {
            continue;
        }
        for(int j = self.mapPosition.y - AGENT_VISIBILITY_RANGE; j < self.mapPosition.y + AGENT_VISIBILITY_RANGE; ++j) {
            if(j < 0 || j > map[i].count - 1) {
                continue;
            }
            if(map[i][j].owner != self.owner) {
                [foundObjects addObject:map[i][j]];
            } else if(map[i][j].agentOnPosition != nil && map[i][j].agentOnPosition.owner != self.owner) {
                [foundObjects addObject:map[i][j]];
                break;
            }
        }
    }
    
    return foundObjects;
}

-(void)didBeginContactWith:(SKPhysicsBody*)physicsBody
{
    if(physicsBody.categoryBitMask == resourcesCategory) {
        [self destroy];
    } else if(physicsBody.categoryBitMask == spawningPointsCategory) {
        [self destroy];
    } else if(physicsBody.categoryBitMask == agentsAttackCategory) {
        if([physicsBody.node.parent isKindOfClass:[AgentTile class]]) {
            AgentTile* otherAgent = (AgentTile*)physicsBody.node.parent;
            
            if(otherAgent.owner != self.owner) {
                if(m_canAttack) {
                    self.currentTarget = nil;
                    m_canAttack = NO;
                }
                
                if([otherAgent canAgentAttack]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self destroy];
                    });
                }
            }
        }
    }
}

-(BOOL) canAgentAttack
{
    return m_canAttack;
}

-(void)update:(CFTimeInterval)currentTime
{
    if(currentTime > m_lastAttackTime + m_attackSpeed) {
        m_lastAttackTime = currentTime;
        m_canAttack = YES;
    }
    
    [self.stateMachine update:currentTime];
}

-(NSArray*)getMap
{
    return [self.delegate getMap];
}

-(void)moveToTarget
{
    if(_currentTarget != nil) {
        NSArray* path = [Algorithums FindPathInMap:[self getMap] fromAgent:self toTile:_currentTarget];
        if(path.count > 0)
            [self moveToTile:path.firstObject];
    }
}

-(void)moveToTile:(MapTile*)tile;
{
    self.parentTile.agentOnPosition = nil;
    
    if(self.mapPosition.y != tile.mapPosition.y) {
        self.zRotation = M_PI/2;
    } else {
        self.zRotation = 0;
    }
    
    self.mapPosition = tile.mapPosition;
    self.parentTile = tile;
    
    [self runAction:[SKAction moveTo:tile.position duration:0.3f]];
    
    self.parentTile.agentOnPosition = self;
}

@end
