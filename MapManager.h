//
//  MapManager.h
//  PiratesTD.reconstruction
//
//  Created by Zhou Hangqing on 7/2/12.
//  Copyright (c) 2012 UpPower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MapManager : NSObject
{
    
}

@property (nonatomic, readonly) CCMenu *towerSets;
@property (nonatomic, readonly) CCTMXTiledMap *map;
@property (nonatomic, readonly) CCSpriteBatchNode *batchNode;
//@property (nonatomic, readonly) NSArray *allMapTiles;
//@property (nonatomic, readonly) NSMutableDictionary *cachedControlRectForRange;

@property (nonatomic, readonly) NSMutableDictionary *cacheTilesCanRegisterForLayerName;

@property (nonatomic, readonly) NSMutableDictionary *cacheTilesForRange;
@property (nonatomic, readonly) NSMutableDictionary *tileCoordForObject; // Dicitionary stores which tile coord the object is currently in
@property (nonatomic, readonly) NSMutableDictionary *allTilesUnderControl; // Dicitionary stores all tile coord keys for objects. One tile coord key refers to one NSArray of BaseAttackNode object.


+ (MapManager *)sharedMapManager;

- (void)loadMapWithFileName:(NSString *)fileName;

- (CGPoint)tileCoordForPosition:(CGPoint)position;
- (CGPoint)roundTileCoordForPosition:(CGPoint)position;
- (CGPoint)positionForTilecoord:(CGPoint)coord;
- (CGPoint)positionForTileCoordCenter:(CGPoint)coord;
- (NSMutableArray *)getTheTileWay:(NSString *)pathName reset:(BOOL)needReset; // Retrieve all tile coord of path
- (CGPoint)getObjectSpawnTileCoord:(NSString *)pathName;
- (CGPoint)getObjectDestroyTileCoord:(NSString *)pathName;

- (NSArray *)layerTilesCanRegisterWithLayerName:(NSString *)layerName;
- (NSArray *)targetLayerTilesWithTargetTypes:(NSArray *)targetTypes;

- (NSArray *)controlRectWithRange:(float)range;

- (NSMutableArray *)getTilesWithPosition:(CGPoint)position range:(float)range safeRangeTilesEnable:(BOOL)enable;
- (NSArray *)objectsInTileCoord:(CGPoint)tileCoord;
- (NSArray *)objectsAtPosition:(CGPoint)position;
- (void)registerObject:(CCNode *)object fromOldTileCoord:(CGPoint)oldTileCoord toNewTileCoord:(CGPoint)newTileCoord;
- (void)registerObject:(CCNode *)object toTileCoord:(CGPoint)tileCoord;
- (void)unregisterObject:(CCNode *)object fromTileCoord:(CGPoint)tileCoord;

@end
