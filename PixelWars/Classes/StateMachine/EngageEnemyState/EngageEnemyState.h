//
//  EngageEnemyState.h
//  PixelWars
//
//  Created by Gandi Pirkov on 9/26/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"

@interface EngageEnemyState : NSObject

+ (id)sharedInstance;

- (void)Enter:(AgentTile*)agent;

- (void)Execute:(AgentTile*)agent;

- (void)Exit:(AgentTile*)agent;

@end
