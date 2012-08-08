//
//  AStarMap.h
//  AStarPathFinder
//
//  Created by Zhou Hangqing on 12-8-3.
//  Copyright (c) 2012年 UpPower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    kStatePassable = 0,
    kStateBlocked = 1
} ASState;

@class AStarMapNode;

@interface AStarNodeInfo : NSObject

@property (nonatomic, assign) float f;
@property (nonatomic, assign) float g;
@property (nonatomic, assign) float h;
@property (nonatomic, assign) AStarMapNode *parent;



@end

@interface AStarMapNode : NSObject

@property (nonatomic, assign) ASState state;
@property (nonatomic, assign) int xIndex;
@property (nonatomic, assign) int yIndex;
@property (nonatomic, assign) int infoIndex;
@property (nonatomic, retain) AStarNodeInfo *AStarInfo;
@property (nonatomic, assign) CGPoint coord;

- (NSComparisonResult)compareAStarF:(AStarMapNode *)node;
- (NSComparisonResult)compareAStarH:(AStarMapNode *)node;

@end

@interface AStarMap : NSObject
{
//    NSMutableArray *_mapInfos;
//    NSMutableArray *_AStarInfos;
    AStarMapNode ***_mapInfos;
    AStarNodeInfo **_AStarInfos;
    CGSize _mapSize;
    CGSize _tileSizeInPixels;
    int _nodeSum;
    int _xIndexMax;
    int _yIndexMax;
}



- (AStarMap *)initWithTiledMap:(CCTMXTiledMap *)map layerName:(NSString *)layerName;

- (void)resetAStarInfos;
- (AStarMapNode *)mapNodeWithCoord:(CGPoint)coord;



@end
