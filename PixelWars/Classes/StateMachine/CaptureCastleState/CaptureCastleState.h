//
//  CaptureCastleState.h
//  PixelWars
//
//  Created by Gandi Pirkov on 9/24/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"

@interface CaptureCastleState : NSObject

+ (id)sharedInstance;

- (void)Enter:(AgentTile*)agent;

- (void)Execute:(AgentTile*)agent;

- (void)Exit:(AgentTile*)agent;

@end
