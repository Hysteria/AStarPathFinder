//
//  AStarPathFindManager.h
//  AStarPathFinder
//
//  Created by Zhou Hangqing on 12-8-7.
//  Copyright (c) 2012年 UpPower. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AStarSearcher;
@class GameMap;

@interface AStarPathFindManager : NSObject
{
    AStarSearcher *_AStarSearcher;
    GameMap *_AStarMap;
}
+ (AStarPathFindManager *)defaultManager;
- (NSArray *)findPathFromOrigin:(CGPoint)origin toDestination:(CGPoint)destination;

@end
