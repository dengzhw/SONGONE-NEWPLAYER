//
//  XFRootViewController.m
//  XFUpnpScan-xcode5
//
//  Created by qisheng on 14-10-12.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import "RootViewController.h"
#import "SSDPDeviceSearch.h"
#import "upnpDeviceManager.h"
#import "DeviceRender.h"
#import "DeviceService.h"
#import "RemotePlay.h"
#import "RemoteServer.h"
#import "PositionInfo.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation RootViewController {
    SSDPDeviceSearch* ssdp;
    UITableView* deviceListView;
    NSMutableArray* tableServiceData;
    NSMutableArray* tableRenderData;
    RemotePlay* remoteplay;
    RemoteServer* remoteserver;
    float currentvolume;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    ssdp = [SSDPDeviceSearch shareDistance];
    [ssdp startSSDP];
    currentvolume = 0;
    UIButton* stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    stopButton.frame = CGRectMake(0, 20, 60, 44);
    [stopButton setTitle:@"Clear" forState:UIControlStateNormal];
    [stopButton addTarget:self action:@selector(stopScanDevice:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];

    UIButton* startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    startButton.frame = CGRectMake(80, 20, 60, 44);
    [startButton setTitle:@"Start" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startScanDevice:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];

    UIButton* refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
    refreshButton.frame = CGRectMake(160, 20, 60, 44);
    [refreshButton setTitle:@"refresh" forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshButton];

    UIButton* stopMusicButton = [UIButton buttonWithType:UIButtonTypeSystem];
    stopMusicButton.frame = CGRectMake(220, 20, 60, 44);
    [stopMusicButton setTitle:@"stop" forState:UIControlStateNormal];
    [stopMusicButton addTarget:self action:@selector(stopMusicButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopMusicButton];

    UIButton* positionMusicButton = [UIButton buttonWithType:UIButtonTypeSystem];
    positionMusicButton.frame = CGRectMake(280, 20, 60, 44);
    [positionMusicButton setTitle:@"position" forState:UIControlStateNormal];
    [positionMusicButton addTarget:self action:@selector(PositionMusicButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:positionMusicButton];

    UIButton* playStateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    playStateButton.frame = CGRectMake(0, 70, 60, 44);
    [playStateButton setTitle:@"PlayStat" forState:UIControlStateNormal];
    [playStateButton addTarget:self action:@selector(playStateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playStateButton];

    UIButton* getVolumButton = [UIButton buttonWithType:UIButtonTypeSystem];
    getVolumButton.frame = CGRectMake(70, 70, 60, 44);
    [getVolumButton setTitle:@"getVolume" forState:UIControlStateNormal];
    [getVolumButton addTarget:self action:@selector(getVolumeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getVolumButton];

    UIButton* addVolumButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addVolumButton.frame = CGRectMake(140, 70, 60, 44);
    [addVolumButton setTitle:@"add" forState:UIControlStateNormal];
    [addVolumButton addTarget:self action:@selector(addVolumButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addVolumButton];

    UIButton* subVolumButton = [UIButton buttonWithType:UIButtonTypeSystem];
    subVolumButton.frame = CGRectMake(210, 70, 60, 44);
    [subVolumButton setTitle:@"sub" forState:UIControlStateNormal];
    [subVolumButton addTarget:self action:@selector(subVolumButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:subVolumButton];

    deviceListView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, 320, 480)];
    deviceListView.delegate = self;
    deviceListView.dataSource = self;
    [self.view addSubview:deviceListView];
}
- (void)getVolumeButtonClick:(id)sender
{
    currentvolume = [remoteplay VolumeInfo];
}

- (void)addVolumButtonClick:(id)sender
{
    [remoteplay setVolume:(currentvolume + 0.1)];
}
- (void)subVolumButtonClick:(id)sender
{
    [remoteplay setVolume:(currentvolume - 0.1)];
}

- (void)stopMusicButtonClick:(id)sender
{
    [remoteplay pause];
}
- (void)playStateButtonClick:(id)sender
{
    [remoteplay getTransportState];
}

- (void)PositionMusicButtonClick:(id)sender
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
           PositionInfo  *position= [remoteplay GetPosition];
            NSLog(@"reltime%@ , tacktime %@",position.reltime,position.tracktime);
            sleep(1);
        }
    });
}

- (void)stopScanDevice:(id)sender
{
    [ssdp clearSSDP];
}
- (void)startScanDevice:(id)sender
{
    [ssdp startSSDP];
}
- (void)refreshTableView:(id)sender
{
    upnpDeviceManager* upnpDeviceList = [upnpDeviceManager sharedInstance];
    [tableRenderData removeAllObjects];
    [tableServiceData removeAllObjects];
    tableRenderData = [[NSMutableArray alloc] initWithArray:upnpDeviceList.renderList];
    tableServiceData = [[NSMutableArray alloc] initWithArray:upnpDeviceList.serviceList];
    [deviceListView reloadData];
}

#pragma mark--
#pragma mark-- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return tableRenderData.count;
    } else {
        return tableServiceData.count;
    }
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    if (indexPath.section == 0) {
        DeviceRender* render = tableRenderData[indexPath.row];
        cell.textLabel.text = render.friendlyName;
        cell.detailTextLabel.text = render.udn;
    }
    if (indexPath.section == 1) {
        DeviceService* servcie = tableServiceData[indexPath.row];
        cell.textLabel.text = servcie.friendlyName;
        cell.detailTextLabel.text = servcie.udn;
    }
    return cell;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"MR List";
    } else {
        return @"MS List";
    }
}
- (NSString*)tableView:(UITableView*)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return @"结束";
    }
    return nil;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        DeviceRender* render = tableRenderData[indexPath.row];
        remoteplay = [[RemotePlay alloc] initWithRender:render];
        [remoteplay play];
    }

    if (indexPath.section == 1) {
        DeviceService* service = (DeviceService*)tableServiceData[indexPath.row];
        remoteserver = [[RemoteServer alloc] initWithServer:service];
        [remoteserver browseDirectChildren:@"2" requestedCount:0 requestedStartIndex:0];
    }
}
@end
