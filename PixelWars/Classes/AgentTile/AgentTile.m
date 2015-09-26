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
        
        _contactBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
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
    self.parentTile.isThereAgentOnPosition = false;
    [self removeFromParent];
    [self.owner removeAgent:self];  
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
            
            if (map[i][j].tileType == TileTypeResource && map[i][j].owner != self.owner) {
                [foundObjects addObject:map[i][j]];
            } else if (map[i][j].tileType == TileTypeSpawningPoint && map[i][j].owner != self.owner) {
                [foundObjects addObject:map[i][j]];
            }
        }
    }
    
    return foundObjects;
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
            
            [foundObjects addObject:map[i][j]];
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
    }
}

-(void)update:(CFTimeInterval)currentTime
{
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
    self.parentTile.isThereAgentOnPosition = NO;
    
    self.mapPosition = tile.mapPosition;
    self.parentTile = tile;
    
    if(self.position.x != tile.position.x) {
        self.zRotation = M_PI/2;
    } else {
        self.zRotation = 0;
    }
    
    [self runAction:[SKAction moveTo:tile.position duration:0.3f]];
    
    self.parentTile.isThereAgentOnPosition = YES;
}

@end
