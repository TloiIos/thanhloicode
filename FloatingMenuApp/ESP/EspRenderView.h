// EspRenderView.h
#import <UIKit/UIKit.h>

@interface EspRenderView : UIWindow  // Change from UIView to UIWindow

+ (instancetype)sharedInstance;
- (void)startRendering;
- (void)stopRendering;

@end
