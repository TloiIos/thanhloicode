#import "EspManager.h"
#include "../Helper/Hooks.h"

@implementation EspManager

static BOOL _isMonitoring = NO;

+ (void)setupESP {
    // Khởi tạo game_sdk
    game_sdk->init();
    
    Vars.Enable = false;
    Vars.Aimbot = false;
    Vars.AimFov = 90.0f;
    Vars.AimMode = 2;
    Vars.AimWhen = 3;
    Vars.Target = HEAD;
    Vars.VisibleCheck = true;
    Vars.ShowFovCircle = true;
    Vars.isAimFov = true;
    Vars.gameState = GAME_NOT_FOUND;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    disp.width = screenSize.width;
    disp.height = screenSize.height;
    disp.wh = ImVec2(screenSize.width, screenSize.height);
    
    // Bắt đầu monitoring game
    [self startMonitoring];
}

+ (void)startMonitoring {
    if (_isMonitoring) return;
    _isMonitoring = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (_isMonitoring) {
            if (Vars.gameState != GAME_CONNECTED) {
                if (AutoConnect::FindGameProcess()) {
                    AutoConnect::ConnectToGame();
                    // Gửi notification khi kết nối thành công
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"GameConnectedNotification" object:nil];
                    });
                }
            }
            [NSThread sleepForTimeInterval:0.5];
        }
    });
}

+ (void)stopMonitoring {
    _isMonitoring = NO;
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
+ (void)setAimbotEnabled:(BOOL)enabled { 
    Vars.Aimbot = enabled;
    if (enabled) Vars.isAimFov = true;
}

+ (void)setAimbotFov:(float)fov { 
    Vars.AimFov = fov;
    Vars.isAimFov = (fov > 0);
}

+ (void)setAimbotTarget:(NSInteger)target { Vars.Target = (AimTarget)target; }
+ (void)setAimbotMode:(NSInteger)mode { Vars.AimMode = (int)mode; }
+ (void)setAimbotWhen:(NSInteger)when { Vars.AimWhen = (int)when; }
+ (void)setAimbotVisibleCheck:(BOOL)enabled { Vars.VisibleCheck = enabled; }
+ (void)setAimbotShowFovCircle:(BOOL)enabled { Vars.ShowFovCircle = enabled; }
+ (void)setSilentAimEnabled:(BOOL)enabled { Vars.SilentAim = enabled; }

// ==================== RENDER ====================
+ (void)renderESP {
    if (!Vars.Enable) return;
    if (Vars.gameState != GAME_CONNECTED) return;
    get_players();
}

+ (void)renderAimbot {
    if (!Vars.Aimbot) return;
    if (Vars.gameState != GAME_CONNECTED) return;
    aimbot();
}

// ==================== STATUS ====================
+ (BOOL)isEspEnabled { return Vars.Enable; }
+ (BOOL)isAimbotEnabled { return Vars.Aimbot; }
+ (BOOL)isGameConnected { return Vars.gameState == GAME_CONNECTED; }
