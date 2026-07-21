#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EspManager : NSObject

// Setup
+ (void)setupESP;

// ESP Toggles
+ (void)setEspEnabled:(BOOL)enabled;
+ (void)setEspBoxEnabled:(BOOL)enabled;
+ (void)setEspLinesEnabled:(BOOL)enabled;
+ (void)setEspNameEnabled:(BOOL)enabled;
+ (void)setEspHealthEnabled:(BOOL)enabled;
+ (void)setEspDistanceEnabled:(BOOL)enabled;
+ (void)setEspSkeletonEnabled:(BOOL)enabled;
+ (void)setEspCircleEnabled:(BOOL)enabled;
+ (void)setEspOOFEnabled:(BOOL)enabled;
+ (void)setEspShowInfoEnabled:(BOOL)enabled;
+ (void)setEspEnemyCountEnabled:(BOOL)enabled;
+ (void)setEspEnemyWarningEnabled:(BOOL)enabled;

// Aimbot Toggles
+ (void)setAimbotEnabled:(BOOL)enabled;
+ (void)setAimbotFov:(float)fov;
+ (void)setAimbotTarget:(NSInteger)target;
+ (void)setAimbotMode:(NSInteger)mode;
+ (void)setAimbotWhen:(NSInteger)when;
+ (void)setAimbotVisibleCheck:(BOOL)enabled;
+ (void)setAimbotShowFovCircle:(BOOL)enabled;
+ (void)setSilentAimEnabled:(BOOL)enabled;

// Render
+ (void)renderESP;
+ (void)renderAimbot;

// Status
+ (BOOL)isEspEnabled;
+ (BOOL)isAimbotEnabled;

@end

NS_ASSUME_NONNULL_END
