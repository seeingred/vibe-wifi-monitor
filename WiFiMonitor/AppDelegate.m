//
//  AppDelegate.m
//  WiFiMonitor
//
//  Created by aka on 8/15/25.
//

#import "AppDelegate.h"
#import <CoreWLAN/CoreWLAN.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate () <CLLocationManagerDelegate>
@property (strong) NSWindow *window;
@property (strong) CWInterface *wifiInterface;
@property (strong) NSTimer *updateTimer;
@property (strong) NSTextField *ssidLabel;
@property (strong) NSTextField *signalLabel;
@property (strong) NSTextField *percentLabel;
@property (strong) NSTextField *qualityLabel;
@property (strong) NSLevelIndicator *signalLevel;
@property (strong) CLLocationManager *locationManager;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Запрашиваем разрешение на геолокацию для доступа к SSID
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
    
    self.wifiInterface = [CWWiFiClient sharedWiFiClient].interface;
    [self setupWindow];
    [self startMonitoring];
}

- (void)setupWindow {
    NSRect frame = NSMakeRect(0, 0, 450, 550);
    NSUInteger style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable;
    
    self.window = [[NSWindow alloc] initWithContentRect:frame
                                               styleMask:style
                                                 backing:NSBackingStoreBuffered
                                                   defer:NO];
    
    [self.window setTitle:NSLocalizedString(@"app.title", @"App title")];
    [self.window center];
    
    NSView *contentView = [self.window contentView];
    contentView.wantsLayer = YES;
    contentView.layer.backgroundColor = [[NSColor colorWithWhite:0.15 alpha:1.0] CGColor];
    
    NSTextField *title = [[NSTextField alloc] initWithFrame:NSMakeRect(75, 470, 300, 40)];
    [title setStringValue:NSLocalizedString(@"app.title", @"App title")];
    [title setBezeled:NO];
    [title setDrawsBackground:NO];
    [title setEditable:NO];
    [title setFont:[NSFont systemFontOfSize:26 weight:NSFontWeightBold]];
    [title setTextColor:[NSColor whiteColor]];
    [title setAlignment:NSTextAlignmentCenter];
    [contentView addSubview:title];
    
    self.ssidLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(75, 420, 300, 30)];
    [self.ssidLabel setStringValue:NSLocalizedString(@"network.searching", @"Searching for network")];
    [self.ssidLabel setBezeled:NO];
    [self.ssidLabel setDrawsBackground:NO];
    [self.ssidLabel setEditable:NO];
    [self.ssidLabel setFont:[NSFont systemFontOfSize:20]];
    [self.ssidLabel setTextColor:[NSColor colorWithWhite:0.6 alpha:1.0]];
    [self.ssidLabel setAlignment:NSTextAlignmentCenter];
    [contentView addSubview:self.ssidLabel];
    
    self.percentLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(75, 280, 300, 120)];
    [self.percentLabel setStringValue:@"0%"];
    [self.percentLabel setBezeled:NO];
    [self.percentLabel setDrawsBackground:NO];
    [self.percentLabel setEditable:NO];
    [self.percentLabel setFont:[NSFont systemFontOfSize:80 weight:NSFontWeightBold]];
    [self.percentLabel setTextColor:[NSColor whiteColor]];
    [self.percentLabel setAlignment:NSTextAlignmentCenter];
    [contentView addSubview:self.percentLabel];
    
    self.signalLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(75, 250, 300, 25)];
    [self.signalLabel setStringValue:NSLocalizedString(@"signal.label", @"Signal label")];
    [self.signalLabel setBezeled:NO];
    [self.signalLabel setDrawsBackground:NO];
    [self.signalLabel setEditable:NO];
    [self.signalLabel setFont:[NSFont systemFontOfSize:16]];
    [self.signalLabel setTextColor:[NSColor colorWithWhite:0.6 alpha:1.0]];
    [self.signalLabel setAlignment:NSTextAlignmentCenter];
    [contentView addSubview:self.signalLabel];
    
    self.qualityLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(75, 200, 300, 35)];
    [self.qualityLabel setStringValue:NSLocalizedString(@"quality.unknown", @"No data")];
    [self.qualityLabel setBezeled:NO];
    [self.qualityLabel setDrawsBackground:NO];
    [self.qualityLabel setEditable:NO];
    [self.qualityLabel setFont:[NSFont systemFontOfSize:22 weight:NSFontWeightMedium]];
    [self.qualityLabel setTextColor:[NSColor grayColor]];
    [self.qualityLabel setAlignment:NSTextAlignmentCenter];
    [contentView addSubview:self.qualityLabel];
    
    self.signalLevel = [[NSLevelIndicator alloc] initWithFrame:NSMakeRect(75, 140, 300, 25)];
    [self.signalLevel setLevelIndicatorStyle:NSLevelIndicatorStyleContinuousCapacity];
    [self.signalLevel setMinValue:0];
    [self.signalLevel setMaxValue:100];
    [self.signalLevel setWarningValue:40];
    [self.signalLevel setCriticalValue:20];
    [contentView addSubview:self.signalLevel];
    
    NSTextField *instruction = [[NSTextField alloc] initWithFrame:NSMakeRect(75, 50, 300, 40)];
    [instruction setStringValue:NSLocalizedString(@"instructions.label", @"Instructions")];
    [instruction setBezeled:NO];
    [instruction setDrawsBackground:NO];
    [instruction setEditable:NO];
    [instruction setFont:[NSFont systemFontOfSize:14]];
    [instruction setTextColor:[NSColor colorWithWhite:0.5 alpha:1.0]];
    [instruction setAlignment:NSTextAlignmentCenter];
    [contentView addSubview:instruction];
    
    [self.window makeKeyAndOrderFront:nil];
}

- (void)startMonitoring {
    [self updateWiFiInfo];
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                         target:self
                                                       selector:@selector(updateWiFiInfo)
                                                       userInfo:nil
                                                        repeats:YES];
}

- (void)updateWiFiInfo {
    if (self.wifiInterface) {
        NSString *ssid = self.wifiInterface.ssid;
        NSInteger rssi = self.wifiInterface.rssiValue;
        
        // Если SSID null но есть сигнал, показываем что подключены
        if (!ssid && rssi != 0) {
            // Пробуем получить через конфигурацию
            CWConfiguration *config = self.wifiInterface.configuration;
            if (config && config.networkProfiles.count > 0) {
                CWNetworkProfile *profile = config.networkProfiles.firstObject;
                ssid = profile.ssid;
            }
            
            // Если все еще нет, показываем хотя бы что есть сеть
            if (!ssid) {
                ssid = [NSString stringWithFormat:NSLocalizedString(@"network.connected", @"Connected"), (long)rssi];
            }
        }
        
        NSLog(@"WiFi Debug - Interface: %@, SSID: %@, RSSI: %ld", self.wifiInterface, ssid, (long)rssi);
        
        if (ssid && ssid.length > 0) {
            [self.ssidLabel setStringValue:ssid];
            
            NSInteger percentage = MIN(100, MAX(0, (rssi + 100) * 100 / 70));
            
            [self.percentLabel setStringValue:[NSString stringWithFormat:@"%ld%%", (long)percentage]];
            [self.signalLabel setStringValue:[NSString stringWithFormat:NSLocalizedString(@"signal.label", @"Signal"), (long)rssi]];
            [self.signalLevel setDoubleValue:percentage];
            
            NSString *quality;
            NSColor *color;
            
            if (rssi >= -50) {
                quality = NSLocalizedString(@"quality.excellent", @"Excellent");
                color = [NSColor systemGreenColor];
            } else if (rssi >= -60) {
                quality = NSLocalizedString(@"quality.good", @"Good");
                color = [NSColor colorWithRed:0.6 green:1.0 blue:0.2 alpha:1.0];
            } else if (rssi >= -70) {
                quality = NSLocalizedString(@"quality.fair", @"Fair");
                color = [NSColor systemYellowColor];
            } else if (rssi >= -80) {
                quality = NSLocalizedString(@"quality.weak", @"Weak");
                color = [NSColor systemOrangeColor];
            } else {
                quality = NSLocalizedString(@"quality.veryWeak", @"Very weak");
                color = [NSColor systemRedColor];
            }
            
            [self.qualityLabel setStringValue:quality];
            [self.qualityLabel setTextColor:color];
            [self.percentLabel setTextColor:color];
            
        } else {
            [self.ssidLabel setStringValue:NSLocalizedString(@"network.none", @"No connection")];
            [self.percentLabel setStringValue:@"0%"];
            [self.signalLabel setStringValue:NSLocalizedString(@"signal.label", @"Signal label")];
            [self.qualityLabel setStringValue:NSLocalizedString(@"network.none", @"No connection")];
            [self.qualityLabel setTextColor:[NSColor grayColor]];
            [self.percentLabel setTextColor:[NSColor grayColor]];
            [self.signalLevel setDoubleValue:0];
        }
    }
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [self.updateTimer invalidate];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
