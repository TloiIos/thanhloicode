#import "AutoConnectManager.h"
#import <mach/mach.h>
#import <dlfcn.h>
#include <sys/sysctl.h>
#include <unistd.h>
#include <string.h>

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
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t size = 0;
    
    if (sysctl(mib, 4, NULL, &size, NULL, 0) < 0) {
        return;
    }
    
    struct kinfo_proc *procs = (struct kinfo_proc *)malloc(size);
    if (!procs) return;
    
    if (sysctl(mib, 4, procs, &size, NULL, 0) < 0) {
        free(procs);
        return;
    }
    
    // Sửa warning: cast size_t sang int
    int count = (int)(size / sizeof(struct kinfo_proc));
    
    for (int i = 0; i < count; i++) {
        struct kinfo_proc *proc = &procs[i];
        NSString *processName = [NSString stringWithUTF8String:proc->kp_proc.p_comm];
        
        if ([processName containsString:@"FreeFire"] ||
            [processName containsString:@"garena"] ||
            [processName containsString:@"com.dts.freefireth"] ||
            [processName containsString:@"FreeFire"] ||
            [processName containsString:@"Garena"]) {
            
            if (!_isConnected) {
                _isConnected = YES;
                _gameProcessName = processName;
                NSLog(@"✅ Found Free Fire process: %@ (PID: %d)", processName, proc->kp_proc.p_pid);
                [self attachToGame];
            }
            break;
        }
    }
    
    free(procs);
}

- (void)attachToGame {
    NSLog(@"🔗 Attaching to Free Fire...");
    
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
