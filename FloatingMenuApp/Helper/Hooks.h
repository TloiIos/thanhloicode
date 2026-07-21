// Hooks.h - ESP & Aimbot Only
#import "vinhtran.hpp"
#import "loading.hxx"
#include <fstream>
#include <algorithm>
#include <chrono>

#define FMT_HEADER_ONLY
#include "fmt/core.h"

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
enum AimTarget {
    HEAD,
    HEADv2,
    BODY
};

// ==================== STRUCTS ====================
struct Vars_t {
    // ESP
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
    
    // Aimbot
    bool Aimbot = false;
    float AimFov = 90.0f;
    bool ShowFovCircle = true;
    bool isAimFov = true;
    AimTarget Target = HEAD;
    int AimWhen = 3; // 0=Always, 1=Fire, 2=Scope, 3=Fire&Scope
    int AimMode = 2; // 0=360°, 1=180°, 2=FOV
    bool VisibleCheck = true;
    bool IgnoreKnocked = true;
    float AimSpeed = 1000.0f;
    float BulletTravelTime = 0.04f;
    float fovLineColor[4] = {1.00f, 0.41f, 0.71f, 1.00f};
    bool fovaimglow = false;
    
    // Silent Aim
    bool SilentAim = false;
    
    // Thống kê
    int headshotCount = 0;
    int totalShots = 0;
} Vars;

// ==================== TYPEDEF ====================
typedef int (*_TakeDamage)(
    void* instance,
    int damage,
    void* shooter,
    void* weapon,
    int bodyPart,
    Vector3 hitPos,
    Vector3 dir,
    void* listFloat,
    void* infoExtra,
    uint32_t flag
);

// ==================== CACHE ====================
struct TargetCache {
    void* player = nullptr;
    Vector3 lastPosition = Vector3::zero();
    std::chrono::steady_clock::time_point lastUpdate;
};

static TargetCache targetCache;

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
    // Player
    this->GetHp = (int (*)(void *))getRealOffset(oxo("0x543592C"));
    this->get_MaxHP = (int (*)(void *))getRealOffset(oxo("0x5435A3C"));
    this->get_IsDieing = (bool (*)(void *))getRealOffset(oxo("0x53AA18C"));
    this->get_isVisible = (bool (*)(void *))getRealOffset(oxo("0x53C8894"));
    this->get_isLocalTeam = (bool (*)(void *))getRealOffset(oxo("0x53E20C4"));
    this->name = (monoString * (*)(void *player)) getRealOffset(oxo("0x53BE8E0"));
    
    // Transform
    this->Component_GetTransform = (void *(*)(void *))getRealOffset(oxo("0x91B82E4"));
    this->get_position = (Vector3(*)(void *))getRealOffset(oxo("0x91CA56C"));
    this->set_position = (void (*)(void *, Vector3))getRealOffset(0x91CA634);
    this->GetForward = (Vector3(*)(void *))getRealOffset(oxo("0x91CAF64"));
    
    // Camera
    this->get_camera = (void *(*)())getRealOffset(oxo("0x915E9E4"));
    this->WorldToViewpoint = (Vector3(*)(void*, Vector3, int))getRealOffset(oxo("0x915E364"));
    
    // Aim
    this->set_aim = (void (*)(void *, Quaternion))getRealOffset(oxo("0x53C4534"));
    this->get_IsSighting = (bool (*)(void *))getRealOffset(oxo("0x53B769C"));
    this->get_IsFiring = (bool (*)(void *))getRealOffset(oxo("0x53ACC9C"));
    
    // Game
    this->Curent_Match = (void *(*)())getRealOffset(oxo("0x55C4DA4"));
    this->GetLocalPlayer = (void *(*)(void *))getRealOffset(oxo("0x2FFE494"));
    
    // Bones
    this->GetHeadPositions = (void *(*)(void *))getRealOffset(oxo("0x54547E0"));
    this->_GetHeadPositions = (void *(*)(void *))getRealOffset(oxo("0x54547E0"));
    this->_newHipMods = (void *(*)(void *))getRealOffset(oxo("0x5454990"));
    this->_GetLeftAnkleTF = (void *(*)(void *))getRealOffset(oxo("0x5454DE0"));
    this->_GetRightAnkleTF = (void *(*)(void *))getRealOffset(oxo("0x5454EEC"));
    this->_GetLeftToeTF = (void *(*)(void *))getRealOffset(oxo("0x5454FF8"));
    this->_GetRightToeTF = (void *(*)(void *))getRealOffset(oxo("0x5455104"));
    this->_getLeftHandTF = (void *(*)(void *))getRealOffset(oxo("0x53C3608"));
    this->_getRightHandTF = (void *(*)(void *))getRealOffset(oxo("0x53C370C"));
    this->_getLeftForeArmTF = (void *(*)(void *))getRealOffset(oxo("0x53C3810"));
    this->_getRightForeArmTF = (void *(*)(void *))getRealOffset(oxo("0x53C3914"));
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
    return game_sdk->get_position(*(void **)((uint64_t)player + 0x380));
}

bool IsClientBot(void* _this) { 
    return *(bool*)((uint64_t)_this + 0x438); 
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
            (void (*)(void *, Vector3 *))getRealOffset(oxo("0x91CA5D0"));
        _Transform_GetPosition(player, &out);
        return out;
    }
    
    static void *Player_GetHeadCollider(void *player) {
        void *(*_Player_GetHeadCollider)(void *players) = 
            (void *(*)(void *))getRealOffset(oxo("0x53C2630"));
        return _Player_GetHeadCollider(player);
    }
    
    static bool Physics_Raycast(Vector3 camLocation, Vector3 headLocation, unsigned int LayerID, void *collider) {
        bool (*_Physics_Raycast)(Vector3 camLocation, Vector3 headLocation, unsigned int LayerID, void *collider) = 
            (bool (*)(Vector3, Vector3, unsigned int, void *))getRealOffset(oxo("0x5FE855C"));
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
    int x = vec1.x, y = vec1.y;
    int x0 = vec2.x, y0 = vec2.y;
    return (pow(x - x0, 2) + pow(y - y0, 2)) <= pow(radius, 2);
}

bool isWithin180FOV(Vector3 localPos, Vector3 enemyPos, Vector3 forward) {
    Vector3 directionToEnemy = Vector3::Normalized(enemyPos - localPos);
    return Vector3::Dot(forward, directionToEnemy) >= 0.0f;
}

// ==================== DRAW FUNCTIONS ====================
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
            *(Dictionary<uint8_t *, void **> **)((long) get_MatchGame + 0x148);
        if (!players) return NULL;
        
        Vector3 LocalPlayerPos = getPosition(LocalPlayer);
        Vector3 LocalForward = game_sdk->GetForward(game_sdk->Component_GetTransform(LocalPlayer));
        ImVec2 center = ImVec2(ImGui::GetIO().DisplaySize.x / 2, ImGui::GetIO().DisplaySize.y / 2);
        
        bool checkFOV = Vars.AimMode == 2;
        bool check180 = Vars.AimMode == 1;
        
        for (int u = 0; u < players->getSize(); u++) {
            void *Player = players->getValues()[u];
            if (!Player || Player == LocalPlayer || !game_sdk->get_MaxHP(Player) || 
                game_sdk->get_isLocalTeam(Player)) continue;
            
            if (Vars.IgnoreKnocked && game_sdk->get_IsDieing(Player)) continue;
            
            Vector3 PlayerPos = GetHeadPosition(Player);
            float distance = Vector3::Distance(LocalPlayerPos, PlayerPos);
            if (distance >= 300) continue;
            
            bool isValidTarget = false;
            if (Vars.AimMode == 0) {
                isValidTarget = true;
            } else if (check180) {
                isValidTarget = isWithin180FOV(LocalPlayerPos, PlayerPos, LocalForward);
            } else if (checkFOV) {
                ImVec2 enemyScreenPos = Camera$$WorldToScreen::Regular(PlayerPos);
                isValidTarget = isFov(Vector3(enemyScreenPos.x, enemyScreenPos.y, 0), 
                                      Vector3(center.x, center.y, 0), Vars.AimFov);
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
    
    try {
        void *current_Match = game_sdk->Curent_Match();
        if (!current_Match) return;
        
        void *local_player = game_sdk->GetLocalPlayer(current_Match);
        if (!local_player) return;
        
        Dictionary<uint8_t *, void **> *players = 
            *(Dictionary<uint8_t *, void **> **)((long)current_Match + 0x148);
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
                
                // ==================== LINES ====================
                if (Vars.lines) {
                    draw_list->AddLine(
                        ImVec2(ImGui::GetIO().DisplaySize.x / 2, 0),
                        ImVec2(rect.GetCenter().x, rect.Min.y),
                        edgeColor, 0.6f
                    );
                }
                
                // ==================== BOX ====================
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
                
                // ==================== SHOW INFO ====================
                if (Vars.ShowInfo && closestEnemy != NULL) {
                    enemy_index++;
                    
                    std::string names = "Enemy";
                    auto pname = game_sdk->name(closestEnemy);
                    if (pname != NULL) {
                        try {
                            names = pname->toCPPString();
                        } catch (...) {
                            names = "Enemy";
                        }
                    }
                    
                    if (!names.empty()) {
                        std::transform(names.begin(), names.end(), names.begin(), ::tolower);
                    }
                    
                    int health = game_sdk->GetHp(closestEnemy);
                    int maxhealth = game_sdk->get_MaxHP(closestEnemy);
                    if (maxhealth <= 0) maxhealth = 100;
                    if (health < 0) health = 0;
                    if (health > maxhealth) health = maxhealth;
                    
                    float hp_percent = (float)health / (float)maxhealth;
                    
                    std::string number = std::to_string(enemy_index);
                    std::string dist = std::to_string((int)distance) + "M";
                    
                    ImFont* info_font = main_font;
                    if (!info_font) info_font = ImGui::GetIO().Fonts->Fonts[0];
                    
                    float fontSize = 13.0f;
                    float pad_x = 5.f;
                    float pad_y = 2.f;
                    
                    float w_num = info_font->CalcTextSizeA(fontSize, FLT_MAX, 0, number.c_str()).x;
                    float w_name = info_font->CalcTextSizeA(fontSize, FLT_MAX, 0, names.c_str()).x;
                    float w_dist = info_font->CalcTextSizeA(fontSize, FLT_MAX, 0, dist.c_str()).x;
                    
                    float num_box_w = w_num + 4.f;
                    float info_w = num_box_w + 6 + w_name + 8 + w_dist + pad_x * 2;
                    float info_h = info_font->CalcTextSizeA(fontSize, FLT_MAX, 0, "A").y + pad_y * 2;
                    
                    float rect_w = rect.Max.x - rect.Min.x;
                    float start_x = rect.Min.x + (rect_w * 0.5f) - (info_w * 0.5f);
                    
                    ImVec2 info_min(start_x, rect.Min.y - info_h - 7);
                    ImVec2 info_max(start_x + info_w, rect.Min.y - 3);
                    
                    if (draw_list) {
                        draw_list->AddRectFilled(info_min, info_max, ImColor(8, 8, 8, 175), 5.0f);
                        
                        ImVec2 num_min = info_min;
                        ImVec2 num_max(info_min.x + num_box_w + 4, info_max.y);
                        draw_list->AddRectFilled(num_min, num_max, ImColor(30, 30, 30, 200), 5.0f);
                        
                        float bar_h = 2.0f;
                        ImColor hp_color = hp_percent > 0.6f ? ImColor(0, 255, 120, 230) :
                                           hp_percent > 0.3f ? ImColor(255, 190, 0, 230) :
                                           ImColor(255, 60, 60, 230);
                        
                        draw_list->AddRectFilled(
                            ImVec2(info_min.x, info_max.y - bar_h),
                            ImVec2(info_min.x + (info_w * hp_percent), info_max.y),
                            hp_color, 5.0f
                        );
                        
                        float text_x = info_min.x + 3.f;
                        float text_y = info_min.y + pad_y - 1.f;
                        
                        draw_list->AddText(info_font, fontSize, 
                            ImVec2(text_x + (num_box_w * 0.5f) - (w_num * 0.5f), text_y), 
                            ImColor(0, 255, 220), number.c_str());
                        
                        text_x = num_max.x + 4.f;
                        draw_list->AddText(info_font, fontSize, 
                            ImVec2(text_x, text_y), 
                            ImColor(255, 255, 255), names.c_str());
                        
                        text_x += w_name + 8.f;
                        draw_list->AddText(info_font, fontSize, 
                            ImVec2(text_x, text_y), 
                            ImColor(255, 180, 0), dist.c_str());
                    }
                }
                
                // ==================== CIRCLE ====================
                if (Vars.circlepos) {
                    Draw3DCircle(pos, 1.0f, 0.5f, ImColor(255, 0, 0), 36, false, 0.5f);
                }
                
                // ==================== SKELETON ====================
                if (Vars.skeleton) {
                    DrawSkeleton(closestEnemy, draw_list);
                }
            }
            
            // ==================== OOF (Out Of Frame) ====================
            if (Vars.OOF) {
                if ((pos_3.x < 0 || pos_3.x > disp.width) ||
                    (pos_3.y < 0 || pos_3.y > disp.height) || !w2sc) {
                    
                    constexpr int maxpixels = 150;
                    int pixels = maxpixels;
                    
                    if (w2sc) {
                        if (pos_3.x < 0) pixels = clamp((int)-pos_3.x, 0, maxpixels);
                        if (pos_3.y < 0) pixels = clamp((int)-pos_3.y, 0, maxpixels);
                        if (pos_3.x > disp.width) pixels = clamp((int)pos_3.x - (int)disp.width, 0, maxpixels);
                        if (pos_3.y > disp.height) pixels = clamp((int)pos_3.y - (int)disp.height, 0, maxpixels);
                    }
                    
                    float opacity = (float)pixels / (float)maxpixels;
                    
                    Vector3 viewdir = game_sdk->GetForward(cameraTransform);
                    Vector3 targetdir = Vector3::Normalized(pos - viewpos);
                    
                    float viewangle = atan2(viewdir.z, viewdir.x) * Rad2Deg;
                    float targetangle = atan2(targetdir.z, targetdir.x) * Rad2Deg;
                    
                    if (viewangle < 0) viewangle += 360.f;
                    if (targetangle < 0) targetangle += 360.f;
                    
                    float angle = targetangle - viewangle;
                    while (angle < 0) angle += 360.f;
                    while (angle > 360) angle -= 360.f;
                    
                    angle = 360.f - angle;
                    angle -= 90.f;
                    
                    ImVec2 center(ImGui::GetIO().DisplaySize.x * 0.5f, ImGui::GetIO().DisplaySize.y * 0.5f);
                    float radius = 110.f;
                    float rad = angle * IM_PI / 180.f;
                    
                    ImVec2 triPos(center.x + cosf(rad) * radius, center.y + sinf(rad) * radius);
                    ImColor triColor = (distance <= 25.f) ? 
                        ImColor(255, 40, 40, (int)(255 * opacity)) : 
                        ImColor(0, 255, 90, (int)(255 * opacity));
                    
                    float size = 9.f;
                    ImVec2 tip(triPos.x + cosf(rad) * size, triPos.y + sinf(rad) * size);
                    ImVec2 left(triPos.x + cosf(rad + 2.45f) * size, triPos.y + sinf(rad + 2.45f) * size);
                    ImVec2 right(triPos.x + cosf(rad - 2.45f) * size, triPos.y + sinf(rad - 2.45f) * size);
                    
                    draw_list->AddTriangleFilled(
                        ImVec2(tip.x + 1, tip.y + 1),
                        ImVec2(left.x + 1, left.y + 1),
                        ImVec2(right.x + 1, right.y + 1),
                        ImColor(0,0,0,(int)(120 * opacity))
                    );
                    draw_list->AddTriangleFilled(tip, left, right, triColor);
                    draw_list->AddTriangle(tip, left, right, ImColor(255,255,255,(int)(160 * opacity)), 1.0f);
                }
            }
        }
        
        // ==================== ENEMY COUNT ====================
        if (Vars.enemycount) {
            std::string count_text = "";
            if (enemyCount > 0 && botCount > 0) {
                count_text = "ENEMIES: " + std::to_string(enemyCount) + " | BOTS: " + std::to_string(botCount);
            } else if (enemyCount > 0) {
                count_text = "ENEMIES: " + std::to_string(enemyCount);
            } else if (botCount > 0) {
                count_text = "BOTS: " + std::to_string(botCount);
            } else {
                count_text = "CLEAR";
            }
            
            bool hasEnemy = (enemyCount > 0 || botCount > 0);
            ImFont* count_font = main_font;
            if (!count_font) count_font = ImGui::GetIO().Fonts->Fonts[0];
            
            float fontSize = 16.0f;
            if (draw_list && count_font) {
                ImVec2 count_size = count_font->CalcTextSizeA(fontSize, FLT_MAX, 0.0f, count_text.c_str());
                ImVec2 screen = ImGui::GetIO().DisplaySize;
                ImVec2 text_pos((screen.x * 0.5f) - (count_size.x * 0.5f),
                                (screen.y * 0.5f) - (count_size.y * 0.5f) - 100.0f);
                ImColor textColor = hasEnemy ? ImColor(255, 0, 0, 255) : ImColor(0, 255, 120, 255);
                
                draw_list->AddText(count_font, fontSize, 
                    ImVec2(text_pos.x + 1.2f, text_pos.y + 1.2f),
                    ImColor(0, 0, 0, 200), count_text.c_str());
                draw_list->AddText(count_font, fontSize, text_pos, textColor, count_text.c_str());
            }
        }
        
        // ==================== ENEMY WARNING ====================
        if (Vars.enemywarning) {
            ImFont* font = main_font;
            if (!font) font = ImGui::GetIO().Fonts->Fonts[0];
            ImVec2 screen = ImGui::GetIO().DisplaySize;
            
            if (enemyVisibleCount > 0) {
                std::string warn = "⚠ ENEMY IN SIGHT";
                float size = 22.0f;
                ImVec2 txt = font->CalcTextSizeA(size, FLT_MAX, 0, warn.c_str());
                ImVec2 pos((screen.x * 0.5f) - (txt.x * 0.5f), screen.y * 0.35f);
                
                draw_list->AddText(font, size, ImVec2(pos.x+2, pos.y+2), ImColor(0,0,0,220), warn.c_str());
                draw_list->AddText(font, size, pos, ImColor(255,140,0,255), warn.c_str());
            } else {
                std::string warn = "✓ SAFE";
                float size = 20.0f;
                ImVec2 txt = font->CalcTextSizeA(size, FLT_MAX, 0, warn.c_str());
                ImVec2 pos((screen.x * 0.5f) - (txt.x * 0.5f), screen.y * 0.40f);
                
                draw_list->AddText(font, size, ImVec2(pos.x+1, pos.y+1), ImColor(0,0,0,180), warn.c_str());
                draw_list->AddText(font, size, pos, ImColor(0,255,120,255), warn.c_str());
            }
        }
    } catch (...) {
        return;
    }
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
        if (Vars.fovaimglow) {
            drawcircleglow(draw_list, center, Vars.AimFov, 
                ImColor(Vars.fovLineColor[0], Vars.fovLineColor[1], 
                        Vars.fovLineColor[2], Vars.fovLineColor[3]), 999, 1, 12);
        } else {
            draw_list->AddCircle(center, Vars.AimFov, 
                ImColor(Vars.fovLineColor[0], Vars.fovLineColor[1], 
                        Vars.fovLineColor[2], Vars.fovLineColor[3]), 100);
        }
    }
    
    void *LocalPlayer = game_sdk->GetLocalPlayer(Match);
    if (!LocalPlayer) return;
    
    void *playertarget = GetClosestEnemyByMode();
    if (!playertarget) return;
    
    ImVec2 EnemyLocation = Camera$$WorldToScreen::Regular(GetHeadPosition(playertarget));
    drawlineglow(draw_list, ImVec2(center.x, center.y), EnemyLocation, ImColor(255, 255, 255), 1, 3);
}