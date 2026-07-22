
#import "EspRenderView.h"
#import "EspManager.h"
#import <QuartzCore/QuartzCore.h>

@interface EspRenderView () {
    CADisplayLink *_displayLink;
    BOOL _isRendering;
}
@end

@implementation EspRenderView

+ (instancetype)sharedInstance {
    static EspRenderView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[EspRenderView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.windowLevel = UIWindowLevelStatusBar + 2;
        [self startRendering];
    }
    return self;
}

- (void)startRendering {
    if (_displayLink) return;
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(renderLoop)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _isRendering = YES;
}

- (void)stopRendering {
    [_displayLink invalidate];
    _displayLink = nil;
    _isRendering = NO;
}

- (void)renderLoop {
    if (![EspManager isEspEnabled] && ![EspManager isAimbotEnabled]) {
        if (_isRendering) {
            self.hidden = YES;
        }
        return;
    }
    self.hidden = NO;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if ([EspManager isEspEnabled]) [EspManager renderESP];
    if ([EspManager isAimbotEnabled]) [EspManager renderAimbot];
}

@end

