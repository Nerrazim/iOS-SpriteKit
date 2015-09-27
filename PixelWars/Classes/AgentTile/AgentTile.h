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

//Agent visibility restriction
const static int AGENT_VISIBILITY_RANGE = 8;

@protocol AgentDelegate <NSObject>

-(NSArray*) getMap;
-(NSArray*) getPlayers;

@end

@interface AgentTile : SKSpriteNode


//Agent owner
@property (nonatomic, weak) Player* owner;

//The tile which the agent is on
@property (nonatomic, weak) MapTile* parentTile;
//Position of the Agent in the map array
//(The agent is not contained in the array used only for pathfinding )
@property (nonatomic, assign) CGPoint mapPosition;
//The tile for which the agent is heading
@property (nonatomic, assign) MapTile* currentTarget;
//Referrence to the State Machine
@property (nonatomic, strong) StateMachine* stateMachine;

@property (nonatomic, weak) id<AgentDelegate> delegate;


-(instancetype)init;

-(void)update:(CFTimeInterval)currentTime;

//Destroy and remove the agent from the map
-(void) destroy;

//Gets the map array
-(NSArray*)getMap;
//Moves the agent to currentTarget tile
-(void)moveToTarget;
//Moves the agent to tile
-(void)moveToTile:(MapTile*)position;

//Indicates if the agent can attack used in contact detection
-(BOOL) canAgentAttack;

-(void)didBeginContactWith:(SKPhysicsBody*)physicsBody;

//Retrns Array of Special Map objects like castles, resoruces
-(NSArray<MapTile *> *)specialObjectsInRange;

//Returns all tiles in range of the agent (AGENT_VISIBILITY_RANGE)
-(NSArray<MapTile *> *)objectsInRange;

//Moves the agent blindly when there is not target in range
//Random was too bad so the agent moves towards random enemy castle if there is any 
-(void) moveBlind;

@end
