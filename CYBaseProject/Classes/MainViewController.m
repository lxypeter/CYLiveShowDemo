//
//  MainViewController.m
//  CYLiveShowDemo
//
//  Created by Peter Lee on 16/8/19.
//  Copyright © 2016年 CY.Lee. All rights reserved.
//

#import "MainViewController.h"
#import "LiveShowPushViewController.h"
#import "LiveShowListViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) NSArray *optionArray;

@end

@implementation MainViewController

- (NSArray *)optionArray{
    if (!_optionArray) {
        _optionArray = @[@"开始直播", @"观看直播"];
    }
    return _optionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = self.optionArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        LiveShowPushViewController *ctrl = [[LiveShowPushViewController alloc]init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else{
        LiveShowListViewController *ctrl = [[LiveShowListViewController alloc]init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

@end
