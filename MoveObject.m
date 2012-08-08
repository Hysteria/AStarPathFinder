//
//  MoveObject.m
//  AStarPathFinder
//
//  Created by Zhou Hangqing on 12-8-6.
//  Copyright 2012年 UpPower. All rights reserved.
//

#import "MoveObject.h"
#import "MapManager.h"
#import "AStarPathFinder.h"

@implementation MoveObject

@synthesize destination = _destination;

- (void)dealloc
{
    [_path release];
    [super dealloc];
}

- (id)initWithFile:(NSString *)filename
{
    self = [super initWithFile:filename];
    if (self) {
        _speed = 200;
        _path = [[NSMutableArray alloc] init];
        [self scheduleUpdate];
    }
    return self;
}


- (void)setDestination:(CGPoint)destination
{
    if (CGPointEqualToPoint(_destination, destination)) {
        return;
    }
    
    
    
//    CGPoint srcCoord = [[MapManager sharedMapManager] tileCoordForPosition:self.position];
//    CGPoint srcFixed = [[MapManager sharedMapManager] positionForTileCoordCenter:srcCoord];
//    AStarMapNode *srcNode = [[AStarPathFinder sharedPathFinder].map mapNodeWithCoord:srcCoord];
    CGPoint destCoord = [[MapManager sharedMapManager] tileCoordForPosition:destination];
//    AStarMapNode *destNode = [[AStarPathFinder sharedPathFinder].map mapNodeWithCoord:destCoord];
    CGPoint destFixed = [[MapManager sharedMapManager] positionForTileCoordCenter:destCoord];
    _destination = destFixed;    
    
    AStarPathFinder *apf = [AStarPathFinder sharedPathFinder];
//    NSArray *findPath = [[apf findPathFromSrc:srcNode toDest:destNode] retain];
    NSArray *findPath = [[apf findPathFromOrigin:self.position toDestination:destination] retain];
    
    [_path removeAllObjects];
    [_path addObjectsFromArray:findPath];
    
    [self moveToNextPosition];
    self.rotation = [self cocosAngleFromPos:self.position toPos:_aimPos];
}

- (void)moveToPosition:(CGPoint)position
{
    [self setDestination:position];
}

- (void)moveToNextPosition
{
    if (_path.count != 0) {
        _isMoving = YES;
        AStarMapNode *node = [_path lastObject];
        CGPoint nextCoord;
        if (node.state == kStatePassable) {
            nextCoord = node.coord;
            [_path removeLastObject];
            CGPoint nextPos = [[MapManager sharedMapManager] positionForTileCoordCenter:nextCoord];
            _aimPos = nextPos;
        }
        
    } else {
        _isMoving = NO;
    }
}

- (void)update:(ccTime)dt
{
    if (!_isMoving) {
        return;
    }
    CGPoint vector = ccpSub(_aimPos, self.position);
//    CGFloat radian = ccpToAngle(vector);
//    CGFloat cocosAngle = CC_RADIANS_TO_DEGREES(-1 * radian);
    float distance = ccpDistance(_aimPos, self.position);
//    distance = floor(distance);
//    distance = ceilf(distance);
    float stepDis = _speed * dt;
    CGPoint speedVector = CGPointZero;
    if (distance <= stepDis) {
        self.position = _aimPos;
        [self moveToNextPosition];
        if (!CGPointEqualToPoint(self.position, _destination)) {
            self.rotation = [self cocosAngleFromPos:self.position toPos:_aimPos];
        }
        
        return; 
    }  
    speedVector.x = vector.x / distance * stepDis;
    speedVector.y = vector.y / distance * stepDis;

//    self.rotation = cocosAngle;
//    self.rotation = [self cocosAngleFromPos:self.position toPos:_aimPos];
    CGPoint tempPos = ccpAdd(self.position, speedVector);
    self.position = tempPos;
    
}

- (void)move:(ccTime)dt
{
    
    
}

- (float)cocosAngleFromPos:(CGPoint)from toPos:(CGPoint)to
{
    CGPoint vector = ccpSub(to, from);
    CGFloat radian = ccpToAngle(vector);
    CGFloat cocosAngle = CC_RADIANS_TO_DEGREES(-1 * radian);
    
//    if (fabsf(cocosAngle) != 180 && fabsf(cocosAngle) != 135 && fabsf(cocosAngle) != 90 && fabsf(cocosAngle) != 45 && fabsf(cocosAngle) != 0) {
//        NSLog(@"anlge:%.3f", cocosAngle);
//    }
    return cocosAngle;
}


@end
