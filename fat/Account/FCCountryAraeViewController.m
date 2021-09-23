//
//  CityViewController.m
//  Meitong
//
//  Created by cts on 17/4/13.
//  Copyright © 2017年 cts. All rights reserved.
//

#import "FCCountryAraeViewController.h"
#import "FCCountryCityModel.h"
#import "BMChineseSort.h"

@interface FCCountryAraeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray * cityDataArr;

//常用
@property (nonatomic,strong)NSMutableArray *adhotArr;

//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;

@end

@implementation FCCountryAraeViewController


-(NSMutableArray *)cityDataArr
{
    if (!_cityDataArr) {
        _cityDataArr = [[NSMutableArray alloc] init];
    }
    return _cityDataArr;
}

-(NSMutableArray *)adhotArr
{
    if (!_adhotArr) {
        _adhotArr = [[NSMutableArray alloc] init];
    }
    return _adhotArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = KKLanguage(@"lab_login_area_title");

    [self loadData];
    
    //根据Person对象的 name 属性 按中文 对 Person数组 排序
    self.indexArray = [BMChineseSort IndexWithArray:self.cityDataArr Key:@"city"];
    self.letterResultArr = [BMChineseSort sortObjectArray:self.cityDataArr Key:@"city"];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, KKNavBarHeight, KKSceneWidth, KKSceneHeight-KKNavBarHeight)];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    table.sectionIndexColor = KKBgYellowColor;
}

-(void)loadData{
    NSArray *nameArr = @[KKLanguage(@"lab_login_area_hot_china"),
                         KKLanguage(@"lab_login_area_hot_HK"),
                         KKLanguage(@"lab_login_area_hot_TW"),
                         KKLanguage(@"lab_login_area_hot_US"),
                         KKLanguage(@"lab_login_area_hot_japan")];
    
    NSArray *areaArr = @[@"+86",@"+852",@"+886",@"+1",@"+81"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"City" ofType:@"plist"];
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:path];
    NSLog(@"data = %@",dataArray);
    for (NSArray *maxArr in dataArray) {
        NSLog(@"maxArr = %@",maxArr);
        FCCountryCityModel *model = [[FCCountryCityModel alloc] init];
        model.city = maxArr[0];
        model.areaNumber = maxArr[1];
        [self.cityDataArr addObject:model];
    }
    
    for (NSInteger i = 0; i<nameArr.count; i++) {
        FCCountryCityModel *model = [[FCCountryCityModel alloc] init];
        model.city = nameArr[i];
        model.areaNumber = areaArr[i];
        [self.adhotArr addObject:model];
    }
}

#pragma mark - UITableView -
//section的titleHeader
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return KKLanguage(@"lab_login_area_hot");
    }else{
        return [self.indexArray objectAtIndex:section-1];
    }
    
}
//section行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.indexArray count]+1;
}
//每组section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.adhotArr.count;
    }else{
        return [[self.letterResultArr objectAtIndex:section-1] count];
    }
}
//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}
//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }else{
        for (UIView *subView in cell.subviews) {
            [subView removeFromSuperview];
        }
    }
    //获得对应的Person对象<替换为你自己的model对象>
    
    UILabel *cityLabel  = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, KKSceneWidth-100, cell.frame.size.height)];
    cityLabel.textAlignment = NSTextAlignmentLeft;
    cityLabel.textColor = [UIColor blackColor];
    cityLabel.adjustsFontSizeToFitWidth = YES;
    [cell addSubview:cityLabel];
    
    UILabel *areaLabel  = [[UILabel alloc] initWithFrame:CGRectMake(KKSceneWidth-90, 0, 75, cell.frame.size.height)];
    areaLabel.textAlignment = NSTextAlignmentRight;
    areaLabel.textColor = [UIColor lightGrayColor];
    [cell addSubview:areaLabel];
    
    if (indexPath.section == 0) {
        FCCountryCityModel *model = [self.adhotArr objectAtIndex:indexPath.row];
        cityLabel.text = model.city;
        areaLabel.text = model.areaNumber;
    }else{
        FCCountryCityModel *model = [[self.letterResultArr objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
        cityLabel.text = model.city;
        areaLabel.text = model.areaNumber;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FCCountryCityModel *model = [self.adhotArr objectAtIndex:indexPath.row];
        self.delegate(model.areaNumber);
    }else{
        FCCountryCityModel *model = [[self.letterResultArr objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
        self.delegate(model.areaNumber);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
