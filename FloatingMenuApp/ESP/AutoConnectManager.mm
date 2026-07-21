#import "AutoConnectManager.h"
#import <mach/mach.h>
#import <dlfcn.h>
#include <sys/sysctl.h>
#include <libproc.h>
#include <unistd.h>

@implementation AutoConnectManager {
    NSTimer *_monitorTimer;
    BOOL _isMonitoring;
}

+ (instancetype)sharedInstance {
    static AutoConnectManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AutoConnectManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isConnected = NO;
        _isMonitoring = NO;
        _gameProcessName = @"";
    }
    return self;
}

- (void)startMonitoringGame {
    if (_isMonitoring) return;
    _isMonitoring = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (self->_isMonitoring) {
            [self findGameProcess];
            [NSThread sleepForTimeInterval:1.0];
        }
    });
}

- (void)stopMonitoringGame {
    _isMonitoring = NO;
    if (_monitorTimer) {
        [_monitorTimer invalidate];
        _monitorTimer = nil;
    }
}

- (void)findGameProcess {
    // Tìm process của Free Fire
    pid_t pids[1024];
    int numPids = proc_listpids(PROC_ALL_PIDS, 0, pids, sizeof(pids));
    
    if (numPids <= 0) return;
    
    int numProcesses = numPids / sizeof(pid_t);
    
    for (int i = 0; i < numProcesses; i++) {
        if (pids[i] == 0) continue;
        
        char pathBuffer[PROC_PIDPATHINFO_MAXSIZE];
        int pathLength = proc_pidpath(pids[i], pathBuffer, sizeof(pathBuffer));
        
        if (pathLength <= 0) continue;
        
        NSString *path = [NSString stringWithUTF8String:pathBuffer];
        NSString *processName = [path lastPathComponent];
        
        // Kiểm tra tên process của Free Fire
        if ([processName containsString:@"FreeFire"] ||
            [processName containsString:@"garena"] ||
            [processName containsString:@"com.dts.freefireth"]) {
            
            if (!_isConnected) {
                _isConnected = YES;
                _gameProcessName = processName;
                NSLog(@"✅ Found Free Fire process: %@ (PID: %d)", processName, pids[i]);
                [self attachToGame];
            }
        }
    }
}

- (void)attachToGame {
    // Kết nối vào game
    NSLog(@"🔗 Attaching to Free Fire...");
    
    // Khởi tạo game SDK
    // game_sdk->init();
    
    // Bật ESP tự động
    // Vars.Enable = true;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GameConnectedNotification" object:nil];
    });
}

- (BOOL)isGameRunning {
    return _isConnected;
}

- (BOOL)isConnectedToGame {
    return _isConnected;
}

@end
