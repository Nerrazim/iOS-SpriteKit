//
//  State.h
//  PixelWars
//
//  Created by Gandi Pirkov on 9/23/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AgentTile;

@protocol State <NSObject>
@required
//this will execute when the state is entered
-(void) Enter:(AgentTile*)agent;

//this is the states normal update function
-(void) Execute:(AgentTile*)agent;

//this will execute when the state is exited. (My word, isn't
//life full of surprises... ;o))
-(void) Exit:(AgentTile*)agent;
@end
