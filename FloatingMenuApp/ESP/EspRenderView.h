// EspRenderView.h
#import <UIKit/UIKit.h>

@interface EspRenderView : UIView

+ (instancetype)sharedInstance;
- (void)startRendering;
- (void)stopRendering;

@end
