
#ifndef GameMap_h
#define GameMap_h

#include "cocos2d.h"

using namespace cocos2d;

class   GameObject;
class   AstarInfo;

class MapNode
{
public:
    MapNode()
    :xIndex_(0), yIndex_(0), state_(0), obj_(NULL)
    ,viewFieldMask_(0xffff){}
    
    int         xIndex_;
    int         yIndex_;
    
    int         nid_;
    
    int         state_;
    GameObject  *obj_;
    int         viewFieldMask_;
    
    //for A* search
    AstarInfo*  info_;
}; 

class AstarInfo
{
public:
    AstarInfo()
    :g_(0), h_(0), f_(0), parent_(NULL) {}
    
    float       g_;
    float       h_;
    float       f_;
    MapNode     *parent_;
};

class GameMap 
{
public:
    static  GameMap*    sharedMap();
    
    void        loadMapInfo(CCTMXTiledMap* tiledMap, std::string layeName);
	void		resetMapInfo();
    CCPoint     convertToCCNodeSpace(MapNode& node);
    void        convertToMapCoordinate(const CCPoint& pos, int& xIndex, int& yIndex);
    
    MapNode*    getNodeAt(int xIndex, int yIndex);

protected:

    friend  class   AStarSearcher;
    
    MapNode     **mapInfo_;
    AstarInfo   *astarInfo_;
    
    CCSize      tileSize_;
    CCSize      mapSize_;
    
    int         nodeSum_;
    int         xIndexMax_;
    int         yIndexMax_;
    
private:
    GameMap();
    ~GameMap();
    static      GameMap* s_instance_;
};

#endif
