//
//  LiveShowListViewController.m
//  CYLiveShowDemo
//
//  Created by Peter Lee on 16/8/20.
//  Copyright © 2016年 CY.Lee. All rights reserved.
//

#import "LiveShowListViewController.h"
#import <AFNetworking.h>
#import "LiveShowPlayViewController.h"

static const NSString *queryLiveListUrl = @"http://service.ingkee.com/api/live/gettop?imsi=&uid=17800399&proto=5&idfa=A1205EB8-0C9A-4131-A2A2-27B9A1E06622&lc=0000000000000026&cc=TG0001&imei=&sid=20i0a3GAvc8ykfClKMAen8WNeIBKrUwgdG9whVJ0ljXi1Af8hQci3&cv=IK3.1.00_Iphone&devi=bcb94097c7a3f3314be284c8a5be2aaeae66d6ab&conn=Wifi&ua=iPhone&idfv=DEBAD23B-7C6A-4251-B8AF-A95910B778B7&osversion=ios_9.300000&count=5&multiaddr=1";

@interface LiveShowListViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation LiveShowListViewController

#pragma mark - lazy load
- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[];
    }
    return _dataArray;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"映客直播列表";
    [self loadLiveShowList];
}

#pragma mark - network method
- (void)loadLiveShowList{
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [sessionManager GET:queryLiveListUrl parameters:@{@"format":@"json"} progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSArray *liveShowArray = responseDict[@"lives"];
        if (liveShowArray&&liveShowArray.count>0) {
            self.dataArray = liveShowArray;
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row][@"creator"][@"nick"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveShowPlayViewController *ctrl = [[LiveShowPlayViewController alloc]initWithLiveShowUrl:self.dataArray[indexPath.row][@"stream_addr"]];
    [self.navigationController pushViewController:ctrl animated:YES];
}


@end
