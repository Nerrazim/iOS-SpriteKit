//
//  ResourceTile.m
//  PixelWars
//
//  Created by Gandi Pirkov on 9/22/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import "ResourceTile.h"

@interface ResourceTile() {

}

@end

@implementation ResourceTile

-(instancetype) initWithPosition:(CGPoint)mapPosition
{
    if(self = [super initWithImageNamed:@"square.png" position:mapPosition andType:TileTypeResource]) {
        _resourceModifier = 0.2f;
    }
    
    return self;
}

-(void)update:(CFTimeInterval)currentTime
{

}

@end
