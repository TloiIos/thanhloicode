#ifndef AUTO_CONNECT_MANAGER_H
#define AUTO_CONNECT_MANAGER_H

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AutoConnectManager : NSObject

+ (instancetype)sharedInstance;

// Auto connect to game
- (void)startMonitoringGame;
- (void)stopMonitoringGame;
- (BOOL)isGameRunning;
- (BOOL)isConnectedToGame;

// Process detection
- (void)findGameProcess;
- (void)attachToGame;

// Status
@property (nonatomic, assign) BOOL isConnected;
@property (nonatomic, strong) NSString *gameProcessName;

@end

#endif
