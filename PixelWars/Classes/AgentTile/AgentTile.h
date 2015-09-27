//
//  AgentTile.h
//  PixelWars
//
//  Created by Gandi Pirkov on 9/22/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MapTile.h"
#import "StateMachine.h"
#import "WanderingState.h"
#import "CaptureCastleState.h"
#import "CaptureResourceState.h"
#import "EngageEnemyState.h"

const static int AGENT_VISIBILITY_RANGE = 8;

@protocol AgentDelegate <NSObject>

-(NSArray*) getMap;
-(NSArray*) getPlayers;

@end

@interface AgentTile : SKSpriteNode


@property (nonatomic, weak) Player* owner;
@property (nonatomic, weak) MapTile* parentTile;

@property (nonatomic, assign) CGPoint mapPosition;
@property (nonatomic, assign) MapTile* currentTarget;

@property (nonatomic, strong) StateMachine* stateMachine;
@property (nonatomic, weak) id<AgentDelegate> delegate;


-(instancetype)init;

-(void)update:(CFTimeInterval)currentTime;

-(void) destroy;

-(NSArray*)getMap;
-(void)moveToTarget;
-(void)moveToTile:(MapTile*)position;

-(BOOL) canAgentAttack;

-(void)didBeginContactWith:(SKPhysicsBody*)physicsBody;

-(NSArray<MapTile *> *)specialObjectsInRange;
-(NSArray<MapTile *> *)objectsInRange;

-(void) moveBlind;

@end
