//
//  MoveObject.h
//  AStarPathFinder
//
//  Created by Zhou Hangqing on 12-8-6.
//  Copyright 2012年 UpPower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MoveObject : CCSprite {
    float _speed;
    NSMutableArray *_path;
    int _pathIndex;
    CGPoint _aimPos;
    BOOL _isMoving;
}

@property (nonatomic, assign) CGPoint destination;

- (void)moveToPosition:(CGPoint)position;

@end
