
#include "AStarSearcher.h"
#include "MovableObject.h"

AStarSearcher* AStarSearcher::s_instance_ = NULL;

AStarSearcher::AStarSearcher()
{
    openSet_ = new std::set<MapNode*, nodeCmpF>;
    closeSet_ = new std::set<MapNode*, nodeCmpH>;
}

AStarSearcher::~AStarSearcher()
{
    delete openSet_;
    delete closeSet_;
}
AStarSearcher* AStarSearcher::sharedSearcher()
{
	if (!s_instance_)
	{
		s_instance_ = new AStarSearcher;
	}
	return s_instance_;
}
float AStarSearcher::nodeDistance(MapNode *node1, MapNode *node2)
{
    float dx = node2->xIndex_ - node1->xIndex_;
    float dy = node2->yIndex_ - node1->yIndex_;
    
    return sqrt(dx*dx + dy*dy);
}

bool AStarSearcher::findPath(MovableObject* obj, MapNode* desNode)
{
    int x,y;
    map_->convertToMapCoordinate(obj->getPosition(), x, y);
    MapNode *nodeSrc = map_->getNodeAt(x, y);
    return findPath(nodeSrc, desNode, obj->path_);
}

bool AStarSearcher::findPath(MapNode* nodeSrc, MapNode* nodeDes, std::vector<MapNode*>* path_out)
{
    assert(path_out);
    
    bool    isFind = false;
    nodeSrc->info_->g_ = 0;
    nodeSrc->info_->h_ = nodeDistance(nodeSrc, nodeDes);
    nodeSrc->info_->f_ = nodeSrc->info_->g_ + nodeSrc->info_->h_;
    openSet_->insert(nodeSrc);
    
    MapNode		*node = NULL;
    MapNode*    nodes[8];
    
    while (!openSet_->empty()) {
        int oldt = clock();
        
        node = *openSet_->begin();
        openSet_->erase(node);
        closeSet_->insert(node);
        
        if (node == nodeDes) {
            isFind = true;
            break;
        }

        nodes[0] = map_->getNodeAt(node->xIndex_ -1, node->yIndex_);    //left
        nodes[1] = map_->getNodeAt(node->xIndex_ +1, node->yIndex_);    //right
        nodes[2] = map_->getNodeAt(node->xIndex_, node->yIndex_ -1);    //up
        nodes[3] = map_->getNodeAt(node->xIndex_, node->yIndex_ +1);    //down
        nodes[4] = map_->getNodeAt(node->xIndex_ -1, node->yIndex_ -1); //leftup
        nodes[5] = map_->getNodeAt(node->xIndex_ +1, node->yIndex_ -1); //rightup
        nodes[6] = map_->getNodeAt(node->xIndex_ -1, node->yIndex_ +1); //leftdown
        nodes[7] = map_->getNodeAt(node->xIndex_ +1, node->yIndex_ +1); //rightdown
                       
        MapNode* tempNote = NULL;
        for (int i = 0; i < 8; ++i) {
			tempNote = nodes[i];
			if (tempNote == NULL) 	{
				continue;
			}
			if (closeSet_->count(tempNote) > 0 || tempNote->state_ != 0)	//in close or can not pass
			{
				continue;
			}
			float tempG = node->info_->g_ + nodeDistance(tempNote, node);
			if (openSet_->count(tempNote) > 0)								//in open
			{
				if (tempG < tempNote->info_->g_)
				{			
					openSet_->erase(tempNote);
					tempNote->info_->g_ =  tempG;
					tempNote->info_->h_ = nodeDistance(tempNote, nodeDes);
					tempNote->info_->f_ = tempNote->info_->g_ +  tempNote->info_->h_;
					tempNote->info_->parent_ = node;
					openSet_->insert(tempNote);
				}
			}
			else {															//not in open & not in close
				tempNote->info_->g_ =  tempG;
				tempNote->info_->h_ = nodeDistance(tempNote, nodeDes);
				tempNote->info_->f_ = tempNote->info_->g_ +  tempNote->info_->h_;
				tempNote->info_->parent_ = node;
				openSet_->insert(tempNote);
			}
			tempNote = NULL;
        }
        
        CCLOG("judge cost:%d", clock()-oldt);
    }
    
    
    
	path_out->clear();
	if (!isFind) {															//not found, get the nearest path
		node = *closeSet_->begin();
	}
    
    int oldt = clock();
    
	while (node != nodeSrc) {
		path_out->push_back(node);
		node = node->info_->parent_;
	}
    
    CCLOG("path init cost:%d", clock()-oldt);
    oldt = clock();
	map_->resetMapInfo();
    
    CCLOG("reset infos cost:%d", clock()-oldt);

    closeSet_->clear();
    openSet_->clear();

    return isFind;
}