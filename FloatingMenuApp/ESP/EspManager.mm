#import "EspManager.h"
#import "AutoConnectManager.h"
#include "../Helper/Hooks.h"
#include "../Helper/Offsets.h"

@implementation EspManager

+ (void)setupESP {
    // Bắt đầu monitoring game
    [[AutoConnectManager sharedInstance] startMonitoringGame];
    
    // Đăng ký notification khi kết nối game thành công
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onGameConnected)
                                                 name:@"GameConnectedNotification"
                                               object:nil];
    
    // Khởi tạo game_sdk
    game_sdk->init();
    
    // Cài đặt mặc định
    Vars.Enable = false;
    Vars.Aimbot = false;
    Vars.AimFov = 90.0f;
    Vars.AimMode = 2;
    Vars.AimWhen = 3;
    Vars.Target = HEAD;
    Vars.VisibleCheck = true;
    Vars.ShowFovCircle = true;
    Vars.isAimFov = true;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    disp.width = screenSize.width;
    disp.height = screenSize.height;
    disp.wh = ImVec2(screenSize.width, screenSize.height);
    
    NSLog(@"✅ ESP Setup complete! Waiting for game...");
}

+ (void)onGameConnected {
    NSLog(@"✅ Game connected! ESP ready.");
    // Tự động bật ESP khi game kết nối
    Vars.Enable = true;
    Vars.Box = true;
    Vars.lines = true;
    Vars.skeleton = true;
    Vars.ShowInfo = true;
    Vars.enemycount = true;
    Vars.enemywarning = true;
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
    if (![[AutoConnectManager sharedInstance] isConnectedToGame]) return;
    get_players();
}

+ (void)renderAimbot {
    if (!Vars.Aimbot) return;
    if (![[AutoConnectManager sharedInstance] isConnectedToGame]) return;
    aimbot();
}

// ==================== STATUS ====================
+ (BOOL)isEspEnabled { return Vars.Enable; }
+ (BOOL)isAimbotEnabled { return Vars.Aimbot; }
+ (BOOL)isGameConnected { return [[AutoConnectManager sharedInstance] isConnectedToGame]; }

@end
