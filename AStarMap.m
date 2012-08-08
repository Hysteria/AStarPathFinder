//
//  AStarMap.m
//  AStarPathFinder
//
//  Created by Zhou Hangqing on 12-8-3.
//  Copyright (c) 2012年 UpPower. All rights reserved.
//

#import "AStarMap.h"

@implementation AStarNodeInfo

@synthesize f = _f, g = _g, h = _h,
parent = _parent;


@end

@implementation AStarMapNode

@synthesize
state = _state,
xIndex = _xIndex,
yIndex = _yIndex,
infoIndex = _infoIndex,
AStarInfo = _AStarInfo,
coord = _coord;


- (void)dealloc
{
    //
    [super dealloc];
}

- (NSComparisonResult)compareAStarF:(AStarMapNode *)node
{
    if (self.AStarInfo.f < node.AStarInfo.f) {
        return NSOrderedAscending;
    } else if (self.AStarInfo.f > node.AStarInfo.f) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (NSComparisonResult)compareAStarH:(AStarMapNode *)node
{
    if (self.AStarInfo.h < node.AStarInfo.h) {
        return NSOrderedAscending;
    } else if (self.AStarInfo.h > node.AStarInfo.h) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"f:%.2f,g:%.2f,h:%.2f,state:%d,coord:%.02f,%.02f", self.AStarInfo.f, self.AStarInfo.g, self.AStarInfo.h, self.state, self.coord.x,self.coord.y];
}

@end

@implementation AStarMap

- (AStarMap *)initWithTiledMap:(CCTMXTiledMap *)map layerName:(NSString *)layerName
{
    self = [super init];
    if (self) {
        NSAssert(map != nil, @"Tiled map must not be nil!");
        _mapSize = map.mapSize;
        if (CC_CONTENT_SCALE_FACTOR() == 2) {
            _tileSizeInPixels = CGSizeMake(map.tileSize.width * 0.5, map.tileSize.height * 0.5);
        } else {
            _tileSizeInPixels = map.tileSize;
        }
        _xIndexMax = _mapSize.width;
        _yIndexMax = _mapSize.height;
        _nodeSum = _xIndexMax * _yIndexMax;
        
        
        _mapInfos = (AStarMapNode***)malloc(sizeof(AStarMapNode*) * _xIndexMax);
        for (int i = 0; i < _xIndexMax; i++) {
            _mapInfos[i] =  (AStarMapNode**)malloc(sizeof(AStarMapNode*) * _yIndexMax);
            for (int j = 0; j < _yIndexMax; j++) {
//                **_mapInfos = (AStarMapNode*)malloc(sizeof(AStarMapNode*));
                _mapInfos[i][j] = [[AStarMapNode alloc] init];
            }
        }
        
        _AStarInfos = (AStarNodeInfo**)malloc(sizeof(AStarNodeInfo*) * _nodeSum);
        for (int i = 0; i < _nodeSum; i++) {
            _AStarInfos[i] = [[AStarNodeInfo alloc] init];
        }
        
        
        int infoIndex = 0;
        
        CCTMXLayer *movebleLayer = [map layerNamed:layerName];
        for (int i = 0; i < _xIndexMax; i++) {
            for (int j = 0; j < _yIndexMax; j++, infoIndex++) {
                
                int gid = [movebleLayer tileGIDAt:ccp(i, j)];
                if (gid > 0) {
                    AStarMapNode *node = _mapInfos[i][j];

                    node.coord = ccp(i, j);
                    node.infoIndex = infoIndex;
                    node.AStarInfo = _AStarInfos[infoIndex];
                    
                    NSDictionary *dic = [map propertiesForGID:gid];
                    if (dic) {
                        _mapInfos[i][j].state = [[dic objectForKey:@"state"] intValue];
                    }
                }
                
//                AStarMapNode *node = &*_mapInfos[i][j];
//                node.coord = ccp(i, j);
//                node.infoIndex = infoIndex;
//                node.AStarInfo = &*_AStarInfos[infoIndex];
//                node.state = 1;
//                int gid = [movebleLayer tileGIDAt:ccp(i, j)];
//                if (gid > 0) {
//                    node.state = 0;
//                }
                
            }
        }
        /*
        // Init AStarInfo
        _AStarInfos = [[NSMutableArray alloc] initWithCapacity:_nodeSum];
        for (int i = 0; i < _nodeSum; i++) {
            [_AStarInfos addObject:[[AStarNodeInfo alloc] init]];
        }
        // Init mapInfo 
        int infoIndex = 0;
        CCTMXLayer *movableLayer = [map layerNamed:layerName];
        _mapInfos = [[NSMutableArray alloc] initWithCapacity:_xIndexMax];
        for (int i = 0; i < _xIndexMax; i++) {
            NSMutableArray *mapInfoColumn = [NSMutableArray arrayWithCapacity:_xIndexMax];
            for (int j = 0; j < _yIndexMax; j++, infoIndex++) {
                AStarMapNode *node = [[[AStarMapNode alloc] init] autorelease];
                int tileGID = [movableLayer tileGIDAt:ccp(i, j)];
                if (tileGID > 0) {
                    node.coord = ccp(i, j);
                    node.infoIndex = infoIndex;
                    node.AStarInfo = [_AStarInfos objectAtIndex:infoIndex];
                    NSDictionary *dic = [map propertiesForGID:tileGID];
                    if (dic) {
                        node.state = [[dic objectForKey:@"state"] intValue];
                    }
                }
                
//                node.coord = ccp(i, j);
//                node.infoIndex = infoIndex;
//                node.AStarInfo = [_AStarInfos objectAtIndex:infoIndex];
//                node.state = 1;
//                
//                int tileGID = [movableLayer tileGIDAt:ccp(i, j)];
//                
//                if (tileGID > 0) {
//                    node.state = 0;
//                } 
                [mapInfoColumn addObject:node];
            }
            
            [_mapInfos addObject:mapInfoColumn];
        }*/
        
    }
    return self;
}


//- (AStarMap *)initWithTiledMap:(CCTMXTiledMap *)map layerName:(NSString *)layerName
//{
//    self = [super init];
//    if (self) {
//        NSAssert(map != nil, @"Tiled map must not be nil!");
//        _mapSize = map.mapSize;
//        if (CC_CONTENT_SCALE_FACTOR() == 2) {
//            _tileSizeInPixels = CGSizeMake(map.tileSize.width * 0.5, map.tileSize.height * 0.5);
//        } else {
//            _tileSizeInPixels = map.tileSize;
//        }
//        _xIndexMax = _mapSize.width;
//        _yIndexMax = _mapSize.height;
//        _nodeSum = _xIndexMax * _yIndexMax;
//            
//        // Init AStarInfo
//        _AStarInfos = [[NSMutableArray alloc] initWithCapacity:_nodeSum];
//        for (int i = 0; i < _nodeSum; i++) {
//            [_AStarInfos addObject:[[AStarNodeInfo alloc] init]];
//        }
//        // Init mapInfo 
//        int infoIndex = 0;
//        _mapInfos = [[NSMutableArray alloc] initWithCapacity:_xIndexMax];
//        for (int i = 0; i < _xIndexMax; i++) {
//            NSMutableArray *mapInfoColumn = [NSMutableArray arrayWithCapacity:_xIndexMax];
//            for (int j = 0; j < _yIndexMax; j++, infoIndex++) {
//                AStarMapNode *node = [[[AStarMapNode alloc] init] autorelease];
//                CCTMXLayer *layer = [map layerNamed:layerName];
//                int tileGID = [layer tileGIDAt:ccp(i, j)];
//                if (tileGID > 0) {
////                    node.xIndex = i;
////                    node.yIndex = j;
//                    node.coord = ccp(i, j);
//                    node.infoIndex = infoIndex;
//                    node.AStarInfo = [_AStarInfos objectAtIndex:infoIndex];
//                    NSDictionary *properties = [map propertiesForGID:tileGID];
//                    if (properties) {
//                        node.state = (ASState)[[properties objectForKey:@"state"] intValue];
//                    }
//                }
//                [mapInfoColumn addObject:node];
//            }
//            
//            [_mapInfos addObject:mapInfoColumn];
//        }
//        
//    }
//    return self;
//}

//- (void)resetAStarInfos
//{
//    [_AStarInfos release];
//    _AStarInfos = [[NSMutableArray alloc] initWithCapacity:_nodeSum];
//    for (int i = 0; i < _nodeSum; i++) {
//        [_AStarInfos addObject:[[[AStarNodeInfo alloc] init] autorelease]];
//    }
//}

- (void)resetAStarInfos
{
//    memset(_AStarInfos, 0, sizeof(AStarNodeInfo*));
    
    for (int i = 0; i < _nodeSum; i++) {
        [_AStarInfos[i] release];
        _AStarInfos[i] = [[AStarNodeInfo alloc] init];
    }

}

//- (AStarMapNode *)mapNodeWithCoord:(CGPoint)coord
//{
//    assert(_mapInfos);
//    CGRect mapRect = CGRectMake(0, 0, _mapSize.width, _mapSize.height);
//    if (CGRectContainsPoint(mapRect, coord)) {
//        return [[_mapInfos objectAtIndex:coord.x] objectAtIndex:coord.y];
//    }
//    return nil;
//}

- (AStarMapNode *)mapNodeWithCoord:(CGPoint)coord
{
    if (0 <= coord.x && coord.x < _xIndexMax && 0 <= coord.y && coord.y < _yIndexMax) {
        int x = coord.x;
        int y = coord.y;
        return &*_mapInfos[x][y];
    }
    return nil;
}


@end
