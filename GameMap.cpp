
#include "GameMap.h"
#include "GameObject.h"

GameMap* GameMap::s_instance_ = NULL;

GameMap* GameMap::sharedMap()
{
    if (!s_instance_) {
        s_instance_ = new GameMap;
    }
    return s_instance_;
}

GameMap::GameMap()
    :mapInfo_(NULL)
    ,astarInfo_(NULL)
    ,tileSize_(CCSize(0, 0))
    ,nodeSum_(0)
    ,xIndexMax_(0)
    ,yIndexMax_(0)
{
}

GameMap::~GameMap()
{
    if (mapInfo_) {
        for (int i = 0; i<xIndexMax_; ++i) {
            delete[] mapInfo_[i];
        }
        delete[] mapInfo_;
    }
}

void GameMap::loadMapInfo(CCTMXTiledMap* tiledMap, std::string layeName)
{
    if (mapInfo_) {
        for (int i = 0; i<xIndexMax_; ++i) {
            delete[] mapInfo_[i];
        }
        delete[] mapInfo_;
    }
    
    mapSize_ = tiledMap->getMapSize();
    tileSize_ = tiledMap->getTileSize();
    xIndexMax_ = mapSize_.width;
    yIndexMax_ = mapSize_.height;
    nodeSum_ = mapSize_.width * mapSize_.height;
    
    mapInfo_ = new MapNode*[xIndexMax_];
    for (int i = 0; i < xIndexMax_; ++i) {
        mapInfo_[i] = new MapNode[yIndexMax_];
    }
    
    astarInfo_ = new AstarInfo[nodeSum_];
    int nid = 0;
    memset(astarInfo_, 0, sizeof(AstarInfo) * nodeSum_);

    CCTMXLayer* mapLayer = tiledMap->layerNamed(layeName.c_str());
    for (int i = 0; i < xIndexMax_; ++i) {
        for (int j = 0; j < yIndexMax_; ++j, ++nid) {
            int  gid = mapLayer->tileGIDAt(CCPoint(i, j));
            if (gid) {
                MapNode *node = &mapInfo_[i][j];
                node->xIndex_ = i;
                node->yIndex_ = j;
                node->nid_ = nid;
                node->info_ = &astarInfo_[nid];
                
                CCDictionary  *dic = tiledMap->propertiesForGID(gid);
                if (dic) {  
                    node->state_ = dic->valueForKey("state")->intValue();
                }
            }
        }
    }
}

void GameMap::resetMapInfo()
{
    assert(astarInfo_);
    memset(astarInfo_, 0, sizeof(AstarInfo) * nodeSum_);
}
CCPoint GameMap::convertToCCNodeSpace(MapNode& node)
{
    float x = (node.xIndex_ + 0.5) * tileSize_.width;
    float y = (yIndexMax_ -  node.yIndex_ - 0.5) * tileSize_.height;
    return CCPoint(x, y);
}

void GameMap::convertToMapCoordinate(const CCPoint& pos, int& xIndex, int& yIndex)
{
    int x = pos.x / tileSize_.width;
    int y = yIndexMax_ -  pos.y / tileSize_.height;
    if (x < xIndexMax_ && y < yIndexMax_) {
        xIndex = x;
        yIndex = y;
    }
    else {
        xIndex = -1;
        yIndex = -1;
    }
}
MapNode* GameMap::getNodeAt(int xIndex, int yIndex)
{
    assert(mapInfo_);
    if (0 <= xIndex && xIndex < xIndexMax_ && 0 <=yIndex && yIndex < yIndexMax_) {
        return &mapInfo_[xIndex][yIndex];
    }
    return NULL;
}
