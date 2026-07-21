// EspManager.mm
#import "EspManager.h"
#include "Helper/Hooks.h"

@implementation EspManager

+ (void)setupESP {
    // Khởi tạo game_sdk
    game_sdk->init();
    
    // Cài đặt mặc định
    Vars.Enable = false;
    Vars.Aimbot = false;
    Vars.AimFov = 90.0f;
    Vars.AimMode = 2; // FOV Mode
    Vars.AimWhen = 3; // Fire & Scope
    Vars.Target = HEAD;
    Vars.VisibleCheck = true;
    Vars.ShowFovCircle = true;
    
    // Setup display
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    disp.width = screenSize.width;
    disp.height = screenSize.height;
    disp.wh = ImVec2(screenSize.width, screenSize.height);
}

// ==================== ESP TOGGLES ====================
+ (void)setEspEnabled:(BOOL)enabled {
    Vars.Enable = enabled;
}

+ (void)setEspBoxEnabled:(BOOL)enabled {
    Vars.Box = enabled;
}

+ (void)setEspLinesEnabled:(BOOL)enabled {
    Vars.lines = enabled;
}

+ (void)setEspNameEnabled:(BOOL)enabled {
    Vars.Name = enabled;
}

+ (void)setEspHealthEnabled:(BOOL)enabled {
    Vars.Health = enabled;
}

+ (void)setEspDistanceEnabled:(BOOL)enabled {
    Vars.Distance = enabled;
}

+ (void)setEspSkeletonEnabled:(BOOL)enabled {
    Vars.skeleton = enabled;
}

+ (void)setEspCircleEnabled:(BOOL)enabled {
    Vars.circlepos = enabled;
}

+ (void)setEspOOFEnabled:(BOOL)enabled {
    Vars.OOF = enabled;
}

+ (void)setEspShowInfoEnabled:(BOOL)enabled {
    Vars.ShowInfo = enabled;
}

+ (void)setEspEnemyCountEnabled:(BOOL)enabled {
    Vars.enemycount = enabled;
}

+ (void)setEspEnemyWarningEnabled:(BOOL)enabled {
    Vars.enemywarning = enabled;
}

// ==================== AIMBOT TOGGLES ====================
+ (void)setAimbotEnabled:(BOOL)enabled {
    Vars.Aimbot = enabled;
}

+ (void)setAimbotFov:(float)fov {
    Vars.AimFov = fov;
    Vars.isAimFov = YES;
}

+ (void)setAimbotTarget:(NSInteger)target {
    Vars.Target = (AimTarget)target;
}

+ (void)setAimbotMode:(NSInteger)mode {
    Vars.AimMode = (int)mode;
}

+ (void)setAimbotWhen:(NSInteger)when {
    Vars.AimWhen = (int)when;
}

+ (void)setAimbotVisibleCheck:(BOOL)enabled {
    Vars.VisibleCheck = enabled;
}

+ (void)setAimbotShowFovCircle:(BOOL)enabled {
    Vars.ShowFovCircle = enabled;
}

+ (void)setSilentAimEnabled:(BOOL)enabled {
    Vars.SilentAim = enabled;
}

// ==================== RENDER ====================
+ (void)renderESP {
    if (!Vars.Enable) return;
    get_players();
}

+ (void)renderAimbot {
    if (!Vars.Aimbot) return;
    aimbot();
}

// ==================== STATUS ====================
+ (BOOL)isEspEnabled {
    return Vars.Enable;
}

+ (BOOL)isAimbotEnabled {
    return Vars.Aimbot;
}

@end