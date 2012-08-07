//
//  GameScene.m
//  AStarPathFinder
//
//  Created by Zhou Hangqing on 12-8-6.
//  Copyright 2012年 UpPower. All rights reserved.
//

#import "GameScene.h"
#import "MapManager.h"

@implementation GameScene

+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    GameScene *gameScene = [GameScene node];
    [scene addChild:gameScene];
    return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.isTouchEnabled = YES;
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
        [[MapManager sharedMapManager] loadMapWithFileName:@"TDMap.tmx"];
        [self addChild:[MapManager sharedMapManager].map];
        [AStarPathFinder sharedPathFinder].map = [[AStarMap alloc] initWithTiledMap:[MapManager sharedMapManager].map layerName:@"background"];
        
        _tank = [MoveObject spriteWithFile:@"unit.png"];
        CGSize tankSz = _tank.contentSize;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) { // 3
            // Indicates game is running on iPad
            _tank.position = ccp(0+tankSz.width/2, 768-tankSz.height/2);
//            _tank.position = ccp(0, 768);
        } else {
            _tank.position = ccp(0+tankSz.width/2, 320-tankSz.height/2);
//            _tank.position = ccp(0, 320);
        }
        
        [[MapManager sharedMapManager].map addChild:_tank];
        
//        _tanks = [[NSMutableArray alloc] init];
//        for (int i = 0; i < 50; i++) {
//            CCSprite *tank = [MoveObject spriteWithFile:@"unit.png"];
//            CGSize tankSz = _tank.contentSize;
//            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) { // 3
//                // Indicates game is running on iPad
//                tank.position = ccp(0+tankSz.width/2, 768-tankSz.height/2);
//                //            _tank.position = ccp(0, 768);
//            } else {
//                tank.position = ccp(0+tankSz.width/2, 320-tankSz.height/2);
//                //            _tank.position = ccp(0, 320);
//            }
//            [[MapManager sharedMapManager].map addChild:tank];
//            [_tanks addObject:tank];
//        }
    }
    return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPos = [self convertTouchToNodeSpace:touch];
    
    int oldT = clock();
    _tank.destination = touchPos;
    
    
//    for (int i = 0; i < _tanks.count; i++) {
//        [[_tanks objectAtIndex:i] setDestination:touchPos]; 
//    }
    CCLOG(@"find cost:%d", clock() - oldT);

}

@end
