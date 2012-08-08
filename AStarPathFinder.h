//
//  AStarPathFinder.h
//  AStarPathFinder
//
//  Created by Zhou Hangqing on 12-8-3.
//  Copyright (c) 2012年 UpPower. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "AStarMap.h"
#import "MoveObject.h"

@class AStarSet;

@interface AStarPathFinder : NSObject
{
    NSMutableArray *_openList;
    NSMutableArray *_closeList;
//    AStarSet *_set;
}

@property (nonatomic, retain) AStarMap *map;

+ (AStarPathFinder *)sharedPathFinder;
- (NSArray *)findPathFromSrc:(AStarMapNode *)srcNode toDest:(AStarMapNode *)destNode; // Retrieve Paths contain AStarMapNodes from end node to begin node.
//- (NSArray *)findPathForObject:(MoveObject *)object toDest:(AStarMapNode *)destNode;
- (NSArray *)findPathFromOrigin:(CGPoint)origin toDestination:(CGPoint)destination;


@end
