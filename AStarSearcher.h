
#ifndef AStarSearcher_h
#define AStarSearcher_h

#include "MovableObject.h"
#include "GameMap.h"

#include <set>
#include <queue>

class MovableObject;

struct nodeCmpF
{
    bool operator()(const MapNode* node1, const MapNode* node2) const
    {
        return node1->info_->f_ < node2->info_->f_;
    }
};
struct nodeCmpH
{
	bool operator()(const MapNode* node1, const MapNode* node2) const
	{
		return node1->info_->h_ < node2->info_->h_;
	}
};

class AStarSearcher
{
public:
    AStarSearcher();
    ~AStarSearcher();
    
	static AStarSearcher* sharedSearcher();

    void    setMap(GameMap* map) { map_ = map; };
    bool    findPath(MovableObject* obj, MapNode* desNode);
    bool    findPath(MapNode* nodeSrc, MapNode* nodeDes, std::vector<MapNode*>* path_out);
    float   nodeDistance(MapNode *node1, MapNode *node2);

protected:

    GameMap *map_;
	static AStarSearcher *s_instance_;
    
	std::set<MapNode*, nodeCmpF>     *openSet_;
	std::set<MapNode*, nodeCmpH>     *closeSet_;
};

#endif
