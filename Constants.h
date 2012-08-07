//
//  Constants.h
//  GameManager
//
//  Created by Zhou Hangqing on 6/1/12.
//  Copyright (c) 2012 UpPower. All rights reserved.
//

#ifndef GameManager_Constants_h
#define GameManager_Constants_h

#define kMainMenuTagValue 10
#define kSceneMenuTagValue 20

typedef enum {
    kTagHPBar = 10,
    kTagPoisonEffect = 20,
    kTagMoneyAssociated = 999
} TagValue;

typedef enum {
    kStateInactivated,
    kStateSpawning,
    kStateMoving,
    kStateTargetSearching,
    kStateTargetHandling,
    kStateSkillCasting,
    kStateTakingDamage,
    kStateCausingDamage,
    kStateHavingEffect,
    kStateWaitingRecycle,
    kStateDestroying,
    kStatePausing
} GameObjectState; 

typedef enum {
    kNoneType,
    kTowerType,
    kBoatType,
    kBulletType
} GameObjectType;

typedef enum {
    kNoSceneUninitialized=0,
    kMainMenuScene=1,
    kOptionsScene=2,
    kCreditsScene=3,
    kIntroScene=4,
    kLevelCompleteScene=5,
    kGameScene1=101,
    kGameScene2=102,
    kGameScene3=103,
    kGameScene4=104,
    kGameScene5=105,
    kCutScene=201
} SceneTypes;

typedef enum {
    kLinkTypeDeveloperSite,
    kLinkTypeMoreGames
} LinkTypes;

#define AUDIO_MAX_WAITTIME 150
typedef enum {
    kAudioManagerUninitialized=0,
    kAudioManagerFailed=1,
    kAudioManagerInitializing=2,
    kAudioManagerInitialized=100,
    kAudioManagerLoading=200,
    kAudioManagerReady=300
} GameManagerSoundState;

// Audio Constants
#define SFX_NOTLOADED NO
#define SFX_LOADED YES

#define PLAYSOUNDEFFECT(...) \
[[GameManager sharedGameManager] playSoundEffect:@#__VA_ARGS__]
#define STOPSOUNDEFFECT(...) \
[[GameManager sharedGameManager] stopSoundEffect:__VA_ARGS__]
// Background Music
// Menu Scenes
#define BACKGROUND_TRACK_MAIN_MENU @"VikingPreludeV1.mp3"
// GameLevel1 (Ole Awakens)
#define BACKGROUND_TRACK_OLE_AWAKES @"SpaceDesertV2.mp3"
// Physics Puzzle Level
#define BACKGROUND_TRACK_PUZZLE @"VikingPreludeV1.mp3"
// Physics MineCart Level
#define BACKGROUND_TRACK_MINECART @"DrillBitV2.mp3"
// Physics Escape Level
#define BACKGROUND_TRACK_ESCAPE @"EscapeTheFutureV3.mp3"

// 
typedef enum {
    kZOrderTiledMap = 10,
    kZOrderBatchNode = 20,
    kZOrderSprite,
    kZOrderDecoration,
    kZOrderEffect,
    kZOrderHPBar,
    kZOrderSkill = 29,
    kZOrderTower = 30,
    kZOrderBoat = 40,
    kZOrderBullet = 50
} ZOrder;

// Targets type
typedef enum {
    kTargetTypeTower = 1,
    kTargetTypeBoat
} TargetType;

// Towers type 
typedef enum {
    kTowerTypeArrow = 1,
    kTowerTypeArtillery,
    kTowerTypeWitchcraft,
    kTowerTypeFactory,
    kTowerTypePoison = 10,
    kTowerTypeSnipe,
    kTowerTypeMissile = 20,
    kTowerTypelightning,
    kTowerTypeMagic = 30,
    kTowerTypeSummon,
    kTowerTypeGreedy = 40,
    kTowerTypeEvil
} TowerType;

// Boats type
typedef enum {
    kBoatTypeSmall = 1,
    kBoatTypeMedium = 10,
    kBoatTypeBig = 20
} BoatType;

// Bullet type
typedef enum {
    kBulletTypeArrow = 1,
    kBulletTypePoison,
    kBulletTypeMultiArrow,
    kBulletTypeSnipe,
    kBulletTypeConnonBall = 10,
    kBulletTypeMissile,
    kBulletTypeLightning,
    kBulletTypeMagicBall = 20
} BulletType;

// Direction type
typedef enum {
    kDirectionTypeEast = 1,
    kDirectionTypeNorthEast,
    kDirectionTypeNorth,
    kDirectionTypeNorthWest,
    kDirectionTypeWest,
    kDirectionTypeSouthWest,
    kDirectionTypeSouth,
    kDirectionTypeSouthEast
} DirectionType;

// Damage type
typedef enum {
    kDamageTypePiercing = 1,
    kDamageTypeExplosion,
    kDamageTypeMagic,
    kDamageTypeSunderArmor,
    kDamageTypeCorrosion,
    kDamageTypeHoly
} DamageType;

// Assist Type
typedef enum {
    kAssistTypeDefault
} AssistType;

// Armor Type
typedef enum {
    kArmorTypeLight = 1,
    kArmorTypeMedium,
    kArmorTypeHeavy,
    kArmorTypeMagic,
    kArmorTypeSubmarine,
    kArmorTypeBoss
} ArmorType;

// Skill Type
typedef enum {
    kSkillTypeWhirlpool = 100,
    kSkillTypeExtremeFreeze
} SkillType;

// Object move style
typedef enum {
    kObjectMoveStyleNone,
    kObjectMoveStyleTilePath,
    kObjectMoveStyleAutoPathFinding
} ObjectMoveStyle;

#define kMPropertyTypeProbability       @"probability"
#define kMPropertyTypeRange             @"range"
#define kMPropertyTypeLastTime          @"lastTime"
#define kMPropertyTypeDamageRate        @"damageRate"
#define kMPropertyTypeCoolDown          @"coolDown"
#define kMSkillTypeExtremeFreeze        @"ExtremeFreeze"


// Debug Enemy States with Labels
// 0 for OFF, 1 for ON
#define ENEMY_STATE_DEBUG 0

#endif
