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
    
    _destination = destination;
    
    CGPoint srcCoord = [[MapManager sharedMapManager] tileCoordForPosition:self.position];
    AStarMapNode *srcNode = [[AStarPathFinder sharedPathFinder].map mapNodeWithCoord:srcCoord];
    CGPoint destCoord = [[MapManager sharedMapManager] tileCoordForPosition:destination];
    AStarMapNode *destNode = [[AStarPathFinder sharedPathFinder].map mapNodeWithCoord:destCoord];
    
    
    AStarPathFinder *apf = [AStarPathFinder sharedPathFinder];
    NSArray *findPath = [[apf findPathFromSrc:srcNode toDest:destNode] retain];
   
    [_path removeAllObjects];
    [_path addObjectsFromArray:findPath];
    
    //    _pathIndex = _path.count;
    _aimPos = [self nextPosition];
    self.rotation = [self cocosAngleFromPos:self.position toPos:_aimPos];
}

- (void)moveToPosition:(CGPoint)position
{
    [self setDestination:position];
}

- (CGPoint)nextPosition
{
    if (_path.count != 0) {
        _isMoving = YES;
        AStarMapNode *node = [_path lastObject];
        CGPoint nextCoord;
        if (node.state == kStatePassable) {
            nextCoord = node.coord;
            [_path removeLastObject];
        }
        CGPoint nextPos = [[MapManager sharedMapManager] positionForTileCoordCenter:nextCoord];
        return nextPos;
    } else {
        _isMoving = NO;
    }
    return CGPointZero;
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
    float stepDis = _speed * dt;
    CGPoint speedVector = CGPointZero;
    if (distance < stepDis) {
        self.position = _aimPos;
        CGPoint aimPos = [self nextPosition];
        if (!CGPointEqualToPoint(aimPos, CGPointZero)) {
            _aimPos = aimPos;
            self.rotation = [self cocosAngleFromPos:self.position toPos:_aimPos];
        }
        
    } else {
        if (fabs(vector.x) <= stepDis) {
            speedVector.y = vector.y / fabs(vector.y) * stepDis;
        } else if (fabs(vector.y) <= stepDis) {
            speedVector.x = vector.x / fabs(vector.x) * stepDis;
        } else {
            speedVector.x = vector.x / distance * stepDis;
            speedVector.y = vector.y / distance * stepDis;
        }
    }
    
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
    return cocosAngle;
}


@end
