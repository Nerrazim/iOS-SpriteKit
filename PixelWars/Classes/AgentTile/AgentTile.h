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


const static int AGENT_VISIBILITY_RANGE = 4;

@protocol AgentDelegate <NSObject>

-(NSArray*) getMap;

@end

@interface AgentTile : SKSpriteNode

@property (nonatomic, weak) id<AgentDelegate> delegate;
@property (nonatomic, weak) MapTile* parentTile;
@property (nonatomic, assign) CGPoint mapPosition;
@property (nonatomic, strong) StateMachine* stateMachine;
@property (nonatomic, strong) Player* owner;

-(instancetype)init;

-(void)update:(CFTimeInterval)currentTime;


-(NSArray*)getMap;
-(void)moveToTile:(MapTile*)position;

@end
