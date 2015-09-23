//
//  ResourceTile.h
//  PixelWars
//
//  Created by Gandi Pirkov on 9/22/15.
//  Copyright © 2015 Gandi Pirkov. All rights reserved.
//

#import "MapTile.h"

@interface ResourceTile : MapTile

@property (nonatomic, assign) double resourceModifier;

-(instancetype) initWithPosition:(CGPoint)mapPosition;
-(void)update:(CFTimeInterval)currentTime;

@end
