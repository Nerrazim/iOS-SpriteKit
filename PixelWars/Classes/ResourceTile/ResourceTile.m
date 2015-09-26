//
//  ResourceTile.m
//  PixelWars
//
//  Created by Gandi Pirkov on 9/22/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import "ResourceTile.h"
#import "AgentTile.h"
#import "Player.h"

@interface ResourceTile() {

}

@end

@implementation ResourceTile

-(instancetype) initWithPosition:(CGPoint)mapPosition
{
    if(self = [super initWithImageNamed:@"square.png" position:mapPosition andType:TileTypeResource]) {
        _resourceModifier = 0.2f;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width/2, self.size.height/2)];
        self.physicsBody.collisionBitMask = 0;
        self.physicsBody.contactTestBitMask = agentsCategory;
        self.physicsBody.categoryBitMask = resourcesCategory;
        self.physicsBody.dynamic = YES;
    }
    
    return self;
}

-(void)didBeginContactWith:(SKPhysicsBody*)physicsBody
{
    Player* owner = ((AgentTile*)physicsBody.node).owner;
    if(self.owner != owner) {
        [owner addResource:self];
        self.owner = owner;
    }
}

-(void)update:(CFTimeInterval)currentTime
{

}

@end
