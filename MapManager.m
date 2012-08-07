//
//  MapClass.m
//  PiratesTD.reconstruction
//
//  Created by Zhou Hangqing on 7/2/12.
//  Copyright (c) 2012 UpPower. All rights reserved.
//

#import "MapManager.h"



@interface MapManager (private)

- (NSArray *)setupTilesForRange:(float)range;

@end

@implementation MapManager

@synthesize 
towerSets = _towerSets,
map = _map,
batchNode = _batchNode,
//allMapTiles = _allMapTiles,
//cachedControlRectForRange = _cachedControlRectForRange,
cacheTilesCanRegisterForLayerName = _cacheTilesCanRegisterForLayerName,
cacheTilesForRange = _cacheTilesForRange,
tileCoordForObject = _tileCoordForObject,
allTilesUnderControl = _allTilesUnderControl;

static MapManager *sharedInstance = nil;

+ (MapManager *)sharedMapManager
{
    @synchronized([MapManager class])
    {
        if(!sharedInstance)  
            [[self alloc] init];
        return sharedInstance;
    }
    return nil;
}

+ (id)alloc
{
    @synchronized ([MapManager class])
    {
        NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of the Game Manager singleton");
        sharedInstance = [super alloc];
        return sharedInstance;
    }
    return nil;
}

- (void)dealloc
{
    [_cacheTilesCanRegisterForLayerName release];
    [_cacheTilesForRange release];
    [_tileCoordForObject release];
    [_allTilesUnderControl release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
//        _cachedControlRectForRange = [[NSMutableDictionary alloc] init];
        _cacheTilesCanRegisterForLayerName = [[NSMutableDictionary alloc] init];
        _cacheTilesForRange = [[NSMutableDictionary alloc] init];
        _tileCoordForObject = [[NSMutableDictionary alloc] init];
        _allTilesUnderControl = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Tiled map setup

- (void)loadMapWithFileName:(NSString *)fileName
{
    if (fileName != nil) {
        if (CC_CONTENT_SCALE_FACTOR() == 2)
        {
            fileName = [fileName stringByReplacingOccurrencesOfString:@".tmx" withString:@"-ipadhd.tmx"];
        }
        if (_map != nil)
            [_map release];
        _map = [[CCTMXTiledMap alloc] initWithTMXFile:fileName];
    } else {
        // Load tiled map with current game state
//        self.map = [[CCTMXTiledMap alloc] initWithTMXFile:[NSString stringWithFormat:@"map-%d-%02d-ipadhd.tmx",[GameStates getGameStates].diffculty,[GameStates getGameStates].diffcultyLevel]];
    }
    
    if (_map != nil) {
//        [self setupTiledMapAssociated];
        
        
    } else {
        CCLOG(@"Error init tiled map.");
    }
}
                      
- (void)unloadMap
{
    [_map removeAllChildrenWithCleanup:YES];
    [_batchNode release];
    [_map release];
}

//- (void)towerSet:(CCMenuItemSprite *)sender
//{
//    sender.isEnabled = NO;
//        
//
//    CGPoint tileCoord = [[MapManager sharedMapManager] tileCoordForPosition:sender.position];
//    BaseNode *tower = [[[MapManager sharedMapManager] objectsInTileCoord:tileCoord] objectAtIndex:0];
//
//    if ([tower isKindOfClass:NSClassFromString(@"Tower")]) {
//        [[InGameMenu sharedInGameMenu] updateUIWithOwner:tower];
//        [[InGameMenu sharedInGameMenu] show];
//        [[TowerBoard sharedTowerBoard] hide];
//    } else {
//        TowerBoard *towerBoard = [TowerBoard sharedTowerBoard];
////        towerBoard.position = sender.position;
//        towerBoard.background.position = sender.position;
//        [towerBoard show];
//        [[InGameMenu sharedInGameMenu] hide];
//    }
//    sender.isEnabled = YES;
//}
//
//- (void)setupTiledMapAssociated
//{
//    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameScene.plist"];
//    
//    // Init bath node to holds GameObject's sprite
//    if (_batchNode != nil) {
//        [_batchNode release];
//    }
//    _batchNode = [CCSpriteBatchNode batchNodeWithFile:@"gameScene.pvr.ccz"];
//    [_map addChild:_batchNode z:kZOrderBatchNode];
//
//    // Init tower sets
//    CCTMXObjectGroup *towerSetPositions = [[MapManager sharedMapManager].map objectGroupNamed:@"TowerPositions"];
//    NSMutableArray *locations = [towerSetPositions objects];
//    
//    _towerSets = [CCMenu menuWithArray:nil];
//    _towerSets.anchorPoint = ccp(0, 0);
//    _towerSets.position = ccp(0, 0);
//        
//    for (NSDictionary *loc in [[locations copy] autorelease]) {
//        CCMenuItemSprite *item = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"tower-set-2.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"tower-set-2.png"] target:self selector:@selector(towerSet:)]; 
//        int x = [[loc objectForKey:@"x"] intValue];
//        int y = [[loc objectForKey:@"y"] intValue];
//        if (CC_CONTENT_SCALE_FACTOR() == 2) {
//            x = 0.5 * x;
//            y = 0.5 * y;
//        }
//        item.position = ccp(x, y);
//        item.tag = [[MapManager sharedMapManager] tileCoordForPosition:item.position].x;
//        [_towerSets addChild:item];
//    }
//    [_map addChild:_towerSets z:kZOrderBatchNode-5];
//}

#pragma mark - 

- (CGPoint)tileCoordForPosition:(CGPoint)position
{
    CCTMXTiledMap *map = _map;
    CGSize relativeSize;
    if (CC_CONTENT_SCALE_FACTOR() == 2) {
        relativeSize = CGSizeMake(map.tileSize.width*0.5, map.tileSize.height*0.5);
    } else {
        relativeSize = map.tileSize;
    }
	int x = position.x / relativeSize.width;
	int y = ((map.mapSize.height * relativeSize.height) - position.y) / relativeSize.height;
	return ccp(x, y);
}

- (CGPoint)roundTileCoordForPosition:(CGPoint)position
{
    CCTMXTiledMap *map = _map;
    CGSize relativeSize;
    if (CC_CONTENT_SCALE_FACTOR() == 2) {
        relativeSize = CGSizeMake(map.tileSize.width*0.5, map.tileSize.height*0.5);
    } else {
        relativeSize = map.tileSize;
    }
	int x = lroundf(position.x / relativeSize.width) ;
	int y = lroundf(((map.mapSize.height * relativeSize.height) - position.y) / relativeSize.height);
	return ccp(x, y);
}

- (CGPoint)positionForTilecoord:(CGPoint)coord
{
    CCTMXTiledMap *map = _map;
    CGSize relativeSize;
    if (CC_CONTENT_SCALE_FACTOR() == 2) {
        relativeSize = CGSizeMake(map.tileSize.width*0.5, map.tileSize.height*0.5);
    } else {
        relativeSize = map.tileSize;
    }
	CGFloat x = coord.x * relativeSize.width;
	CGFloat y = map.mapSize.height * relativeSize.height - coord.y * relativeSize.height ;
	return ccp(x, y);
}

- (CGPoint)positionForTileCoordCenter:(CGPoint)coord
{
    CCTMXTiledMap *map = _map;
    CGSize relativeSize;
    if (CC_CONTENT_SCALE_FACTOR() == 2) {
        relativeSize = CGSizeMake(map.tileSize.width*0.5, map.tileSize.height*0.5);
    } else {
        relativeSize = map.tileSize;
    }
	CGFloat x = (coord.x + 0.5) * relativeSize.width;
	CGFloat y = map.mapSize.height * relativeSize.height - (coord.y + 0.5) * relativeSize.height ;
	return ccp(x, y);
}

//+ (CGPoint)getTheSoldierBurnPosition:(NSString *)pathName withTiledMap:(CCTMXTiledMap *)map
- (CGPoint)getObjectSpawnTileCoord:(NSString *)pathName
{
    CCTMXTiledMap *map = _map;
	CGPoint spawnTileCoord = {0,0};
//    CCTMXObjectGroup *group = [MapClass getObjectGroupWithName:@"Points"];
    CCTMXObjectGroup *group = [map objectGroupNamed:@"Points"];
	NSMutableDictionary *spawnPoints = [group objectNamed:[pathName stringByAppendingFormat:@"SP"]];
    NSAssert(spawnPoints.count > 0, @"SpawnPoint object missing");
    int x = [[spawnPoints valueForKey:@"x"] intValue];
    int y = [[spawnPoints valueForKey:@"y"] intValue];
    if (CC_CONTENT_SCALE_FACTOR() == 2) {
        x = 0.5 * x;
        y = 0.5 * y;
    }
    spawnTileCoord = [[MapManager sharedMapManager]tileCoordForPosition:CGPointMake(x, y)];
	return spawnTileCoord;
}

- (CGPoint)getObjectDestroyTileCoord:(NSString *)pathName
{
    CCTMXTiledMap *map = _map;
	CGPoint destroyTileCoord = {0,0};
//	NSMutableDictionary *spawnPoints = [[MapClass getObjectGroupWithName:nil] objectNamed:[pathName stringByAppendingFormat:@"EP"]];
    CCTMXObjectGroup *group = [map objectGroupNamed:@"Points"];
    NSMutableDictionary *spawnPoints = [group objectNamed:[pathName stringByAppendingFormat:@"EP"]];
    NSAssert(spawnPoints.count > 0, @"DestinationNode object missing");
    int x = [[spawnPoints valueForKey:@"x"] intValue];
    int y = [[spawnPoints valueForKey:@"y"] intValue];
    if (CC_CONTENT_SCALE_FACTOR() == 2) {
        x = 0.5 * x;
        y = 0.5 * y;
    }
    destroyTileCoord = [[MapManager sharedMapManager] tileCoordForPosition:CGPointMake(x, y)];
	return destroyTileCoord;
}

- (NSMutableArray *)getTheTileWay:(NSString *)pathName reset:(BOOL)needReSet 
{
	static NSMutableDictionary *tileWays = nil;
    NSMutableArray *pathWay = [tileWays objectForKey:pathName];
    if (pathWay) {
        if (!needReSet) {
            return pathWay;
        }
    }
    if (!tileWays) {
        tileWays = [[NSMutableDictionary alloc] init];
    }
	
    if (!pathWay || needReSet) {
        pathWay = [NSMutableArray array];
        
        CCTMXTiledMap *map = _map;
        CCTMXLayer *metaLayer = [map layerNamed:pathName];
        if (!metaLayer) {
            return nil;
        }
        // Get object spawn tile coord on path
        NSMutableArray *browsedTile = [NSMutableArray array];
        CGPoint spawnCoord = [[MapManager sharedMapManager] getObjectSpawnTileCoord:pathName];
//        NSString *wayString = [NSString stringWithFormat:FormatString,BurnPoint.x ,BurnPoint.y];
        NSString *wayString = NSStringFromCGPoint(spawnCoord);
        CGPoint currentCoord = spawnCoord;
        [pathWay addObject:wayString];
        [browsedTile addObject:wayString];
        
        // Get all path tile coord
        while (currentCoord.x  <= [map mapSize].width - 1 && currentCoord.x  >= 0 && currentCoord.y <= [map mapSize].height - 1 && currentCoord.y >= 0) {
            if (CGPointEqualToPoint(currentCoord, [[MapManager sharedMapManager] getObjectDestroyTileCoord:pathName])) {
                break;
            }
            CGPoint nextCoord1 = CGPointMake(currentCoord.x + 1, currentCoord.y);
            if (nextCoord1.x < [map mapSize].width ) {
                NSInteger tiledGID = [metaLayer tileGIDAt:nextCoord1];
                if (tiledGID) {
//                    NSString *wayString = [NSString stringWithFormat:FormatString,nextCoord1.x,nextCoord1.y];
                    NSString *wayString = NSStringFromCGPoint(nextCoord1);
                    if (![browsedTile containsObject:wayString]) {
                        [pathWay addObject:wayString];
                        [browsedTile addObject:wayString];
                        currentCoord = nextCoord1;
                        continue;
                    }
                }
            }
            
            CGPoint nextCoord2 = CGPointMake(currentCoord.x + 1, currentCoord.y + 1);
            if (nextCoord2.x < [map mapSize].width && nextCoord2.y < [map mapSize].height) {
                NSInteger tiledGID = [metaLayer tileGIDAt:nextCoord2];
                if (tiledGID) {
//                    NSString *wayString = [NSString stringWithFormat:FormatString,nextCoord2.x,nextCoord2.y];
                    NSString *wayString = NSStringFromCGPoint(nextCoord2);
                    if (![browsedTile containsObject:wayString]) {
                        [pathWay addObject:wayString];
                        [browsedTile addObject:wayString];
                        currentCoord = nextCoord2;
                        continue;
                    }
                }
            }
            
            CGPoint nextCoord3 = CGPointMake(currentCoord.x, currentCoord.y + 1);
            if (nextCoord3.y < [map mapSize].height) {
                NSInteger tiledGID = [metaLayer tileGIDAt:nextCoord3];
                if (tiledGID) {
//                    NSString *wayString = [NSString stringWithFormat:FormatString,nextCoord3.x,nextCoord3.y];
                    NSString *wayString = NSStringFromCGPoint(nextCoord3);
                    if (![browsedTile containsObject:wayString]) {
                        [pathWay addObject:wayString];
                        [browsedTile addObject:wayString];
                        currentCoord = nextCoord3;
                        continue;
                    }
                }
            }
            
            CGPoint nextCoord4 = CGPointMake(currentCoord.x - 1, currentCoord.y + 1);
            if (nextCoord4.x >= 0 && nextCoord4.y < [map mapSize].height) {
                NSInteger tiledGID = [metaLayer tileGIDAt:nextCoord4];
                if (tiledGID) {
//                    NSString *wayString = [NSString stringWithFormat:FormatString,nextCoord4.x,nextCoord4.y];
                    NSString *wayString = NSStringFromCGPoint(nextCoord4);
                    if (![browsedTile containsObject:wayString]) {
                        [pathWay addObject:wayString];
                        [browsedTile addObject:wayString];
                        currentCoord = nextCoord4;
                        continue;
                    }
                }
            }
            
            CGPoint nextCoord5 = CGPointMake(currentCoord.x - 1, currentCoord.y);
            if (nextCoord5.x >=0) {
                NSInteger tiledGID = [metaLayer tileGIDAt:nextCoord5];
                if (tiledGID) {
//                    NSString *wayString = [NSString stringWithFormat:FormatString,nextCoord5.x,nextCoord5.y];
                    NSString *wayString = NSStringFromCGPoint(nextCoord5);
                    if (![browsedTile containsObject:wayString]) {
                        [pathWay addObject:wayString];
                        [browsedTile addObject:wayString];
                        currentCoord = nextCoord5;
                        continue;
                    }
                }
            }
            CGPoint nextCoord6 = CGPointMake(currentCoord.x - 1, currentCoord.y - 1);
            if (nextCoord6.x >=0 && nextCoord6.y >= 0) {
                NSInteger tiledGID = [metaLayer tileGIDAt:nextCoord6];
                if (tiledGID) {
//                    NSString *wayString = [NSString stringWithFormat:FormatString,nextCoord6.x,nextCoord6.y];
                    NSString *wayString = NSStringFromCGPoint(nextCoord6);
                    if (![browsedTile containsObject:wayString]) {
                        [pathWay addObject:wayString];
                        [browsedTile addObject:wayString];
                        currentCoord = nextCoord6;
                        continue;
                    }
                }
            }
            CGPoint nextCoord7 = CGPointMake(currentCoord.x , currentCoord.y - 1);
            if (nextCoord7.y >= 0) {
                NSInteger tiledGID = [metaLayer tileGIDAt:nextCoord7];
                if (tiledGID) {
//                    NSString *wayString = [NSString stringWithFormat:FormatString,nextCoord7.x,nextCoord7.y];
                    NSString *wayString = NSStringFromCGPoint(nextCoord7);
                    if (![browsedTile containsObject:wayString]) {
                        [pathWay addObject:wayString];
                        [browsedTile addObject:wayString];
                        currentCoord = nextCoord7;
                        continue;
                    }
                }
            }
            
            CGPoint nextCoord8 = CGPointMake(currentCoord.x + 1, currentCoord.y - 1);
            if (nextCoord8.x < [map mapSize].width && nextCoord8.y >= 0) {
                NSInteger tiledGID = [metaLayer tileGIDAt:nextCoord8];
                if (tiledGID) {
//                    NSString *wayString = [NSString stringWithFormat:FormatString,nextCoord8.x,nextCoord8.y];
                    NSString *wayString = NSStringFromCGPoint(nextCoord8);
                    if (![browsedTile containsObject:wayString]) {
                        [pathWay addObject:wayString];
                        [browsedTile addObject:wayString];
                        currentCoord = nextCoord8;
                        continue;
                    }
                }
            }
        }
        
        [tileWays setObject:pathWay forKey:pathName];
//        NSLog(@"pathWay.retainCount:%d", pathWay.retainCount);
    }
    
	return pathWay;
}

- (NSArray *)layerTilesCanRegisterWithLayerName:(NSString *)layerName
{
    NSMutableArray *layerTiles = nil;
    layerTiles = [_cacheTilesCanRegisterForLayerName objectForKey:layerName];
    if (layerTiles == nil) {
        layerTiles = [NSMutableArray array];
        CCTMXLayer *layer = [_map layerNamed:layerName];
        for (int i = 0; i < _map.mapSize.width; i++) {
            for (int j = 0; j < _map.mapSize.height; j++) {
                CGPoint tileCoord = ccp(i, j);
                NSUInteger tileGID = [layer tileGIDAt:tileCoord];
                if (tileGID) {
//                    [layerTiles addObject:NSStringFromCGPoint(tileCoord)];
                    [layerTiles addObject:[NSValue valueWithCGPoint:tileCoord]];
                }
            }
        }
        [_cacheTilesCanRegisterForLayerName setObject:layerTiles forKey:layerName];
    }
    return [[layerTiles copy] autorelease];
}


//- (NSArray *)targetLayerTilesWithTargetTypes:(NSArray *)targetTypes
//{
//    NSArray *layerTiles = nil;
//    if ([targetTypes containsObject:[NSNumber numberWithInt:kTowerType]]) {
//        layerTiles = [[MapManager sharedMapManager] layerTilesCanRegisterWithLayerName:@"island"];
//    } else if ([targetTypes containsObject:[NSNumber numberWithInt:kBoatType]]){
//        layerTiles = [[MapManager sharedMapManager] layerTilesCanRegisterWithLayerName:@"sea"];
//    }
//    return layerTiles;
//}

#pragma mark - Tiles manage

//- (NSArray *)controlRectWithRange:(float)range
//{
//    NSMutableArray *controlRect = nil;
//    controlRect = [self.cachedControlRectForRange objectForKey:[NSNumber numberWithFloat:range]];
//    if (controlRect.count == 0) {
//        int rangeTileCount = 0;
//        if (CC_CONTENT_SCALE_FACTOR() == 2) {
//            rangeTileCount = ceilf(range / ([[MapManager sharedMapManager].map tileSize].width * 0.5));
//        }
//        else {
//            rangeTileCount = ceilf(range / [[MapManager sharedMapManager].map tileSize].width);
//        }
//        NSMutableArray *controlRectM = [NSMutableArray array];
//        CGPoint controlRectOrigin = ccp(-rangeTileCount, -rangeTileCount);
//        CGPoint controlRectSize = ccp(rangeTileCount-1, rangeTileCount-1);
//        [controlRectM addObject:NSStringFromCGPoint(controlRectOrigin)];
//        [controlRectM addObject:NSStringFromCGPoint(controlRectSize)];
//        controlRect = [NSArray arrayWithArray:controlRectM];
//    }
//    
//    [self.cachedControlRectForRange setObject:controlRect forKey:[NSNumber numberWithFloat:range]];
//    
//    return controlRect;
//}


- (NSArray *)setupTilesForRange:(float)range safeRangeTilesEnable:(BOOL)enable
{
    NSArray *cachedTiles = nil;
    cachedTiles = [self.cacheTilesForRange objectForKey:[NSNumber numberWithFloat:range]];
    if (!cachedTiles)
    {
        int rangeTileCount = 0;
        if (CC_CONTENT_SCALE_FACTOR() == 2)
        {
            rangeTileCount = ceilf(range / ([[MapManager sharedMapManager].map tileSize].width * 0.5));
        }
        else 
        {
            rangeTileCount = ceilf(range / [[MapManager sharedMapManager].map tileSize].width);
        }
        
        if (enable) {
            rangeTileCount += 1;
        }
        
        NSMutableArray *rangeTilesM = [NSMutableArray array];
        
        int tileCoordStartX = -rangeTileCount;
        int tileCoordStartY = -rangeTileCount;
        int tileCoordEndX = rangeTileCount - 1;
        int tileCoordEndY = rangeTileCount - 1;
        for (int i = tileCoordStartX; i <= tileCoordEndX; i++)
        {
            for (int j = tileCoordStartY; j <= tileCoordEndY; j++)
            {
//                [rangeTilesM addObject:NSStringFromCGPoint(ccp(i, j))];
                [rangeTilesM addObject:[NSValue valueWithCGPoint:ccp(i, j)]];
            }
        }
        cachedTiles = [NSArray arrayWithArray:rangeTilesM];
//        NSMutableArray *rangeTiles2D = [NSMutableArray array];
//    
//        int tileCoordStartX = -rangeTileCount;
//        int tileCoordStartY = -rangeTileCount;
//        int tileCoordEndX = rangeTileCount - 1;
//        int tileCoordEndY = rangeTileCount - 1;
//        for (int i = tileCoordStartX; i <= tileCoordEndX; i++)
//        {
//            NSMutableArray *rangeTiles1D = [NSMutableArray array];
//            for (int j = tileCoordStartY; j <= tileCoordEndY; j++)
//            {
//                [rangeTiles1D addObject:NSStringFromCGPoint(ccp(j, i))];
//            }
//            [rangeTiles2D addObject:rangeTiles1D];
//        }
//        cachedTiles = [NSArray arrayWithArray:rangeTiles2D];
    }
    
    [self.cacheTilesForRange setObject:cachedTiles forKey:[NSNumber numberWithFloat:range]];
    
    return cachedTiles;
}

- (NSMutableArray *)getTilesWithPosition:(CGPoint)position range:(float)range safeRangeTilesEnable:(BOOL)enable
{
    NSArray *cacheTiles = [self setupTilesForRange:range safeRangeTilesEnable:enable];
    CGPoint tileCoordOffset = [[MapManager sharedMapManager] tileCoordForPosition:position];
    NSMutableArray *rangeTiles2D = [NSMutableArray array];
    for (int i = 0; i < cacheTiles.count; i++)
    {
//        CGPoint cacheTileCoord = CGPointFromString([cacheTiles objectAtIndex:i]);
        CGPoint cacheTileCoord = [[cacheTiles objectAtIndex:i] CGPointValue];
        CGPoint actualTileCoord = ccpAdd(cacheTileCoord, tileCoordOffset);
//        [rangeTiles2D addObject:NSStringFromCGPoint(actualTileCoord)];
        [rangeTiles2D addObject:[NSValue valueWithCGPoint:actualTileCoord]];
    }
//    for (int i = 0; i < cacheTiles.count; i++)
//    {
//        NSArray *rangeTiles1D = [cacheTiles objectAtIndex:i];
//        NSMutableArray *tempArray = [NSMutableArray array];
//        for (int j = 0; j < rangeTiles1D.count; j++) {
//            CGPoint cacheTileCoord = CGPointFromString([rangeTiles1D objectAtIndex:j]);
//            CGPoint actualTileCoord = ccpAdd(cacheTileCoord, tileCoordOffset);
//            [tempArray addObject:NSStringFromCGPoint(actualTileCoord)];        
//        }
//        [rangeTiles2D addObject:tempArray];
//    }

    return rangeTiles2D;
}


- (NSArray *)objectsInTileCoord:(CGPoint)tileCoord
{
//    NSString *tileCoordString = NSStringFromCGPoint(tileCoord);
//    NSArray *objects = [_allTilesUnderControl objectForKey:tileCoordString];
    NSValue *tileCoordValue = [NSValue valueWithCGPoint:tileCoord];
    NSArray *objects = [_allTilesUnderControl objectForKey:tileCoordValue];
    return objects;
}

- (NSArray *)objectsAtPosition:(CGPoint)position
{
    CGPoint tileCoord = [self tileCoordForPosition:position]; 
    NSArray *objects = [self objectsInTileCoord:tileCoord];
    return objects;
}

- (void)registerObject:(CCNode *)object fromOldTileCoord:(CGPoint)oldTileCoord toNewTileCoord:(CGPoint)newTileCoord
{
    [self unregisterObject:object fromTileCoord:oldTileCoord];
    [self registerObject:object toTileCoord:newTileCoord];    
}

- (void)registerObject:(CCNode *)object toTileCoord:(CGPoint)tileCoord
{
//    NSString *newTileCoordString = NSStringFromCGPoint(tileCoord);
//    // Register object for new tile coord
//    NSMutableArray *objects = [_allTilesUnderControl objectForKey:newTileCoordString];
    NSValue *tileCoordValue = [NSValue valueWithCGPoint:tileCoord];
    NSMutableArray *objects = [_allTilesUnderControl objectForKey:tileCoordValue];
    
    if (objects == nil) {
        objects = [NSMutableArray array];
    }
    if (![objects containsObject:object]) {
        [objects addObject:object];
    }
//    [_allTilesUnderControl setObject:objects forKey:newTileCoordString];
    [_allTilesUnderControl setObject:objects forKey:tileCoordValue];
}

- (void)unregisterObject:(CCNode *)object fromTileCoord:(CGPoint)tileCoord
{
//    NSString *oldTileCoordString = NSStringFromCGPoint(tileCoord);
    // Unregister object for old tile coord
//    NSMutableArray *objects = [_allTilesUnderControl objectForKey:oldTileCoordString];
    NSValue *tileCoordValue = [NSValue valueWithCGPoint:tileCoord];
    NSMutableArray *objects = [_allTilesUnderControl objectForKey:tileCoordValue];
    if (objects != nil) {
        [objects removeObject:object];
    }
    if (objects.count == 0) {
//        [_allTilesUnderControl removeObjectForKey:oldTileCoordString];
        [_allTilesUnderControl removeObjectForKey:tileCoordValue];
    }

}

@end
