//
//  Algorithums.m
//  PixelWars
//
//  Created by Gandi Pirkov on 9/24/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import "Algorithums.h"
#import "MapTile.h"
#import "AgentTile.h"

@implementation Node

-(instancetype) initWithNode:(MapTile*)node andParentId:(NSString*)parentId
{
    if(self = [super init]) {
        _node = node;
        _parentId = parentId;
    }
    
    return self;
}

@end

@implementation Algorithums

+(NSArray*)FindPathInMap:(NSArray<NSArray<MapTile *>*>*)map fromAgent:(AgentTile *)agent toTile:(MapTile *)toTile
{
    CGPoint fromPosition = agent.parentTile.mapPosition;
    
    //Getting startinNode
    MapTile* startingNode = map[(int)fromPosition.x][(int)fromPosition.y];
    
    //Preparing visitedNodes and Queue objects
    NSMutableDictionary<NSString*,MapTile*> *visitedNodes = [NSMutableDictionary dictionaryWithObject:startingNode forKey:startingNode.tileId];
    NSMutableArray<MapTile*> *queue = [NSMutableArray arrayWithObject:startingNode];
    NSMutableArray<MapTile*>* searchedPath = [NSMutableArray array];
    
    NSMutableDictionary<NSString*,Node*>* paths = [NSMutableDictionary dictionaryWithObject:[[Node alloc] initWithNode:startingNode andParentId:nil] forKey:startingNode.tileId];
    
    //BFS
    while ([queue count] > 0)
    {
        MapTile* reviewedTile = [queue objectAtIndex:0];
        
        //if searched object is found build path and stop the search
        if([toTile isEqual:reviewedTile]) {
            
            Node* reviewedNode = [paths objectForKey:reviewedTile.tileId];
            
            while(reviewedNode.parentId != nil) {
                [searchedPath addObject:reviewedNode.node];
                reviewedNode = [paths objectForKey:reviewedNode.parentId];
            }
            break;
        }
        
        NSMutableArray<MapTile*> *newNodes = [self getNodeNeighborNodes:reviewedTile forMap:map withAgent:agent];
        NSMutableArray<MapTile*> *newNodesCopy = [NSMutableArray arrayWithArray:newNodes];
        
        for(int i = 0; i < newNodesCopy.count; ++i) {
            if(visitedNodes[newNodesCopy[i].tileId]) {
                [newNodes removeObject:newNodesCopy[i]];
            } else {
                [visitedNodes setObject:newNodesCopy[i] forKey:newNodesCopy[i].tileId];
            }
        }
        
        [self setParent:reviewedTile forNodes:newNodes inPaths:paths];
        
        [queue addObjectsFromArray:newNodes];
        
        [queue removeObjectAtIndex:0];
    }
    
    //returns path to the object
    return searchedPath.reverseObjectEnumerator.allObjects;
}

+(NSMutableArray *) getNodeNeighborNodes:(MapTile*)node forMap:(NSArray<NSArray<MapTile *>*>*)map withAgent:(AgentTile*)agent
{
    NSMutableArray *newNodes = [NSMutableArray array];
    CGPoint nodePosition = node.mapPosition;
    
    if(nodePosition.x < map.count - 1)
    {
        [self addNodeIfNeededToArray:newNodes fromMap:map atPositionX:(int)nodePosition.x + 1 PositionY:(int)nodePosition.y andAgent:agent];
    }
    
    if(nodePosition.x > 0)
    {
        [self addNodeIfNeededToArray:newNodes fromMap:map atPositionX:(int)nodePosition.x - 1 PositionY:(int)nodePosition.y andAgent:agent];
    }
    
    if(nodePosition.y < map[(int)nodePosition.x].count - 1)
    {
        [self addNodeIfNeededToArray:newNodes fromMap:map atPositionX:(int)nodePosition.x PositionY:(int)nodePosition.y + 1 andAgent:agent];
    }
    
    if(nodePosition.y > 0)
    {
        [self addNodeIfNeededToArray:newNodes fromMap:map atPositionX:(int)nodePosition.x PositionY:(int)nodePosition.y - 1 andAgent:agent];
    }
    
    return newNodes;
}

+(void) addNodeIfNeededToArray:(NSMutableArray*)array
                     fromMap:(NSArray<NSArray<MapTile *>*>*)map
                 atPositionX:(int)x
                   PositionY:(int)y
                       andAgent:(AgentTile*)agent
{
    MapTile* node = map[x][y];
    
    if(node.tileType != TileTypeWall && node.owner != agent.owner) {
        [array addObject:node];
    }
}

+(void) setParent:(MapTile*)parent forNodes:(NSArray*)nodes inPaths:(NSMutableDictionary<NSString*,Node*>*)paths
{
    for(int i = 0; i < nodes.count; ++i) {
        [paths setObject:[[Node alloc] initWithNode:nodes[i] andParentId:parent.tileId]
                  forKey:[nodes[i] tileId]];
    }
}

@end
