//
//  WanderingState.h
//  PixelWars
//
//  Created by Gandi Pirkov on 9/23/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"

@interface WanderingState : NSObject <State>

+ (id)sharedInstance;

-(void) Enter:(AgentTile*)agent;

-(void) Execute:(AgentTile*)agent;

-(void) Exit:(AgentTile*)agent;

@end
