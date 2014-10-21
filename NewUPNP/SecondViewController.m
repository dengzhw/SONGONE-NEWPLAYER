//
//  SecondViewController.m
//  NewUPNP
//
//  Created by mac on 14-10-17.
//  Copyright (c) 2014年 deng.com. All rights reserved.
//

#import "SecondViewController.h"
#import "SOAudio.h"
#import "LocalIpodAudio.h"
#import "SO_PlayerService.h"
#import "SO_Player.h"

@interface SecondViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView* tableview;
    NSArray* audiolist;
    SO_PlayerService* playservice;
    float currentvolume;
}

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

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

    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, 320, 480) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    //+ (NSArray*)getAllCollection
    audiolist = [LocalIpodAudio getAllCollection];
    [self.view addSubview:tableview];

    // Do any additional setup after loading the view.
}

- (void)getVolumeButtonClick:(id)sender
{
    currentvolume = [[SO_PlayerService shareInstance].currentPlayer volume];
}

- (void)addVolumButtonClick:(id)sender
{
    [[SO_PlayerService shareInstance].currentPlayer setVolume:(currentvolume + 0.1)];
}
- (void)subVolumButtonClick:(id)sender
{
    [[SO_PlayerService shareInstance].currentPlayer setVolume:(currentvolume - 0.1)];
}

- (void)stopMusicButtonClick:(id)sender
{
    [[SO_PlayerService shareInstance].currentPlayer pause];
}
- (void)playStateButtonClick:(id)sender
{
    [[SO_PlayerService shareInstance].currentPlayer getTransportState];
}

- (void)PositionMusicButtonClick:(id)sender
{
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return audiolist.count;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellID = @"secondCellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    SOAudio* audio = [audiolist objectAtIndex:indexPath.row];
    cell.textLabel.text = audio.title;
    cell.detailTextLabel.text = audio.artist;
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    playservice = [SO_PlayerService shareInstance];
    [playservice.currentPlayer setPlayAudioList:audiolist];
    [playservice.currentPlayer setPlayCurrentAudio:[audiolist objectAtIndex:indexPath.row]];
    [playservice.currentPlayer play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
