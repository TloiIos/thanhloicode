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

+ (GameState)gameState { return _gameState; }
+ (void)setGameState:(GameState)state { _gameState = state; }

+ (BOOL)espEnabled { return _espEnabled; }
+ (void)setEspEnabled:(BOOL)enabled { _espEnabled = enabled; }

+ (BOOL)aimbotEnabled { return _aimbotEnabled; }
+ (void)setAimbotEnabled:(BOOL)enabled { _aimbotEnabled = enabled; }

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

+ (float)aimbotFov { return _aimbotFov; }
+ (void)setAimbotFov:(float)fov { _aimbotFov = fov; }

+ (float)aimbotSmooth { return _aimbotSmooth; }
+ (void)setAimbotSmooth:(float)smooth { _aimbotSmooth = smooth; }

+ (int)aimbotBone { return _aimbotBone; }
+ (void)setAimbotBone:(int)bone { _aimbotBone = bone; }
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
    // Set default values
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
        // Check if aimbot is also disabled before stopping rendering
        if (![self isAimbotEnabled]) {
            [[EspRenderView sharedInstance] stopRendering];
        }
    }
}

+ (void)toggleEsp {
    [self setEspEnabled:![self isEspEnabled]];
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
        // Check if ESP is also disabled before stopping rendering
        if (![self isEspEnabled]) {
            [[EspRenderView sharedInstance] stopRendering];
        }
    }
}

+ (void)toggleAimbot {
    [self setAimbotEnabled:![self isAimbotEnabled]];
}

#pragma mark - ESP Options
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
    
    // Get screen dimensions
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    // Set rendering styles
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    
    // Draw boxes around players
    if ([Vars showBoxes]) {
        // Example: Draw a simple box in the center of screen
        CGRect boxRect = CGRectMake(screenWidth/2 - 50, screenHeight/2 - 100, 100, 200);
        CGContextStrokeRect(context, boxRect);
        
        // Add more player boxes here based on actual game data
        // This would require hooking into the game's memory
    }
    
    // Draw snaplines
    if ([Vars showSnaplines]) {
        CGContextMoveToPoint(context, screenWidth/2, 0);
        CGContextAddLineToPoint(context, screenWidth/2, screenHeight);
        CGContextStrokePath(context);
    }
}

+ (void)renderAimbot {
    if (![self isAimbotEnabled]) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return;
    
    // Get screen dimensions
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    // Draw aimbot FOV circle
    float fov = [Vars aimbotFov];
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextAddEllipseInRect(context, CGRectMake(screenWidth/2 - fov, screenHeight/2 - fov, fov * 2, fov * 2));
    CGContextStrokePath(context);
    
    // Draw crosshair
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, screenWidth/2 - 10, screenHeight/2);
    CGContextAddLineToPoint(context, screenWidth/2 + 10, screenHeight/2);
    CGContextMoveToPoint(context, screenWidth/2, screenHeight/2 - 10);
    CGContextAddLineToPoint(context, screenWidth/2, screenHeight/2 + 10);
    CGContextStrokePath(context);
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
    NSLog(@"Show Boxes: %@", [self showBoxes] ? @"YES" : @"NO");
    NSLog(@"Show Lines: %@", [self showLines] ? @"YES" : @"NO");
    NSLog(@"Show Distance: %@", [self showDistance] ? @"YES" : @"NO");
    NSLog(@"Show Health: %@", [self showHealth] ? @"YES" : @"NO");
    NSLog(@"Show Snaplines: %@", [self showSnaplines] ? @"YES" : @"NO");
    NSLog(@"Aimbot FOV: %.1f", [self aimbotFov]);
    NSLog(@"Aimbot Smooth: %.1f", [self aimbotSmooth]);
    NSLog(@"Aimbot Bone: %d", [self aimbotBone]);
    NSLog(@"=======================");
}

@end
