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

// ESP
+ (BOOL)isEspEnabled;
+ (void)setEspEnabled:(BOOL)enabled;
+ (void)toggleEsp;

// Aimbot
+ (BOOL)isAimbotEnabled;
+ (void)setAimbotEnabled:(BOOL)enabled;
+ (void)toggleAimbot;

// ESP Options
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

// Utility
+ (void)showOverlay;
+ (void)hideOverlay;
+ (void)resetAllSettings;
+ (void)logStatus;

@end

NS_ASSUME_NONNULL_END
