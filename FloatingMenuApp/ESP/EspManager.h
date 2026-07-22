// EspManager.h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EspManager : NSObject

// Singleton
+ (instancetype)sharedManager;

// Game State
+ (BOOL)isGameConnected;
+ (BOOL)isGameDisconnected;
+ (BOOL)isGameConnecting;
+ (void)setGameStateConnected;
+ (void)setGameStateDisconnected;
+ (void)setupESP;

// ESP Main
+ (BOOL)isEspEnabled;
+ (void)setEspEnabled:(BOOL)enabled;
+ (void)toggleEsp;

// ESP Features
+ (BOOL)isEspBoxEnabled;
+ (void)setEspBoxEnabled:(BOOL)enabled;
+ (BOOL)isEspLinesEnabled;
+ (void)setEspLinesEnabled:(BOOL)enabled;
+ (BOOL)isEspSkeletonEnabled;
+ (void)setEspSkeletonEnabled:(BOOL)enabled;
+ (BOOL)isEspCircleEnabled;
+ (void)setEspCircleEnabled:(BOOL)enabled;
+ (BOOL)isEspOOFEnabled;
+ (void)setEspOOFEnabled:(BOOL)enabled;
+ (BOOL)isEspShowInfoEnabled;
+ (void)setEspShowInfoEnabled:(BOOL)enabled;
+ (BOOL)isEspEnemyCountEnabled;
+ (void)setEspEnemyCountEnabled:(BOOL)enabled;
+ (BOOL)isEspEnemyWarningEnabled;
+ (void)setEspEnemyWarningEnabled:(BOOL)enabled;
+ (BOOL)isEspFovEnabled;
+ (void)setEspFovEnabled:(BOOL)enabled;

// ESP Display Options
+ (BOOL)showBoxes;
+ (void)setShowBoxes:(BOOL)show;
+ (BOOL)showLines;
+ (void)setShowLines:(BOOL)show;
+ (BOOL)showDistance;
+ (void)setShowDistance:(BOOL)show;
+ (BOOL)showHealth;
+ (void)setShowHealth:(BOOL)show;
+ (BOOL)showSnaplines;
+ (void)setShowSnaplines:(BOOL)show;

// Aimbot
+ (BOOL)isAimbotEnabled;
+ (void)setAimbotEnabled:(BOOL)enabled;
+ (void)toggleAimbot;
+ (BOOL)isSilentAimEnabled;
+ (void)setSilentAimEnabled:(BOOL)enabled;
+ (BOOL)isAimbotVisibleCheck;
+ (void)setAimbotVisibleCheck:(BOOL)enabled;
+ (BOOL)isAimbotFovEnabled;
+ (void)setAimbotFovEnabled:(BOOL)enabled;

// Aimbot Settings
+ (float)aimbotFov;
+ (void)setAimbotFov:(float)fov;
+ (float)aimbotSmooth;
+ (void)setAimbotSmooth:(float)smooth;
+ (int)aimbotBone;
+ (void)setAimbotBone:(int)bone;

// Rendering
+ (void)renderESP;
+ (void)renderAimbot;
+ (void)updateESP;
+ (void)updateAimbot;

// Utility
+ (void)showOverlay;
+ (void)hideOverlay;
+ (void)resetAllSettings;
+ (void)logStatus;

@end

NS_ASSUME_NONNULL_END
