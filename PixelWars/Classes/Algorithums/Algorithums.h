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

@property (nonatomic, strong) MapTile* node;
@property (nonatomic, assign) NSString* parentId;

@end

@interface Algorithums : NSObject

+(NSArray*)FindPathInMap:(NSArray<NSArray<MapTile *>*>*)map
               fromAgent:(AgentTile *)agent
                  toTile:(MapTile *)toTile
               withDepth:(int)depth;

+(NSMutableSet *) getNodeNeighborNodes:(MapTile*)node
                                forMap:(NSArray<NSArray<MapTile *>*>*)map
                             withAgent:(AgentTile*)agent;

@end
