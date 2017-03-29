//
//  SearchResultViewController.m
//  Chat
//
//  Created by LI on 2017/3/29.
//  Copyright © 2017年 LI. All rights reserved.
//

#import "SearchResultViewController.h"
#import "ContactModel.h"

@interface SearchResultViewController ()
@property (nonatomic, strong) NSArray *resultArray;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = [searchText copy];
    
    searchText = searchText.lowercaseString;
    // 谓词\过滤器:能利用一定的条件从一个数组中过滤出想要的数据
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@", searchText, searchText, searchText];
//    self.resultArray = [[MTMetaTool cities] filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
//    cell.textLabel.text = city.name;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"共有%ld个搜索结果", self.resultArray.count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MTCity *city = self.resultCities[indexPath.row];
    // 发出通知
//    [MTNotificationCenter postNotificationName:MTCityDidChangeNotification object:nil userInfo:@{MTSelectCityName : city.name}];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
