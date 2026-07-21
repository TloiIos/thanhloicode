
#import "EspRenderView.h"
#import "EspManager.h"
#import <QuartzCore/QuartzCore.h>

@interface EspRenderView () {
    CADisplayLink *_displayLink;
}
@end

@implementation EspRenderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        [self startRendering];
    }
    return self;
}

- (void)startRendering {
    if (_displayLink) return;
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(renderLoop)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopRendering {
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)renderLoop {
    if (![EspManager isEspEnabled] && ![EspManager isAimbotEnabled]) return;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if ([EspManager isEspEnabled]) [EspManager renderESP];
    if ([EspManager isAimbotEnabled]) [EspManager renderAimbot];
}

@end
