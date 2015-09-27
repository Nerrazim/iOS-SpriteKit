//
//  Algorithums.h
//  PixelWars
//
//  Created by Gandi Pirkov on 9/24/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  MapTile;
@class  AgentTile;

@interface Node : NSObject

-(instancetype) initWithNode:(MapTile*)node andParentId:(NSString*)parentId;

@property (nonatomic, weak) MapTile* node;
@property (nonatomic, assign) NSString* parentId;

@end

@interface Algorithums : NSObject

//Gets the path from the agent to the target with BFS
+(NSArray*)FindPathInMap:(NSArray<NSArray<MapTile *>*>*)map
               fromAgent:(AgentTile *)agent
                  toTile:(MapTile *)toTile;

//Gets the node neighbours Up,Down,Left,Right
+(NSMutableArray *) getNodeNeighborNodes:(MapTile*)node
                                forMap:(NSArray<NSArray<MapTile *>*>*)map
                             withAgent:(AgentTile*)agent;

@end
