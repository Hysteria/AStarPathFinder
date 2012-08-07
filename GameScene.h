//
//  GameScene.h
//  AStarPathFinder
//
//  Created by Zhou Hangqing on 12-8-6.
//  Copyright 2012年 UpPower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AStarPathFinder.h"
#import "MoveObject.h"

@interface GameScene : CCLayer {
    MoveObject *_tank;
    NSMutableArray *_tanks;
}

+ (CCScene *)scene;

@end
