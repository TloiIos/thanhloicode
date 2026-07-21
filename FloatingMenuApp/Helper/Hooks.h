#import "vinhtran.hpp"
#import "loading.hxx"
#import "Mem.h"
#import "Monostring.h"
#import "Offsets.h"
#include <fstream>
#include <algorithm>
#include <chrono>
#include <string>
#include <cmath>
#include <cstring>
#include <vector>
#include <sys/sysctl.h>
#include <libproc.h>

extern "C" uintptr_t get_libBase();
uintptr_t get_libBase();

#ifdef __cplusplus
extern "C" {
#endif
    bool Zexis(void *address[], void *function[], int count);
    bool ZexisUnhook(void *address);
#ifdef __cplusplus
}
#endif

// ==================== ENUMS ====================
enum AimTarget { HEAD, HEADv2, BODY };
enum GameState { GAME_NOT_FOUND, GAME_FOUND, GAME_CONNECTED };

// ==================== STRUCTS ====================
struct Vars_t {
    bool Enable = false;
    bool Box = false;
    bool lines = false;
    bool Name = false;
    bool Health = false;
    bool Distance = false;
    bool skeleton = false;
    bool circlepos = false;
    bool OOF = false;
    bool ShowInfo = false;
    bool enemycount = false;
    bool enemywarning = false;
    bool Aimbot = false;
    float AimFov = 90.0f;
    bool ShowFovCircle = true;
    bool isAimFov = true;
    AimTarget Target = HEAD;
    int AimWhen = 3;
    int AimMode = 2;
    bool VisibleCheck = true;
    bool IgnoreKnocked = true;
    float AimSpeed = 1000.0f;
    float BulletTravelTime = 0.04f;
    float fovLineColor[4] = {1.00f, 0.41f, 0.71f, 1.00f};
    bool fovaimglow = false;
    bool SilentAim = false;
    int headshotCount = 0;
    int totalShots = 0;
    GameState gameState = GAME_NOT_FOUND;
} Vars;

// ==================== TYPEDEF ====================
typedef int (*_TakeDamage)(void* instance, int damage, void* shooter, void* weapon, int bodyPart, Vector3 hitPos, Vector3 dir, void* listFloat, void* infoExtra, uint32_t flag);

// ==================== CACHE ====================
struct TargetCache {
    void* player = nullptr;
    Vector3 lastPosition = Vector3::zero();
    std::chrono::steady_clock::time_point lastUpdate;
};
static TargetCache targetCache;

// ==================== AUTO CONNECT ====================
class AutoConnect {
public:
    static bool FindGameProcess() {
        pid_t pids[1024];
        int numPids = proc_listpids(PROC_ALL_PIDS, 0, pids, sizeof(pids));
        if (numPids <= 0) return false;
        
        int numProcesses = numPids / sizeof(pid_t);
        for (int i = 0; i < numProcesses; i++) {
            if (pids[i] == 0) continue;
            char pathBuffer[PROC_PIDPATHINFO_MAXSIZE];
            int pathLength = proc_pidpath(pids[i], pathBuffer, sizeof(pathBuffer));
            if (pathLength <= 0) continue;
            
            NSString *path = [NSString stringWithUTF8String:pathBuffer];
            NSString *processName = [path lastPathComponent];
            
            if ([processName containsString:@"FreeFire"] ||
                [processName containsString:@"garena"] ||
                [processName containsString:@"com.dts.freefireth"]) {
                Vars.gameState = GAME_FOUND;
                return true;
            }
        }
        Vars.gameState = GAME_NOT_FOUND;
        return false;
    }
    
    static void ConnectToGame() {
        if (Vars.gameState == GAME_FOUND) {
            game_sdk->init();
            Vars.gameState = GAME_CONNECTED;
            Vars.Enable = true;
            NSLog(@"✅ Connected to Free Fire!");
        }
    }
};

// ==================== GAME SDK ====================
class game_sdk_t {
public:
    void init();
    int (*GetHp)(void *player);
    void *(*Curent_Match)();
    void *(*GetLocalPlayer)(void *Game);
    void *(*GetHeadPositions)(void *player);
    Vector3 (*get_position)(void *player);
    void (*set_position)(void *transform, Vector3 value);
    void *(*Component_GetTransform)(void *player);
    void *(*get_camera)();
    Vector3 (*WorldToViewpoint)(void*, Vector3, int);
    bool (*get_isVisible)(void *player);
    bool (*get_isLocalTeam)(void *player);
    bool (*get_IsDieing)(void *player);
    int (*get_MaxHP)(void *player);
    Vector3 (*GetForward)(void *player);
    void (*set_aim)(void *, Quaternion look);
    bool (*get_IsSighting)(void *player);
    bool (*get_IsFiring)(void *player);
    monoString *(*name)(void *player);
    void *(*_GetHeadPositions)(void *);
    void *(*_newHipMods)(void *);
    void *(*_GetLeftAnkleTF)(void *);
    void *(*_GetRightAnkleTF)(void *);
    void *(*_GetLeftToeTF)(void *);
    void *(*_GetRightToeTF)(void *);
    void *(*_getLeftHandTF)(void *);
    void *(*_getRightHandTF)(void *);
    void *(*_getLeftForeArmTF)(void *);
    void *(*_getRightForeArmTF)(void *);
};

game_sdk_t *game_sdk = new game_sdk_t();

void game_sdk_t::init() {
    this->GetHp = (int (*)(void *))getRealOffset(OFFSET_GET_HP);
    this->get_MaxHP = (int (*)(void *))getRealOffset(OFFSET_GET_MAX_HP);
    this->get_IsDieing = (bool (*)(void *))getRealOffset(OFFSET_IS_DEAD);
    this->get_isVisible = (bool (*)(void *))getRealOffset(OFFSET_IS_VISIBLE);
    this->get_isLocalTeam = (bool (*)(void *))getRealOffset(OFFSET_IS_LOCAL_TEAM);
    this->name = (monoString * (*)(void *player)) getRealOffset(OFFSET_GET_NAME);
    this->Component_GetTransform = (void *(*)(void *))getRealOffset(OFFSET_GET_TRANSFORM);
    this->get_position = (Vector3(*)(void *))getRealOffset(OFFSET_GET_POSITION);
    this->set_position = (void (*)(void *, Vector3))getRealOffset(OFFSET_SET_POSITION);
    this->GetForward = (Vector3(*)(void *))getRealOffset(OFFSET_GET_FORWARD);
    this->get_camera = (void *(*)())getRealOffset(OFFSET_GET_CAMERA);
    this->WorldToViewpoint = (Vector3(*)(void*, Vector3, int))getRealOffset(OFFSET_WORLD_TO_VIEWPORT);
    this->set_aim = (void (*)(void *, Quaternion))getRealOffset(OFFSET_SET_AIM);
    this->get_IsSighting = (bool (*)(void *))getRealOffset(OFFSET_IS_SIGHTING);
    this->get_IsFiring = (bool (*)(void *))getRealOffset(OFFSET_IS_FIRING);
    this->Curent_Match = (void *(*)())getRealOffset(OFFSET_CURRENT_MATCH);
    this->GetLocalPlayer = (void *(*)(void *))getRealOffset(OFFSET_GET_LOCAL_PLAYER);
    this->GetHeadPositions = (void *(*)(void *))getRealOffset(OFFSET_HEAD_POSITION);
    this->_GetHeadPositions = (void *(*)(void *))getRealOffset(OFFSET_HEAD_POSITION);
    this->_newHipMods = (void *(*)(void *))getRealOffset(OFFSET_HIP_POSITION);
    this->_GetLeftAnkleTF = (void *(*)(void *))getRealOffset(OFFSET_LEFT_ANKLE);
    this->_GetRightAnkleTF = (void *(*)(void *))getRealOffset(OFFSET_RIGHT_ANKLE);
    this->_GetLeftToeTF = (void *(*)(void *))getRealOffset(OFFSET_LEFT_TOE);
    this->_GetRightToeTF = (void *(*)(void *))getRealOffset(OFFSET_RIGHT_TOE);
    this->_getLeftHandTF = (void *(*)(void *))getRealOffset(OFFSET_LEFT_HAND);
    this->_getRightHandTF = (void *(*)(void *))getRealOffset(OFFSET_RIGHT_HAND);
    this->_getLeftForeArmTF = (void *(*)(void *))getRealOffset(OFFSET_LEFT_FOREARM);
    this->_getRightForeArmTF = (void *(*)(void *))getRealOffset(OFFSET_RIGHT_FOREARM);
}

// ==================== HELPER FUNCTIONS ====================
Vector3 getPosition(void *player) {
    return game_sdk->get_position(game_sdk->Component_GetTransform(player));
}

Vector3 GetHeadPosition(void *player) {
    return game_sdk->get_position(game_sdk->GetHeadPositions(player));
}

Vector3 GetBonePosition(void *player, void *(*transformGetter)(void *)) {
    if (!player || !transformGetter) return Vector3();
    void *transform = transformGetter(player);
    return transform ? game_sdk->get_position(game_sdk->Component_GetTransform(transform)) : Vector3();
}

static Vector3 CameraMain(void *player) {
    return game_sdk->get_position(*(void **)((uint64_t)player + OFFSET_CAMERA_TRANSFORM));
}

bool IsClientBot(void* _this) { 
    return *(bool*)((uint64_t)_this + OFFSET_IS_BOT); 
}

// ==================== CAMERA TO SCREEN ====================
namespace Camera$$WorldToScreen {
    ImVec2 Regular(Vector3 pos) {
        auto cam = game_sdk->get_camera();
        if (!cam) return {0,0};
        Vector3 worldPoint = game_sdk->WorldToViewpoint(cam, pos, 2);
        Vector3 location;
        int ScreenWidth = ImGui::GetIO().DisplaySize.x;
        int ScreenHeight = ImGui::GetIO().DisplaySize.y;
        location.x = ScreenWidth * worldPoint.x;
        location.y = ScreenHeight - worldPoint.y * ScreenHeight;
        location.z = worldPoint.z;
        return {location.x, location.y};
    }
    
    ImVec2 Checker(Vector3 pos, bool &checker) {
        auto cam = game_sdk->get_camera();
        if (!cam) return {0, 0};
        Vector3 worldPoint = game_sdk->WorldToViewpoint(cam, pos, 4);
        Vector3 location;
        int ScreenWidth = ImGui::GetIO().DisplaySize.x;
        int ScreenHeight = ImGui::GetIO().DisplaySize.y;
        location.x = ScreenWidth * worldPoint.x;
        location.y = ScreenHeight - worldPoint.y * ScreenHeight;
        location.z = worldPoint.z;
        checker = location.z > 1;
        return {location.x, location.y};
    }
}

// ==================== VISIBILITY CHECK ====================
class tanghinh {
public:
    static Vector3 Transform_GetPosition(void *player) {
        Vector3 out = Vector3::zero();
        void (*_Transform_GetPosition)(void *transform, Vector3 *out) = 
            (void (*)(void *, Vector3 *))getRealOffset(OFFSET_GET_POSITION_V3);
        _Transform_GetPosition(player, &out);
        return out;
    }
    
    static void *Player_GetHeadCollider(void *player) {
        void *(*_Player_GetHeadCollider)(void *players) = 
            (void *(*)(void *))getRealOffset(0x53C2630);
        return _Player_GetHeadCollider(player);
    }
    
    static bool Physics_Raycast(Vector3 camLocation, Vector3 headLocation, unsigned int LayerID, void *collider) {
        bool (*_Physics_Raycast)(Vector3 camLocation, Vector3 headLocation, unsigned int LayerID, void *collider) = 
            (bool (*)(Vector3, Vector3, unsigned int, void *))getRealOffset(0x5FE855C);
        return _Physics_Raycast(camLocation, headLocation, LayerID, collider);
    }
    
    static bool isVisible(void *enemy) {
        if (enemy != NULL) {
            void *hitObj = NULL;
            auto Camera = Transform_GetPosition(game_sdk->Component_GetTransform(game_sdk->get_camera()));
            auto Target = Transform_GetPosition(game_sdk->Component_GetTransform(Player_GetHeadCollider(enemy)));
            return !Physics_Raycast(Camera, Target, 12, &hitObj);
        }
        return false;
    }
};

// ==================== FOV FUNCTIONS ====================
bool isFov(Vector3 vec1, Vector3 vec2, int radius) {
    int x = (int)vec1.x, y = (int)vec1.y;
    int x0 = (int)vec2.x, y0 = (int)vec2.y;
    return (pow(x - x0, 2) + pow(y - y0, 2)) <= pow(radius, 2);
}

bool isWithin180FOV(Vector3 localPos, Vector3 enemyPos, Vector3 forward) {
    Vector3 directionToEnemy = Vector3::Normalized(enemyPos - localPos);
    return Vector3::Dot(forward, directionToEnemy) >= 0.0f;
}

// ==================== GET CLOSEST ENEMY ====================
void *GetClosestEnemyByMode() {
    try {
        float shortestDistance = 250.0f;
        void *closestEnemy = NULL;
        void *get_MatchGame = game_sdk->Curent_Match();
        if (!get_MatchGame) return NULL;
        
        void *LocalPlayer = game_sdk->GetLocalPlayer(get_MatchGame);
        if (!LocalPlayer || !game_sdk->Component_GetTransform(LocalPlayer)) return NULL;
        if (!Vars.Aimbot && !Vars.Enable) return NULL;
        
        Dictionary<uint8_t *, void **> *players = 
            *(Dictionary<uint8_t *, void **> **)((long) get_MatchGame + OFFSET_PLAYERS_DICTIONARY);
        if (!players) return NULL;
        
        Vector3 LocalPlayerPos = getPosition(LocalPlayer);
        Vector3 LocalForward = game_sdk->GetForward(game_sdk->Component_GetTransform(LocalPlayer));
        ImVec2 center = ImVec2(ImGui::GetIO().DisplaySize.x / 2, ImGui::GetIO().DisplaySize.y / 2);
        
        for (int u = 0; u < players->getSize(); u++) {
            void *Player = players->getValues()[u];
            if (!Player || Player == LocalPlayer || !game_sdk->get_MaxHP(Player) || 
                game_sdk->get_isLocalTeam(Player)) continue;
            if (Vars.IgnoreKnocked && game_sdk->get_IsDieing(Player)) continue;
            
            Vector3 PlayerPos = GetHeadPosition(Player);
            float distance = Vector3::Distance(LocalPlayerPos, PlayerPos);
            if (distance >= 300) continue;
            
            bool isValidTarget = false;
            if (Vars.AimMode == 0) isValidTarget = true;
            else if (Vars.AimMode == 1) isValidTarget = isWithin180FOV(LocalPlayerPos, PlayerPos, LocalForward);
            else if (Vars.AimMode == 2) {
                ImVec2 enemyScreenPos = Camera$$WorldToScreen::Regular(PlayerPos);
                isValidTarget = isFov(Vector3(enemyScreenPos.x, enemyScreenPos.y, 0), 
                                      Vector3(center.x, center.y, 0), (int)Vars.AimFov);
            }
            
            if (isValidTarget) {
                if (Vars.VisibleCheck && !tanghinh::isVisible(Player)) continue;
                if (distance < shortestDistance) {
                    shortestDistance = distance;
                    closestEnemy = Player;
                }
            }
        }
        return closestEnemy;
    } catch (...) {
        return NULL;
    }
}

// ==================== PREDICT POSITION ====================
Vector3 PredictPosition(void* player, Vector3 currentPos) {
    if (player != targetCache.player || targetCache.lastPosition == Vector3::zero())
        return currentPos;
    auto now = std::chrono::steady_clock::now();
    float deltaTime = std::chrono::duration_cast<std::chrono::milliseconds>(
        now - targetCache.lastUpdate).count() / 1000.0f;
    if (deltaTime <= 0) return currentPos;
    Vector3 velocity = (currentPos - targetCache.lastPosition) / deltaTime;
    return currentPos + velocity * Vars.BulletTravelTime;
}

// ==================== PROCESS AIMBOT ====================
void ProcessAimbot() {
    if (!Vars.Aimbot) return;
    if (Vars.gameState != GAME_CONNECTED) return;
    
    void *CurrentMatch = game_sdk->Curent_Match();
    if (!CurrentMatch) return;
    
    void *LocalPlayer = game_sdk->GetLocalPlayer(CurrentMatch);
    if (!LocalPlayer || !game_sdk->Component_GetTransform(LocalPlayer)) return;
    
    void *closestEnemy = GetClosestEnemyByMode();
    if (!closestEnemy || !game_sdk->Component_GetTransform(closestEnemy)) return;
    
    Vector3 EnemyLocation = Vector3::zero();
    switch (Vars.Target) {
        case HEADv2:
            EnemyLocation = GetBonePosition(closestEnemy, game_sdk->_GetHeadPositions);
            break;
        case BODY:
            EnemyLocation = GetBonePosition(closestEnemy, game_sdk->_newHipMods);
            break;
        default:
            EnemyLocation = GetHeadPosition(closestEnemy);
            break;
    }
    if (EnemyLocation == Vector3::zero()) return;
    EnemyLocation = PredictPosition(closestEnemy, EnemyLocation);
    
    Vector3 PlayerLocation = CameraMain(LocalPlayer);
    if (PlayerLocation == Vector3::zero()) return;
    
    bool IsScopeOn = game_sdk->get_IsSighting(LocalPlayer);
    bool IsFiring = game_sdk->get_IsFiring(LocalPlayer);
    bool shouldAim = (Vars.AimWhen == 0) ||
                     (Vars.AimWhen == 1 && IsFiring) ||
                     (Vars.AimWhen == 2 && IsScopeOn) ||
                     (Vars.AimWhen == 3 && (IsFiring || IsScopeOn));
    
    if (shouldAim && (!Vars.VisibleCheck || tanghinh::isVisible(closestEnemy))) {
        Quaternion TargetLook = Quaternion::LookRotation(
            Vector3::Normalized(EnemyLocation - PlayerLocation), 
            Vector3(0, 1, 0)
        );
        game_sdk->set_aim(LocalPlayer, TargetLook);
    }
}

// ==================== DRAW ESP ====================
void DrawESP() {
    ImDrawList *draw_list = ImGui::GetBackgroundDrawList();
    if (!draw_list || !Vars.Enable) return;
    if (Vars.gameState != GAME_CONNECTED) return;
    
    try {
        void *current_Match = game_sdk->Curent_Match();
        if (!current_Match) return;
        
        void *local_player = game_sdk->GetLocalPlayer(current_Match);
        if (!local_player) return;
        
        Dictionary<uint8_t *, void **> *players = 
            *(Dictionary<uint8_t *, void **> **)((long)current_Match + OFFSET_PLAYERS_DICTIONARY);
        if (!players) return;
        
        void *cameraTransform = game_sdk->Component_GetTransform(game_sdk->get_camera());
        if (!cameraTransform) return;
        
        int enemy_index = 0;
        int enemyCount = 0;
        int botCount = 0;
        int enemyVisibleCount = 0;
        const auto &viewpos = game_sdk->get_position(game_sdk->Component_GetTransform(game_sdk->get_camera()));
        
        for (int u = 0; u < players->getSize(); u++) {
            void *closestEnemy = players->getValues()[u];
            if (!closestEnemy) continue;
            
            if (IsClientBot(closestEnemy)) botCount++;
            if (!game_sdk->Component_GetTransform(closestEnemy)) continue;
            if (closestEnemy == local_player) continue;
            if (!game_sdk->get_MaxHP(closestEnemy)) continue;
            if (game_sdk->get_IsDieing(closestEnemy)) continue;
            if (!game_sdk->get_isVisible(closestEnemy)) continue;
            if (game_sdk->get_isLocalTeam(closestEnemy)) continue;
            
            Vector3 pos = getPosition(closestEnemy);
            Vector3 pos2 = getPosition(local_player);
            float distance = Vector3::Distance(pos, pos2);
            if (distance > 200.0f) continue;
            
            bool w2sc;
            ImVec2 top_pos = Camera$$WorldToScreen::Regular(pos + Vector3(0, 1.6, 0));
            ImVec2 bot_pos = Camera$$WorldToScreen::Regular(pos);
            ImVec2 pos_3 = Camera$$WorldToScreen::Checker(pos, w2sc);
            
            auto pmtXtop = top_pos.x;
            auto pmtXbottom = bot_pos.x;
            if (top_pos.x > bot_pos.x) {
                pmtXtop = bot_pos.x;
                pmtXbottom = top_pos.x;
            }
            
            Camera$$WorldToScreen::Checker(pos + Vector3(0, 0.75f, 0), w2sc);
            float calculatedPosition = fabs((top_pos.y - bot_pos.y) * (0.0092f / 0.019f) / 2);
            
            ImRect rect(
                ImVec2(pmtXtop - calculatedPosition, top_pos.y),
                ImVec2(pmtXbottom + calculatedPosition, bot_pos.y)
            );
            
            if (w2sc) {
                enemyVisibleCount++;
                enemyCount++;
                bool isDead = game_sdk->get_IsDieing(closestEnemy);
                ImColor edgeColor = isDead ? ImColor(255, 80, 80, 180) : ImColor(210, 210, 210, 170);
                
                if (Vars.lines) {
                    draw_list->AddLine(
                        ImVec2(ImGui::GetIO().DisplaySize.x / 2, 0),
                        ImVec2(rect.GetCenter().x, rect.Min.y),
                        edgeColor, 0.6f
                    );
                }
                
                if (Vars.Box) {
                    float thickness = 0.7f;
                    float corner = 7.0f;
                    draw_list->AddRect(rect.Min, rect.Max, edgeColor, 0.0f, 0, thickness);
                    draw_list->AddLine(rect.Min, rect.Min + ImVec2(corner, 0), edgeColor, thickness);
                    draw_list->AddLine(rect.Min, rect.Min + ImVec2(0, corner), edgeColor, thickness);
                    draw_list->AddLine(ImVec2(rect.Max.x, rect.Min.y), ImVec2(rect.Max.x - corner, rect.Min.y), edgeColor, thickness);
                    draw_list->AddLine(ImVec2(rect.Max.x, rect.Min.y), ImVec2(rect.Max.x, rect.Min.y + corner), edgeColor, thickness);
                    draw_list->AddLine(ImVec2(rect.Min.x, rect.Max.y), ImVec2(rect.Min.x + corner, rect.Max.y), edgeColor, thickness);
                    draw_list->AddLine(ImVec2(rect.Min.x, rect.Max.y), ImVec2(rect.Min.x, rect.Max.y - corner), edgeColor, thickness);
                    draw_list->AddLine(rect.Max - ImVec2(corner, 0), rect.Max, edgeColor, thickness);
                    draw_list->AddLine(rect.Max - ImVec2(0, corner), rect.Max, edgeColor, thickness);
                }
                
                if (Vars.circlepos) {
                    Draw3DCircle(pos, 1.0f, 0.5f, ImColor(255, 0, 0), 36, false, 0.5f);
                }
                
                if (Vars.skeleton) {
                    DrawSkeleton(closestEnemy, draw_list);
                }
            }
        }
    } catch (...) {
        return;
    }
}

// ==================== DRAW SKELETON ====================
void DrawSkeleton(void* player, ImDrawList* drawList) {
    if (!player || !drawList) return;
    
    bool isPlayerVisible = tanghinh::isVisible(player);
    bool isDead = game_sdk->get_IsDieing(player);
    
    Vector3 headPos = GetBonePosition(player, game_sdk->_GetHeadPositions);
    Vector3 hipPos = GetBonePosition(player, game_sdk->_newHipMods);
    Vector3 leftAnklePos = GetBonePosition(player, game_sdk->_GetLeftAnkleTF);
    Vector3 rightAnklePos = GetBonePosition(player, game_sdk->_GetRightAnkleTF);
    Vector3 leftToePos = GetBonePosition(player, game_sdk->_GetLeftToeTF);
    Vector3 rightToePos = GetBonePosition(player, game_sdk->_GetRightToeTF);
    Vector3 leftHandPos = GetBonePosition(player, game_sdk->_getLeftHandTF);
    Vector3 rightHandPos = GetBonePosition(player, game_sdk->_getRightHandTF);
    Vector3 leftForeArmPos = GetBonePosition(player, game_sdk->_getLeftForeArmTF);
    Vector3 rightForeArmPos = GetBonePosition(player, game_sdk->_getRightForeArmTF);
    
    bool visible;
    ImVec2 headScreen = Camera$$WorldToScreen::Checker(headPos, visible);
    if (!visible) return;
    
    ImVec2 hipScreen = Camera$$WorldToScreen::Regular(hipPos);
    ImVec2 leftAnkleScreen = Camera$$WorldToScreen::Regular(leftAnklePos);
    ImVec2 rightAnkleScreen = Camera$$WorldToScreen::Regular(rightAnklePos);
    ImVec2 leftToeScreen = Camera$$WorldToScreen::Regular(leftToePos);
    ImVec2 rightToeScreen = Camera$$WorldToScreen::Regular(rightToePos);
    ImVec2 leftHandScreen = Camera$$WorldToScreen::Regular(leftHandPos);
    ImVec2 rightHandScreen = Camera$$WorldToScreen::Regular(rightHandPos);
    ImVec2 leftForeArmScreen = Camera$$WorldToScreen::Regular(leftForeArmPos);
    ImVec2 rightForeArmScreen = Camera$$WorldToScreen::Regular(rightForeArmPos);
    
    ImColor boneColor = isDead ? ImColor(255, 70, 70, 220) : 
                        isPlayerVisible ? ImColor(0, 255, 120, 220) : 
                        ImColor(230, 230, 230, 180);
    float thickness = 0.7f;
    
    drawList->AddCircle(headScreen, 2.0f, boneColor, 12, thickness);
    drawList->AddLine(headScreen, hipScreen, boneColor, thickness);
    drawList->AddLine(headScreen, leftForeArmScreen, boneColor, thickness);
    drawList->AddLine(headScreen, rightForeArmScreen, boneColor, thickness);
    drawList->AddLine(leftForeArmScreen, leftHandScreen, boneColor, thickness);
    drawList->AddLine(rightForeArmScreen, rightHandScreen, boneColor, thickness);
    drawList->AddLine(hipScreen, leftAnkleScreen, boneColor, thickness);
    drawList->AddLine(hipScreen, rightAnkleScreen, boneColor, thickness);
    drawList->AddLine(leftAnkleScreen, leftToeScreen, boneColor, thickness);
    drawList->AddLine(rightAnkleScreen, rightToeScreen, boneColor, thickness);
}

// ==================== MAIN FUNCTIONS ====================
void get_players() {
    ImDrawList *draw_list = ImGui::GetBackgroundDrawList();
    if (!draw_list) return;
    if (!Vars.Enable) return;
    ProcessAimbot();
    DrawESP();
}

void aimbot() {
    ImVec2 center = ImVec2(ImGui::GetIO().DisplaySize.x / 2, ImGui::GetIO().DisplaySize.y / 2);
    if (!Vars.Aimbot) return;
    ImDrawList *draw_list = ImGui::GetBackgroundDrawList();
    if (!draw_list) return;
    
    void *Match = game_sdk->Curent_Match();
    if (!Match) return;
    
    if (Vars.isAimFov) {
        draw_list->AddCircle(center, Vars.AimFov, 
            ImColor(Vars.fovLineColor[0], Vars.fovLineColor[1], 
                    Vars.fovLineColor[2], Vars.fovLineColor[3]), 100);
    }
    
    void *LocalPlayer = game_sdk->GetLocalPlayer(Match);
    if (!LocalPlayer) return;
    
    void *playertarget = GetClosestEnemyByMode();
    if (!playertarget) return;
    
    ImVec2 EnemyLocation = Camera$$WorldToScreen::Regular(GetHeadPosition(playertarget));
    drawlineglow(draw_list, ImVec2(center.x, center.y), EnemyLocation, ImColor(255, 255, 255), 1, 3);
}
