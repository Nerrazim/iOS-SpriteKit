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
    NSMutableSet<MapTile*> *visitedNodes = [NSMutableSet setWithObject:startingNode];
    NSMutableArray<MapTile*> *queue = [NSMutableArray arrayWithObject:startingNode];
    NSMutableArray<MapTile*>* searchedPath = [NSMutableArray array];
    
    NSMutableDictionary<NSString*,Node*>* paths = [NSMutableDictionary dictionary];
    
    //BFS
    while ([queue count] > 0)
    {
        MapTile* reviewedTile = [queue objectAtIndex:0];
        
        //if searched object is found build path and stop the search
        if([toTile isEqual:reviewedTile]) {
            
            Node* reviewedNode = [paths objectForKey:reviewedTile.tileId];
            
            while(reviewedNode != nil) {
                [searchedPath addObject:reviewedNode.node];
                reviewedNode = [paths objectForKey:reviewedNode.parentId];
            }
            break;
        }
        
        NSMutableSet *newNodes = [self getNodeNeighborNodes:reviewedTile forMap:map withAgent:agent];
        
        [newNodes minusSet:visitedNodes];
        [self setParent:reviewedTile forNodes:newNodes.allObjects inPaths:paths];
        
        [visitedNodes unionSet:newNodes];
        
        [queue addObjectsFromArray:[newNodes allObjects]];
        
        [queue removeObjectAtIndex:0];
    }
    
    //returns path to the object
    return searchedPath.reverseObjectEnumerator.allObjects;
}

+(NSMutableSet *) getNodeNeighborNodes:(MapTile*)node forMap:(NSArray<NSArray<MapTile *>*>*)map withAgent:(AgentTile*)agent
{
    NSMutableSet *newNodes = [NSMutableSet set];
    CGPoint nodePosition = node.mapPosition;
    
    if(nodePosition.x < map.count - 1)
    {
        [self addNodeIfNeededToSet:newNodes fromMap:map atPositionX:(int)nodePosition.x + 1 PositionY:(int)nodePosition.y andAgent:agent];
    }
    
    if(nodePosition.x > 0)
    {
        [self addNodeIfNeededToSet:newNodes fromMap:map atPositionX:(int)nodePosition.x - 1 PositionY:(int)nodePosition.y andAgent:agent];
    }
    
    if(nodePosition.y < map[(int)nodePosition.x].count - 1)
    {
        [self addNodeIfNeededToSet:newNodes fromMap:map atPositionX:(int)nodePosition.x PositionY:(int)nodePosition.y + 1 andAgent:agent];
    }
    
    if(nodePosition.y > 0)
    {
        [self addNodeIfNeededToSet:newNodes fromMap:map atPositionX:(int)nodePosition.x PositionY:(int)nodePosition.y - 1 andAgent:agent];
    }
    
    return newNodes;
}

+(void) addNodeIfNeededToSet:(NSMutableSet*)set
                     fromMap:(NSArray<NSArray<MapTile *>*>*)map
                 atPositionX:(int)x
                   PositionY:(int)y
                       andAgent:(AgentTile*)agent
{
    MapTile* node = map[x][y];
    
    if(node.tileType != TileTypeWall && node.owner != agent.owner && node.isThereAgentOnPosition == NO ) {
        [set addObject:node];
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
