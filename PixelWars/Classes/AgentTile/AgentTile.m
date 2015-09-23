//
//  AgentTile.m
//  PixelWars
//
//  Created by Gandi Pirkov on 9/22/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import "AgentTile.h"
#import "WanderingState.h"

@interface AgentTile() {

}

@end

@implementation AgentTile

-(instancetype)init
{
    if(self = [super initWithImageNamed:@"warrior.png"]) {
        self.stateMachine = [[StateMachine alloc] initWithOwner:self
                                                   currentState:WanderingState.sharedInstance
                                                  previousState:nil
                                                    globalState:nil];
    }
    
    return self;
}

-(void)update:(CFTimeInterval)currentTime
{
    [self.stateMachine update:currentTime];
}

-(NSArray*)getVisibleTilesForPosition
{
    return [self.delegate getVisibleTilesForPosition:self.mapPosition];
}

-(void)moveToTile:(MapTile*)tile;
{
    self.mapPosition = tile.mapPosition;
    [self runAction:[SKAction moveTo:tile.position duration:0.3f]];
}

@end
