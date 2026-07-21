
#import "EspManager.h"
#import "../Helper/Hooks.h"  // ← Import Hooks từ Helper

@implementation EspManager

+ (void)setupESP {
    // Khởi tạo game_sdk
    // game_sdk->init();
    
    Vars.Enable = false;
    Vars.Aimbot = false;
    Vars.AimFov = 90.0f;
    Vars.AimMode = 2;
    Vars.AimWhen = 3;
    Vars.Target = HEAD;
    Vars.VisibleCheck = true;
    Vars.ShowFovCircle = true;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    disp.width = screenSize.width;
    disp.height = screenSize.height;
    disp.wh = ImVec2(screenSize.width, screenSize.height);
}

// ==================== ESP ====================
+ (void)setEspEnabled:(BOOL)enabled { Vars.Enable = enabled; }
+ (void)setEspBoxEnabled:(BOOL)enabled { Vars.Box = enabled; }
+ (void)setEspLinesEnabled:(BOOL)enabled { Vars.lines = enabled; }
+ (void)setEspSkeletonEnabled:(BOOL)enabled { Vars.skeleton = enabled; }
+ (void)setEspCircleEnabled:(BOOL)enabled { Vars.circlepos = enabled; }
+ (void)setEspOOFEnabled:(BOOL)enabled { Vars.OOF = enabled; }
+ (void)setEspShowInfoEnabled:(BOOL)enabled { Vars.ShowInfo = enabled; }
+ (void)setEspEnemyCountEnabled:(BOOL)enabled { Vars.enemycount = enabled; }
+ (void)setEspEnemyWarningEnabled:(BOOL)enabled { Vars.enemywarning = enabled; }

// ==================== AIMBOT ====================
+ (void)setAimbotEnabled:(BOOL)enabled { Vars.Aimbot = enabled; }
+ (void)setAimbotFov:(float)fov { Vars.AimFov = fov; Vars.isAimFov = YES; }
+ (void)setAimbotTarget:(NSInteger)target { Vars.Target = (AimTarget)target; }
+ (void)setAimbotMode:(NSInteger)mode { Vars.AimMode = (int)mode; }
+ (void)setAimbotWhen:(NSInteger)when { Vars.AimWhen = (int)when; }
+ (void)setAimbotVisibleCheck:(BOOL)enabled { Vars.VisibleCheck = enabled; }
+ (void)setAimbotShowFovCircle:(BOOL)enabled { Vars.ShowFovCircle = enabled; }
+ (void)setSilentAimEnabled:(BOOL)enabled { Vars.SilentAim = enabled; }

// ==================== RENDER ====================
+ (void)renderESP {
    if (!Vars.Enable) return;
    get_players();  // Hàm này từ Hooks.h
}

+ (void)renderAimbot {
    if (!Vars.Aimbot) return;
    aimbot();  // Hàm này từ Hooks.h
}

// ==================== STATUS ====================
+ (BOOL)isEspEnabled { return Vars.Enable; }
+ (BOOL)isAimbotEnabled { return Vars.Aimbot; }

@end

