//
//  StateMachine.m
//  PixelWars
//
//  Created by Gandi Pirkov on 9/22/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import "StateMachine.h"

@interface StateMachine() {
    double m_ActionSpeed;
    double m_lastActionTime;
}
@end

@implementation StateMachine

-(instancetype) initWithOwner:(AgentTile*)owner currentState:(NSObject<State>*)currentState
        previousState:(NSObject<State>*)previousState
          globalState:(NSObject<State>*)globalState;
{
    if(self = [super init]) {
        self.m_pOwner = owner;
        self.m_pCurrentState = currentState;
        self.m_pPreviousState = previousState;
        self.m_pGlobalState = globalState;
        
        m_ActionSpeed = 1;
        m_lastActionTime = 1;
    }
    
    return self;
}

//call this to update the FSM
-(void)update:(CFTimeInterval)currentTime
{
    if(currentTime > m_lastActionTime + m_ActionSpeed) {
        m_lastActionTime = currentTime;
        //if a global state exists, call its execute method, else do nothing
        if(self.m_pGlobalState)
            [self.m_pGlobalState Execute:self.m_pOwner];
    
        //same for the current state
        if (self.m_pCurrentState)
            [self.m_pCurrentState Execute:self.m_pOwner];
    }
}

-(void)changeState:(NSObject<State>*) pNewState
{
    //keep a record of the previous state
    self.m_pPreviousState = self.m_pCurrentState;
    
    //call the exit method of the existing state
    [pNewState Exit:self.m_pOwner];
    
    //change state to the new state
    self.m_pCurrentState = pNewState;
    
    //call the entry method of the new state
    [pNewState Enter:self.m_pOwner];
}

-(void)revertToPreviousState
{
    [self changeState:self.m_pPreviousState];
}

-(BOOL)isInState:(NSObject<State>*) state
{
    return [self.m_pCurrentState isEqual:state];
}

@end
