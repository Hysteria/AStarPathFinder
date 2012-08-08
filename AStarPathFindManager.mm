//
//  AStarPathFindManager.m
//  AStarPathFinder
//
//  Created by Zhou Hangqing on 12-8-7.
//  Copyright (c) 2012年 UpPower. All rights reserved.
//

#import "AStarPathFindManager.h"
#import "AStarSearcher.h"
#import "GameMap.h"

@implementation AStarPathFindManager

static AStarPathFindManager *sharedInstance = nil;

+ (AStarPathFindManager *)defaultManager
{
    @synchronized([AStarPathFindManager class])
    {
        if (!sharedInstance) 
            [[self alloc] init];
        return sharedInstance;
    }
    return nil;
}

+ (id)alloc
{
    @synchronized ([AStarPathFindManager class])
    {
        NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of the AStarPathFindManager singleton");
        sharedInstance = [super alloc];
        return sharedInstance;
    }
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        _AStarSearcher = AStarSearcher::sharedSearcher();
        _AStarMap = GameMap::sharedMap();
    }
    return self;
}

- (NSArray *)findPathFromOrigin:(CGPoint)origin toDestination:(CGPoint)destination
{  
    int srcNodeX = 0;
    int srcNodeY = 0;
    int destNodeX = 0;
    int destNodeY = 0;
    std::vector<MapNode*> *path_out = new std::vector<MapNode*>;
    _AStarMap->convertToMapCoordinate(origin, srcNodeX, srcNodeY);
    MapNode *srcNode = _AStarMap->getNodeAt(srcNodeX, srcNodeY);
    _AStarMap->convertToMapCoordinate(destination, destNodeX, destNodeY);
    MapNode *destNode = _AStarMap->getNodeAt(destNodeX, destNodeY);
    
    _AStarSearcher->findPath(srcNode, destNode, path_out);
    
    NSMutableArray *path = [NSMutableArray array];
    while (path_out->size() != 0) {
        MapNode *node = *path_out->end()
        [path insertObject:node atIndex:0];
    }
    
    return [[path copy] autorelease];
}


@end
