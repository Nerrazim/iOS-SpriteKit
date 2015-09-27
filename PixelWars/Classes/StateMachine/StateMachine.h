//
//  StateMachine.h
//  PixelWars
//
//  Created by Gandi Pirkov on 9/23/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"

@class AgentTile;


@interface StateMachine : NSObject{
    
}

@property (nonatomic, weak) AgentTile* m_pOwner;

@property (nonatomic, weak) NSObject<State>* m_pCurrentState;
@property (nonatomic, weak) NSObject<State>* m_pPreviousState;
@property (nonatomic, weak) NSObject<State>* m_pGlobalState;

-(instancetype) initWithOwner:(AgentTile*)owner currentState:(NSObject<State>*)currentState
                                        previousState:(NSObject<State>*)previousState
                                        globalState:(NSObject<State>*)globalState;

-(void)update:(CFTimeInterval)currentTime;

-(void)changeState:(NSObject<State>*) pNewState;
-(void)revertToPreviousState;
-(BOOL)isInState:(NSObject<State>*) state;

@end
