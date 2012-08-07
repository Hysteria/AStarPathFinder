//
//  AStarSet.h
//  AStarPathFinder
//
//  Created by Zhou Hangqing on 12-8-7.
//  Copyright (c) 2012年 UpPower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <set>
#import "AStarMap.h"

@class AStarMapNode;

struct nodeCmpF
{
    bool operator()(const AStarMapNode* node1, const AStarMapNode* node2) const
    {
        float f1 = node1.AStarInfo.f;
        float f2 = node2.AStarInfo.f;
        bool b = f1 < f2;
        return b;
    }
};
struct nodeCmpH
{
	bool operator()(const AStarMapNode* node1, const AStarMapNode* node2) const
	{
        float h1 = node1.AStarInfo.h;
        float h2 = node2.AStarInfo.h;
        bool b = h1 < h2;
		return b;
	}
};

@interface AStarSet : NSObject
{
    
}
@property std::set<AStarMapNode *, nodeCmpF> *openList;
@property std::set<AStarMapNode *, nodeCmpH> *closeList;

- (void)reset;

@end
