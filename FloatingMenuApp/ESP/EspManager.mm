// EspManager.mm
#import "EspManager.h"
#import "EspRenderView.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// Define game states
typedef NS_ENUM(NSInteger, GameState) {
    GAME_DISCONNECTED = 0,
    GAME_CONNECTED = 1,
    GAME_CONNECTING = 2,
    GAME_ERROR = 3
};

// Vars class implementation
@interface Vars : NSObject
@property (class, nonatomic, assign) GameState gameState;
@property (class, nonatomic, assign) BOOL espEnabled;
@property (class, nonatomic, assign) BOOL aimbotEnabled;
@property (class, nonatomic, assign) BOOL showBoxes;
@property (class, nonatomic, assign) BOOL showLines;
@property (class, nonatomic, assign) BOOL showDistance;
@property (class, nonatomic, assign) BOOL showHealth;
@property (class, nonatomic, assign) BOOL showSnaplines;
@property (class, nonatomic, assign) float aimbotFov;
@property (class, nonatomic, assign) float aimbotSmooth;
@property (class, nonatomic, assign) int aimbotBone;

// New ESP properties
@property (class, nonatomic, assign) BOOL espBoxEnabled;
@property (class, nonatomic, assign) BOOL espLinesEnabled;
@property (class, nonatomic, assign) BOOL espSkeletonEnabled;
@property (class, nonatomic, assign) BOOL espCircleEnabled;
@property (class, nonatomic, assign) BOOL espOOFEnabled;
@property (class, nonatomic, assign) BOOL espShowInfoEnabled;
@property (class, nonatomic, assign) BOOL espEnemyCountEnabled;
@property (class, nonatomic, assign) BOOL espEnemyWarningEnabled;
@property (class, nonatomic, assign) BOOL espFovEnabled;

// New Aimbot properties
@property (class, nonatomic, assign) BOOL silentAimEnabled;
@property (class, nonatomic, assign) BOOL aimbotVisibleCheck;
@property (class, nonatomic, assign) BOOL aimbotFovEnabled;
@end

@implementation Vars
static GameState _gameState = GAME_DISCONNECTED;
static BOOL _espEnabled = NO;
static BOOL _aimbotEnabled = NO;
static BOOL _showBoxes = YES;
static BOOL _showLines = YES;
static BOOL _showDistance = YES;
static BOOL _showHealth = YES;
static BOOL _showSnaplines = NO;
static float _aimbotFov = 100.0f;
static float _aimbotSmooth = 5.0f;
static int _aimbotBone = 0;

// New ESP static variables
static BOOL _espBoxEnabled = YES;
static BOOL _espLinesEnabled = YES;
static BOOL _espSkeletonEnabled = NO;
static BOOL _espCircleEnabled = NO;
static BOOL _espOOFEnabled = NO;
static BOOL _espShowInfoEnabled = YES;
static BOOL _espEnemyCountEnabled = YES;
static BOOL _espEnemyWarningEnabled = YES;
static BOOL _espFovEnabled = NO;

// New Aimbot static variables
static BOOL _silentAimEnabled = NO;
static BOOL _aimbotVisibleCheck = YES;
static BOOL _aimbotFovEnabled = YES;

// Game State
+ (GameState)gameState { return _gameState; }
+ (void)setGameState:(GameState)state { _gameState = state; }

// ESP Main
+ (BOOL)espEnabled { return _espEnabled; }
+ (void)setEspEnabled:(BOOL)enabled { _espEnabled = enabled; }

// Aimbot Main
+ (BOOL)aimbotEnabled { return _aimbotEnabled; }
+ (void)setAimbotEnabled:(BOOL)enabled { _aimbotEnabled = enabled; }

// ESP Display Options
+ (BOOL)showBoxes { return _showBoxes; }
+ (void)setShowBoxes:(BOOL)show { _showBoxes = show; }

+ (BOOL)showLines { return _showLines; }
+ (void)setShowLines:(BOOL)show { _showLines = show; }

+ (BOOL)showDistance { return _showDistance; }
+ (void)setShowDistance:(BOOL)show { _showDistance = show; }

+ (BOOL)showHealth { return _showHealth; }
+ (void)setShowHealth:(BOOL)show { _showHealth = show; }

+ (BOOL)showSnaplines { return _showSnaplines; }
+ (void)setShowSnaplines:(BOOL)show { _showSnaplines = show; }

// ESP Features
+ (BOOL)espBoxEnabled { return _espBoxEnabled; }
+ (void)setEspBoxEnabled:(BOOL)enabled { _espBoxEnabled = enabled; }

+ (BOOL)espLinesEnabled { return _espLinesEnabled; }
+ (void)setEspLinesEnabled:(BOOL)enabled { _espLinesEnabled = enabled; }

+ (BOOL)espSkeletonEnabled { return _espSkeletonEnabled; }
+ (void)setEspSkeletonEnabled:(BOOL)enabled { _espSkeletonEnabled = enabled; }

+ (BOOL)espCircleEnabled { return _espCircleEnabled; }
+ (void)setEspCircleEnabled:(BOOL)enabled { _espCircleEnabled = enabled; }

+ (BOOL)espOOFEnabled { return _espOOFEnabled; }
+ (void)setEspOOFEnabled:(BOOL)enabled { _espOOFEnabled = enabled; }

+ (BOOL)espShowInfoEnabled { return _espShowInfoEnabled; }
+ (void)setEspShowInfoEnabled:(BOOL)enabled { _espShowInfoEnabled = enabled; }

+ (BOOL)espEnemyCountEnabled { return _espEnemyCountEnabled; }
+ (void)setEspEnemyCountEnabled:(BOOL)enabled { _espEnemyCountEnabled = enabled; }

+ (BOOL)espEnemyWarningEnabled { return _espEnemyWarningEnabled; }
+ (void)setEspEnemyWarningEnabled:(BOOL)enabled { _espEnemyWarningEnabled = enabled; }

+ (BOOL)espFovEnabled { return _espFovEnabled; }
+ (void)setEspFovEnabled:(BOOL)enabled { _espFovEnabled = enabled; }

// Aimbot Settings
+ (float)aimbotFov { return _aimbotFov; }
+ (void)setAimbotFov:(float)fov { _aimbotFov = fov; }

+ (float)aimbotSmooth { return _aimbotSmooth; }
+ (void)setAimbotSmooth:(float)smooth { _aimbotSmooth = smooth; }

+ (int)aimbotBone { return _aimbotBone; }
+ (void)setAimbotBone:(int)bone { _aimbotBone = bone; }

// New Aimbot Properties
+ (BOOL)silentAimEnabled { return _silentAimEnabled; }
+ (void)setSilentAimEnabled:(BOOL)enabled { _silentAimEnabled = enabled; }

+ (BOOL)aimbotVisibleCheck { return _aimbotVisibleCheck; }
+ (void)setAimbotVisibleCheck:(BOOL)enabled { _aimbotVisibleCheck = enabled; }

+ (BOOL)aimbotFovEnabled { return _aimbotFovEnabled; }
+ (void)setAimbotFovEnabled:(BOOL)enabled { _aimbotFovEnabled = enabled; }
@end

// EspManager Implementation
@implementation EspManager

#pragma mark - Singleton
+ (instancetype)sharedManager {
    static EspManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (void)setupDefaults {
    [Vars setEspEnabled:NO];
    [Vars setAimbotEnabled:NO];
    [Vars setGameState:GAME_DISCONNECTED];
    [Vars setShowBoxes:YES];
    [Vars setShowLines:YES];
    [Vars setShowDistance:YES];
    [Vars setShowHealth:YES];
    [Vars setShowSnaplines:NO];
    [Vars setAimbotFov:100.0f];
    [Vars setAimbotSmooth:5.0f];
    [Vars setAimbotBone:0];
    
    // New defaults
    [Vars setEspBoxEnabled:YES];
    [Vars setEspLinesEnabled:YES];
    [Vars setEspSkeletonEnabled:NO];
    [Vars setEspCircleEnabled:NO];
    [Vars setEspOOFEnabled:NO];
    [Vars setEspShowInfoEnabled:YES];
    [Vars setEspEnemyCountEnabled:YES];
    [Vars setEspEnemyWarningEnabled:YES];
    [Vars setEspFovEnabled:NO];
    [Vars setSilentAimEnabled:NO];
    [Vars setAimbotVisibleCheck:YES];
    [Vars setAimbotFovEnabled:YES];
}

#pragma mark - Setup
+ (void)setupESP {
    [[self sharedManager] setupDefaults];
    [[EspRenderView sharedInstance] startRendering];
}

#pragma mark - Game State Methods
+ (BOOL)isGameConnected {
    return [Vars gameState] == GAME_CONNECTED;
}

+ (BOOL)isGameDisconnected {
    return [Vars gameState] == GAME_DISCONNECTED;
}

+ (BOOL)isGameConnecting {
    return [Vars gameState] == GAME_CONNECTING;
}

+ (void)setGameStateConnected {
    [Vars setGameState:GAME_CONNECTED];
    [[EspRenderView sharedInstance] startRendering];
}

+ (void)setGameStateDisconnected {
    [Vars setGameState:GAME_DISCONNECTED];
    [[EspRenderView sharedInstance] stopRendering];
}

#pragma mark - ESP Methods
+ (BOOL)isEspEnabled {
    return [Vars espEnabled];
}

+ (void)setEspEnabled:(BOOL)enabled {
    [Vars setEspEnabled:enabled];
    if (enabled) {
        [[EspRenderView sharedInstance] startRendering];
    } else {
        if (![self isAimbotEnabled]) {
            [[EspRenderView sharedInstance] stopRendering];
        }
    }
}

+ (void)toggleEsp {
    [self setEspEnabled:![self isEspEnabled]];
}

#pragma mark - ESP Features
+ (BOOL)isEspBoxEnabled {
    return [Vars espBoxEnabled];
}

+ (void)setEspBoxEnabled:(BOOL)enabled {
    [Vars setEspBoxEnabled:enabled];
    [[EspRenderView sharedInstance] setNeedsDisplay];
}

+ (BOOL)isEspLinesEnabled {
    return [Vars espLinesEnabled];
}

+ (void)setEspLinesEnabled:(BOOL)enabled {
    [Vars setEspLinesEnabled:enabled];
    [[EspRenderView sharedInstance] setNeedsDisplay];
}

+ (BOOL)isEspSkeletonEnabled {
    return [Vars espSkeletonEnabled];
}

+ (void)setEspSkeletonEnabled:(BOOL)enabled {
    [Vars setEspSkeletonEnabled:enabled];
    [[EspRenderView sharedInstance] setNeedsDisplay];
}

+ (BOOL)isEspCircleEnabled {
    return [Vars espCircleEnabled];
}

+ (void)setEspCircleEnabled:(BOOL)enabled {
    [Vars setEspCircleEnabled:enabled];
    [[EspRenderView sharedInstance] setNeedsDisplay];
}

+ (BOOL)isEspOOFEnabled {
    return [Vars espOOFEnabled];
}

+ (void)setEspOOFEnabled:(BOOL)enabled {
    [Vars setEspOOFEnabled:enabled];
    [[EspRenderView sharedInstance] setNeedsDisplay];
}

+ (BOOL)isEspShowInfoEnabled {
    return [Vars espShowInfoEnabled];
}

+ (void)setEspShowInfoEnabled:(BOOL)enabled {
    [Vars setEspShowInfoEnabled:enabled];
    [[EspRenderView sharedInstance] setNeedsDisplay];
}

+ (BOOL)isEspEnemyCountEnabled {
    return [Vars espEnemyCountEnabled];
}

+ (void)setEspEnemyCountEnabled:(BOOL)enabled {
    [Vars setEspEnemyCountEnabled:enabled];
    [[EspRenderView sharedInstance] setNeedsDisplay];
}

+ (BOOL)isEspEnemyWarningEnabled {
    return [Vars espEnemyWarningEnabled];
}

+ (void)setEspEnemyWarningEnabled:(BOOL)enabled {
    [Vars setEspEnemyWarningEnabled:enabled];
    [[EspRenderView sharedInstance] setNeedsDisplay];
}

+ (BOOL)isEspFovEnabled {
    return [Vars espFovEnabled];
}

+ (void)setEspFovEnabled:(BOOL)enabled {
    [Vars setEspFovEnabled:enabled];
    [[EspRenderView sharedInstance] setNeedsDisplay];
}

#pragma mark - ESP Display Options (Legacy support)
+ (BOOL)showBoxes {
    return [Vars showBoxes];
}

+ (void)setShowBoxes:(BOOL)show {
    [Vars setShowBoxes:show];
    [[EspRenderView sharedInstance] setNeedsDisplay];
}

+ (BOOL)showLines {
    return [Vars showLines];
}

+ (void)setShowLines:(BOOL)show {
    [Vars setShowLines:show];
    [[EspRenderView sharedInstance] setNeedsDisplay];
}

+ (BOOL)showDistance {
    return [Vars showDistance];
}

+ (void)setShowDistance:(BOOL)show {
    [Vars setShowDistance:show];
    [[EspRenderView sharedInstance] setNeedsDisplay];
}

+ (BOOL)showHealth {
    return [Vars showHealth];
}

+ (void)setShowHealth:(BOOL)show {
    [Vars setShowHealth:show];
    [[EspRenderView sharedInstance] setNeedsDisplay];
}

+ (BOOL)showSnaplines {
    return [Vars showSnaplines];
}

+ (void)setShowSnaplines:(BOOL)show {
    [Vars setShowSnaplines:show];
    [[EspRenderView sharedInstance] setNeedsDisplay];
}

#pragma mark - Aimbot Methods
+ (BOOL)isAimbotEnabled {
    return [Vars aimbotEnabled];
}

+ (void)setAimbotEnabled:(BOOL)enabled {
    [Vars setAimbotEnabled:enabled];
    if (enabled) {
        [[EspRenderView sharedInstance] startRendering];
    } else {
        if (![self isEspEnabled]) {
            [[EspRenderView sharedInstance] stopRendering];
        }
    }
}

+ (void)toggleAimbot {
    [self setAimbotEnabled:![self isAimbotEnabled]];
}

+ (BOOL)isSilentAimEnabled {
    return [Vars silentAimEnabled];
}

+ (void)setSilentAimEnabled:(BOOL)enabled {
    [Vars setSilentAimEnabled:enabled];
    [[EspRenderView sharedInstance] setNeedsDisplay];
}

+ (BOOL)isAimbotVisibleCheck {
    return [Vars aimbotVisibleCheck];
}

+ (void)setAimbotVisibleCheck:(BOOL)enabled {
    [Vars setAimbotVisibleCheck:enabled];
    [[EspRenderView sharedInstance] setNeedsDisplay];
}

+ (BOOL)isAimbotFovEnabled {
    return [Vars aimbotFovEnabled];
}

+ (void)setAimbotFovEnabled:(BOOL)enabled {
    [Vars setAimbotFovEnabled:enabled];
    [[EspRenderView sharedInstance] setNeedsDisplay];
}

#pragma mark - Aimbot Settings
+ (float)aimbotFov {
    return [Vars aimbotFov];
}

+ (void)setAimbotFov:(float)fov {
    [Vars setAimbotFov:fov];
}

+ (float)aimbotSmooth {
    return [Vars aimbotSmooth];
}

+ (void)setAimbotSmooth:(float)smooth {
    [Vars setAimbotSmooth:smooth];
}

+ (int)aimbotBone {
    return [Vars aimbotBone];
}

+ (void)setAimbotBone:(int)bone {
    [Vars setAimbotBone:bone];
}

#pragma mark - Rendering Methods
+ (void)renderESP {
    if (![self isEspEnabled]) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return;
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    // Render based on enabled features
    if ([Vars espBoxEnabled]) {
        [self drawBoxes:context screenWidth:screenWidth screenHeight:screenHeight];
    }
    
    if ([Vars espLinesEnabled]) {
        [self drawLines:context screenWidth:screenWidth screenHeight:screenHeight];
    }
    
    if ([Vars espSkeletonEnabled]) {
        [self drawSkeleton:context screenWidth:screenWidth screenHeight:screenHeight];
    }
    
    if ([Vars espCircleEnabled]) {
        [self drawCircle:context screenWidth:screenWidth screenHeight:screenHeight];
    }
    
    if ([Vars espOOFEnabled]) {
        [self drawOOF:context screenWidth:screenWidth screenHeight:screenHeight];
    }
    
    if ([Vars espShowInfoEnabled]) {
        [self drawInfo:context screenWidth:screenWidth screenHeight:screenHeight];
    }
    
    if ([Vars espEnemyCountEnabled]) {
        [self drawEnemyCount:context screenWidth:screenWidth screenHeight:screenHeight];
    }
    
    if ([Vars espEnemyWarningEnabled]) {
        [self drawEnemyWarning:context screenWidth:screenWidth screenHeight:screenHeight];
    }
}

+ (void)renderAimbot {
    if (![self isAimbotEnabled]) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return;
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    if ([Vars aimbotFovEnabled]) {
        float fov = [Vars aimbotFov];
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextSetLineWidth(context, 1.0);
        CGContextAddEllipseInRect(context, CGRectMake(screenWidth/2 - fov, screenHeight/2 - fov, fov * 2, fov * 2));
        CGContextStrokePath(context);
    }
    
    // Draw crosshair
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, screenWidth/2 - 10, screenHeight/2);
    CGContextAddLineToPoint(context, screenWidth/2 + 10, screenHeight/2);
    CGContextMoveToPoint(context, screenWidth/2, screenHeight/2 - 10);
    CGContextAddLineToPoint(context, screenWidth/2, screenHeight/2 + 10);
    CGContextStrokePath(context);
}

+ (void)updateESP {
    [[EspRenderView sharedInstance] setNeedsDisplay];
}

+ (void)updateAimbot {
    [[EspRenderView sharedInstance] setNeedsDisplay];
}

#pragma mark - ESP Drawing Helpers
+ (void)drawBoxes:(CGContextRef)context screenWidth:(CGFloat)width screenHeight:(CGFloat)height {
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    // Draw player boxes
    CGRect boxRect = CGRectMake(width/2 - 50, height/2 - 100, 100, 200);
    CGContextStrokeRect(context, boxRect);
}

+ (void)drawLines:(CGContextRef)context screenWidth:(CGFloat)width screenHeight:(CGFloat)height {
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    // Draw lines to enemies
    CGContextMoveToPoint(context, width/2, height/2);
    CGContextAddLineToPoint(context, width/2 + 100, height/2 - 50);
    CGContextStrokePath(context);
}

+ (void)drawSkeleton:(CGContextRef)context screenWidth:(CGFloat)width screenHeight:(CGFloat)height {
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextSetLineWidth(context, 1.5);
    // Draw skeleton
    CGContextMoveToPoint(context, width/2 - 20, height/2 - 100);
    CGContextAddLineToPoint(context, width/2, height/2 - 50);
    CGContextAddLineToPoint(context, width/2 + 20, height/2 - 100);
    CGContextStrokePath(context);
}

+ (void)drawCircle:(CGContextRef)context screenWidth:(CGFloat)width screenHeight:(CGFloat)height {
    CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextAddEllipseInRect(context, CGRectMake(width/2 - 50, height/2 - 50, 100, 100));
    CGContextStrokePath(context);
}

+ (void)drawOOF:(CGContextRef)context screenWidth:(CGFloat)width screenHeight:(CGFloat)height {
    // Draw OOF indicator
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(width - 50, 50, 20, 20));
}

+ (void)drawInfo:(CGContextRef)context screenWidth:(CGFloat)width screenHeight:(CGFloat)height {
    // Draw info text
    NSString *info = @"Players: 10 | Team: 5";
    [info drawAtPoint:CGPointMake(10, 10) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

+ (void)drawEnemyCount:(CGContextRef)context screenWidth:(CGFloat)width screenHeight:(CGFloat)height {
    // Draw enemy count
    NSString *enemyCount = @"Enemies: 5";
    [enemyCount drawAtPoint:CGPointMake(10, 30) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor redColor]}];
}

+ (void)drawEnemyWarning:(CGContextRef)context screenWidth:(CGFloat)width screenHeight:(CGFloat)height {
    // Draw enemy warning
    NSString *warning = @"⚠ ENEMY SPOTTED!";
    [warning drawAtPoint:CGPointMake(width/2 - 80, 50) withAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName: [UIColor redColor]}];
}

#pragma mark - Utility Methods
+ (void)showOverlay {
    [[EspRenderView sharedInstance] setHidden:NO];
    [[EspRenderView sharedInstance] startRendering];
}

+ (void)hideOverlay {
    [[EspRenderView sharedInstance] setHidden:YES];
    [[EspRenderView sharedInstance] stopRendering];
}

+ (void)resetAllSettings {
    [[self sharedManager] setupDefaults];
    [[EspRenderView sharedInstance] stopRendering];
    [[EspRenderView sharedInstance] setHidden:YES];
}

#pragma mark - Debug Methods
+ (void)logStatus {
    NSLog(@"=== ESP/Aimbot Status ===");
    NSLog(@"Game Connected: %@", [self isGameConnected] ? @"YES" : @"NO");
    NSLog(@"ESP Enabled: %@", [self isEspEnabled] ? @"YES" : @"NO");
    NSLog(@"Aimbot Enabled: %@", [self isAimbotEnabled] ? @"YES" : @"NO");
    NSLog(@"ESP Box: %@", [self isEspBoxEnabled] ? @"YES" : @"NO");
    NSLog(@"ESP Lines: %@", [self isEspLinesEnabled] ? @"YES" : @"NO");
    NSLog(@"ESP Skeleton: %@", [self isEspSkeletonEnabled] ? @"YES" : @"NO");
    NSLog(@"ESP Circle: %@", [self isEspCircleEnabled] ? @"YES" : @"NO");
    NSLog(@"ESP OOF: %@", [self isEspOOFEnabled] ? @"YES" : @"NO");
    NSLog(@"ESP Show Info: %@", [self isEspShowInfoEnabled] ? @"YES" : @"NO");
    NSLog(@"ESP Enemy Count: %@", [self isEspEnemyCountEnabled] ? @"YES" : @"NO");
    NSLog(@"ESP Enemy Warning: %@", [self isEspEnemyWarningEnabled] ? @"YES" : @"NO");
    NSLog(@"Silent Aim: %@", [self isSilentAimEnabled] ? @"YES" : @"NO");
    NSLog(@"Aimbot Visible Check: %@", [self isAimbotVisibleCheck] ? @"YES" : @"NO");
    NSLog(@"Aimbot FOV: %.1f", [self aimbotFov]);
    NSLog(@"Aimbot Smooth: %.1f", [self aimbotSmooth]);
    NSLog(@"Aimbot Bone: %d", [self aimbotBone]);
    NSLog(@"=======================");
}

@end
