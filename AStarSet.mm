//
//  AStarSet.m
//  AStarPathFinder
//
//  Created by Zhou Hangqing on 12-8-7.
//  Copyright (c) 2012年 UpPower. All rights reserved.
//

#import "AStarSet.h"

@implementation AStarSet

@synthesize openList = _openList,
closeList = _closeList;

- (void)dealloc
{
    delete _openList;
    delete _closeList;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _openList = new std::set<AStarMapNode *, nodeCmpF>;
        _closeList = new std::set<AStarMapNode *, nodeCmpH>;
    }
    return self;
}

- (void)reset
{
    delete _openList;
    delete _closeList;
    _openList = new std::set<AStarMapNode *, nodeCmpF>;
    _closeList = new std::set<AStarMapNode *, nodeCmpH>;
}

- (NSString *)description
{
    NSString *openList = [NSString string];
    std::set<AStarMapNode *, nodeCmpF>::iterator it;
    for (it = _openList->begin(); it != _openList->end(); it++) {
        [openList stringByAppendingFormat:@"%@\n", *it];
    }
    NSString *closeList = [NSString string];
    std::set<AStarMapNode *, nodeCmpH>::iterator it2;
    for (it2 = _closeList->begin(); it2 != _closeList->end(); it2++){
        [closeList stringByAppendingFormat:@"%@\n", *it2];
    }
    return [NSString stringWithFormat:@"openListSize:%d,closeListSize:%d\nopen:%@close:%@", _openList->size(), _closeList->size(), openList, closeList];
}

@end
