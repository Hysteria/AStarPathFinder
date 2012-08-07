//
//  AStarPathFinder.m
//  AStarPathFinder
//
//  Created by Zhou Hangqing on 12-8-3.
//  Copyright (c) 2012年 UpPower. All rights reserved.
//

#import "AStarPathFinder.h"
#import "MapManager.h"
//#import "AStarSet.h"

@implementation AStarPathFinder

@synthesize map = _map;

- (void)dealloc
{
    [_openList release];
    [_closeList release];
    
    [_map release];
    [super dealloc];
}
//
// singleton stuff
//
static AStarPathFinder *sharedInstance = nil;

+ (AStarPathFinder *)sharedPathFinder
{
    @synchronized([AStarPathFinder class])
    {
        if (!sharedInstance) 
            [[self alloc] init];
        return sharedInstance;
    }
    return nil;
}

+ (id)alloc
{
    @synchronized ([AStarPathFinder class])
    {
        NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of the AStarPathFinder singleton");
        sharedInstance = [super alloc];
        return sharedInstance;
    }
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        _openList = [[NSMutableArray alloc] init];
        _closeList = [[NSMutableArray alloc] init];
//        _set = [[AStarSet alloc] init];
    }
    return self;
}

- (NSArray *)findPathFromSrc:(AStarMapNode *)srcNode toDest:(AStarMapNode *)destNode
{
    BOOL isGoal = NO;
    srcNode.AStarInfo.g = 0;
    srcNode.AStarInfo.h = ccpDistance(srcNode.coord, destNode.coord);
    srcNode.AStarInfo.f = srcNode.AStarInfo.g + srcNode.AStarInfo.h;
    [_openList addObject:srcNode];
//    _set.openList->insert(srcNode);
    
    AStarMapNode *mapNode = nil;
    
    while (_openList.count > 0) {
//    while (!_set.openList->empty()) {
    
        mapNode = [_openList objectAtIndex:0];
//        mapNode = *_set.openList->begin();
        
        [_openList removeObject:mapNode];
        [_closeList addObject:mapNode];
//        _set.openList->erase(mapNode);
//        _set.closeList->insert(mapNode);
        
        if ([mapNode isEqual:destNode]) {
            isGoal = YES;
            break;
        }
        
        NSMutableArray *mapNodes = [NSMutableArray arrayWithCapacity:8];
        AStarMapNode *tmpNode = nil;
        tmpNode = [_map mapNodeWithCoord:ccp(mapNode.coord.x-1, mapNode.coord.y)]; //West
        [mapNodes addObject:tmpNode?tmpNode:[NSNull null]]; 
        tmpNode = [_map mapNodeWithCoord:ccp(mapNode.coord.x+1, mapNode.coord.y)]; //East
        [mapNodes addObject:tmpNode?tmpNode:[NSNull null]]; 
        tmpNode = [_map mapNodeWithCoord:ccp(mapNode.coord.x, mapNode.coord.y+1)]; //South
        [mapNodes addObject:tmpNode?tmpNode:[NSNull null]]; 
        tmpNode = [_map mapNodeWithCoord:ccp(mapNode.coord.x, mapNode.coord.y-1)]; //North
        [mapNodes addObject:tmpNode?tmpNode:[NSNull null]]; 
        tmpNode = [_map mapNodeWithCoord:ccp(mapNode.coord.x-1, mapNode.coord.y+1)]; //SouthWest
        [mapNodes addObject:tmpNode?tmpNode:[NSNull null]]; 
        tmpNode = [_map mapNodeWithCoord:ccp(mapNode.coord.x+1, mapNode.coord.y+1)]; //SouthEast
        [mapNodes addObject:tmpNode?tmpNode:[NSNull null]]; 
        tmpNode = [_map mapNodeWithCoord:ccp(mapNode.coord.x-1, mapNode.coord.y-1)]; //NorthWest
        [mapNodes addObject:tmpNode?tmpNode:[NSNull null]]; 
        tmpNode = [_map mapNodeWithCoord:ccp(mapNode.coord.x+1, mapNode.coord.y-1)]; //NorthEast
        [mapNodes addObject:tmpNode?tmpNode:[NSNull null]]; 

    
        AStarMapNode *tempNode = nil;
        for (int i = 0; i < 8; i++) {
            tempNode = [mapNodes objectAtIndex:i];
            if ([tempNode isEqual:[NSNull null]]) {
                continue;
            }
            
            // Node is in closeList or node can't pass through
            if ([_closeList containsObject:tempNode] || tempNode.state == kStateBlocked) {
                continue;
            }
//            if (_set.closeList->count(tempNode) > 0 || tempNode.state != kStatePassable) {
//                continue;
//            }
                    
            float tempG = mapNode.AStarInfo.g + ccpDistance(tempNode.coord, mapNode.coord);
            // Node is in openList 
            if ([_openList containsObject:tempNode]) {
//            if (_set.openList->count(tempNode) > 0) {
                if (tempG < tempNode.AStarInfo.g) {
                    [_openList removeObject:tempNode];
//                    _set.openList->erase(tempNode);
                    tempNode.AStarInfo.g = tempG;
                    tempNode.AStarInfo.h = ccpDistance(tempNode.coord, mapNode.coord);
                    tempNode.AStarInfo.f = tempNode.AStarInfo.g + tempNode.AStarInfo.h;
                    tempNode.AStarInfo.parent = mapNode;
                    [_openList addObject:tempNode];
//                    _set.openList->insert(tempNode);
                }
            }
            // Node is not in closeList nor openList
            else {
                tempNode.AStarInfo.g = tempG;
                tempNode.AStarInfo.h = ccpDistance(tempNode.coord, mapNode.coord);
                tempNode.AStarInfo.f = tempNode.AStarInfo.g + tempNode.AStarInfo.h;
                tempNode.AStarInfo.parent = mapNode;
                [_openList addObject:tempNode];
//                _set.openList->insert(tempNode);
            }
        }
       
//        int ot = clock();
//        [_openList sortUsingSelector:@selector(compareAStarF:)];
//        CCLOG(@"sort cost:%d", clock()-ot);
    } 
    
    if (!isGoal) {
        [_closeList sortUsingSelector:@selector(compareAStarH:)];

        mapNode = [_closeList objectAtIndex:0];
//        mapNode = *_set.closeList->begin();
    }
    
    NSMutableArray *path = [NSMutableArray array];
    while (![mapNode isEqual:srcNode]) {
        [path addObject:mapNode];
        mapNode = mapNode.AStarInfo.parent;
    }
    

    [_map resetAStarInfos];
    
    
    [_openList removeAllObjects];
    [_closeList removeAllObjects];
//    [_set reset];
    
    return [[path copy] autorelease];
}

- (NSArray *)findPathForObject:(MoveObject *)object toDest:(AStarMapNode *)destNode
{
    CGPoint coord = [[MapManager sharedMapManager] tileCoordForPosition:object.position];
    AStarMapNode *srcNode = [_map mapNodeWithCoord:coord];
    return [self findPathFromSrc:srcNode toDest:destNode];
}



@end
