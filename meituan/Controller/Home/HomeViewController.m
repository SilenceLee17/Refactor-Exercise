//
//  HomeViewController.m
//  meituan
//
//  Created by jinzelu on 15/6/17.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "HomeViewController.h"
#import "NetworkSingleton.h"
#import "RushDataModel.h"
#import "RushDealsModel.h"
#import "MJRefresh.h"
#import "HomeMenuCell.h"
#import "RushCell.h"
#import "HotQueueModel.h"
#import "HotQueueCell.h"
#import "RecommendModel.h"
#import "RecommendCell.h"
#import "DiscountModel.h"
#import "DiscountCell.h"
#import "DiscountViewController.h"
#import "RushViewController.h"
#import "DiscountOCViewController.h"
#import "HotQueueViewController.h"
#import "ShopViewController.h"
#import "JZMapViewController.h"
#import "XDLocationManager.h"

#import "EXTScope.h"


static NSString *const rushBuyURL = @"http://api.meituan.com/group/v1/deal/activity/1?__skck=40aaaf01c2fc4801b9c059efcd7aa146&__skcy=NF9S7jqv3TVBAoEURoapWJ5VBdQ%3D&__skno=FB6346F3-98FF-4B26-9C36-DC9022236CC3&__skts=1434530933.316028&__skua=bd6b6e8eadfad15571a15c3b9ef9199a&__vhost=api.mobile.meituan.com&ci=1&client=iphone&movieBundleVersion=100&msid=48E2B810-805D-4821-9CDD-D5C9E01BC98A2015-06-17-14-50363&ptId=iphone_5.7&userid=10086&utm_campaign=AgroupBgroupD100Fab_chunceshishuju__a__a___b1junglehomepagecatesort__b__leftflow___ab_gxhceshi__nostrategy__leftflow___ab_gxhceshi0202__b__a___ab_pindaochangsha__a__leftflow___ab_xinkeceshi__b__leftflow___ab_gxtest__gd__leftflow___ab_gxh_82__nostrategy__leftflow___ab_pindaoshenyang__a__leftflow___i_group_5_2_deallist_poitype__d__d___ab_b_food_57_purepoilist_extinfo__a__a___ab_trip_yidizhoubianyou__b__leftflow___ab_i_group_5_3_poidetaildeallist__a__b___ab_waimaizhanshi__b__b1___a20141120nanning__m1__leftflow___ab_pindaoquxincelue__a__leftflow___ab_i_group_5_5_onsite__b__b___ab_i_group_5_6_searchkuang__a__leftflow&utm_content=4B8C0B46F5B0527D55EA292904FD7E12E48FB7BEA8DF50BFE7828AF7F20BB08D&utm_medium=iphone&utm_source=AppStore&utm_term=5.7&uuid=4B8C0B46F5B0527D55EA292904FD7E12E48FB7BEA8DF50BFE7828AF7F20BB08D&version_name=5.7";
static NSString *const hotQueueURL = @"http://api.meituan.com/group/v1/itemportal/position/";
static NSString *const hotQueueParameters = @"__skck=40aaaf01c2fc4801b9c059efcd7aa146&__skcy=x6Fyq0RW3Z7ZtUXKPpRXPbYUGRE%3D&__skno=348FAC89-38E1-4880-A550-E992DB9AE44E&__skts=1434530933.451634&__skua=bd6b6e8eadfad15571a15c3b9ef9199a&__vhost=api.mobile.meituan.com&ci=1&cityId=1&client=iphone&movieBundleVersion=100&msid=48E2B810-805D-4821-9CDD-D5C9E01BC98A2015-06-17-14-50363&userid=10086&utm_campaign=AgroupBgroupD100Fab_chunceshishuju__a__a___b1junglehomepagecatesort__b__leftflow___ab_gxhceshi__nostrategy__leftflow___ab_gxhceshi0202__b__a___ab_pindaochangsha__a__leftflow___ab_xinkeceshi__b__leftflow___ab_gxtest__gd__leftflow___ab_gxh_82__nostrategy__leftflow___ab_pindaoshenyang__a__leftflow___i_group_5_2_deallist_poitype__d__d___ab_b_food_57_purepoilist_extinfo__a__a___ab_trip_yidizhoubianyou__b__leftflow___ab_i_group_5_3_poidetaildeallist__a__b___ab_waimaizhanshi__b__b1___a20141120nanning__m1__leftflow___ab_pindaoquxincelue__a__leftflow___ab_i_group_5_5_onsite__b__b___ab_i_group_5_6_searchkuang__a__leftflow&utm_content=4B8C0B46F5B0527D55EA292904FD7E12E48FB7BEA8DF50BFE7828AF7F20BB08D&utm_medium=iphone&utm_source=AppStore&utm_term=5.7&uuid=4B8C0B46F5B0527D55EA292904FD7E12E48FB7BEA8DF50BFE7828AF7F20BB08D&version_name=5.7";

static NSString *const recommendURL = @"http://api.meituan.com/group/v1/recommend/homepage/city/1?__skck=40aaaf01c2fc4801b9c059efcd7aa146&__skcy=mrUZYo7999nH8WgTicdfzaGjaSQ=&__skno=51156DC4-B59A-4108-8812-AD05BF227A47&__skts=1434530933.303717&__skua=bd6b6e8eadfad15571a15c3b9ef9199a&__vhost=api.mobile.meituan.com&ci=1&client=iphone&limit=40&movieBundleVersion=100&msid=48E2B810-805D-4821-9CDD-D5C9E01BC98A2015-06-17-14-50363&offset=0";
static NSString *const recommendParameters = @"&userId=10086&userid=10086&utm_campaign=AgroupBgroupD100Fab_chunceshishuju__a__a___b1junglehomepagecatesort__b__leftflow___ab_gxhceshi__nostrategy__leftflow___ab_gxhceshi0202__b__a___ab_pindaochangsha__a__leftflow___ab_xinkeceshi__b__leftflow___ab_gxtest__gd__leftflow___ab_gxh_82__nostrategy__leftflow___ab_pindaoshenyang__a__leftflow___i_group_5_2_deallist_poitype__d__d___ab_b_food_57_purepoilist_extinfo__a__a___ab_trip_yidizhoubianyou__b__leftflow___ab_i_group_5_3_poidetaildeallist__a__b___ab_waimaizhanshi__b__b1___a20141120nanning__m1__leftflow___ab_pind";
static NSString *const discountURL = @"http://api.meituan.com/group/v1/deal/topic/discount/city/1?ci=1&client=iphone&movieBundleVersion=100&msid=48E2B810-805D-4821-9CDD-D5C9E01BC98A2015-06-17-14-50363&userid=10086&utm_campaign=AgroupBgroupD100Fab_chunceshishuju__a__a___b1junglehomepagecatesort__b__leftflow___ab_gxhceshi__nostrategy__leftflow___ab_gxhceshi0202__b__a___ab_pindaochangsha__a__leftflow___ab_xinkeceshi__b__leftflow___ab_gxtest__gd__leftflow___ab_gxh_82__nostrategy__leftflow___ab_pindaoshenyang__a__leftflow___i_group_5_2_deallist_poitype__d__d___ab_b_food_57_purepoilist_extinfo__a__a___ab_trip_yidizhoubianyou__b__leftflow___ab_i_group_5_3_poidetaildeallist__a__b___ab_waimaizhanshi__b__b1___a20141120nanning__m1__leftflow___ab_pindaoquxincelue__a__leftflow___ab_i_group_5_5_onsite__b__b___ab_i_group_5_6_searchkuang__a__leftflow&utm_content=4B8C0B46F5B0527D55EA292904FD7E12E48FB7BEA8DF50BFE7828AF7F20BB08D&utm_medium=iphone&utm_source=AppStore&utm_term=5.7&uuid=4B8C0B46F5B0527D55EA292904FD7E12E48FB7BEA8DF50BFE7828AF7F20BB08D&version_name=5.7";

static NSString *const hotQueueCellURL = @"http://ismart.meituan.com/?ci=1&f=iphone&msid=48E2B810-805D-4821-9CDD-D5C9E01BC98A2015-07-03-16-08715&token=p09ukJltGhla4y5Jryb1jgCdKjsAAAAAsgAAADHFD3UYGxaY2FlFPQXQj2wCyCrhhn7VVB-KpG_U3-clHlvsLM8JRrnZK35y8UU3DQ&userid=10086&";
static NSString *const hotQueueCellCampaign = @"AgroupBgroupD100Fab_chunceshishuju__a__a___b1junglehomepagecatesort__b__leftflow___ab_gxhceshi__nostrategy__leftflow___ab_gxhceshi0202__b__a___ab_pindaochangsha__a__leftflow___ab_xinkeceshi__b__leftflow___ab_gxtest__gd__leftflow___ab_waimaiwending__a__a___ab_gxh_82__nostrategy__leftflow___i_group_5_2_deallist_poitype__d__d___ab_b_food_57_purepoilist_extinfo__a__a___ab_i_group_5_3_poidetaildeallist__a__b___ab_pindaoshenyang__a__leftflow___ab_pindaoquxincelue0630__b__b1___ab_waimaizhanshi__b__b1___a20141120nanning__m1__leftflow___ab_i_group_5_5_onsite__b__b___ab_i_group_5_6_searchkuang__a__leftflowGhomepage_middlebanner_%E7%83%AD%E9%97%A8%E9%A4%90%E5%8E%85%E5%9C%A8%E7%BA%BF%E6%8E%92%E9%98%9F";
static NSString *const hotQueueCellPatameters = @"&utm_content=4B7C0B46F5B0527D55EA292904FD7E12E48FB7BEA8DF50BFE7828AF7F20BB08D&utm_medium=iphone&utm_source=AppStore&utm_term=5.7&uuid=4B8C0B46F5B0527D55EA292904FD7E12E48FB7BEA8DF50BFE7828AF7F20BB08D&version_name=5.7&";

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate,DiscountDelegate,RushDelegate>
@property(nonatomic, copy) NSMutableArray *menuArray;
@property(nonatomic, copy) NSMutableArray *rushArray;//抢购数据
@property(nonatomic, copy) NSMutableArray *recommendArray;
@property(nonatomic, copy) NSMutableArray *discountArray;
@property(nonatomic, strong) HotQueueModel *hotQueueData;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [self initData];
    [self setupNavigation];
    [self initTableView];
}

//初始化数据
-(void)initData{
    _rushArray = [[NSMutableArray alloc] init];
    _hotQueueData = [[HotQueueModel alloc] init];
    _recommendArray = [[NSMutableArray alloc] init];
    _discountArray = [[NSMutableArray alloc] init];
    
    //
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"menuData" ofType:@"plist"];
    _menuArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
}

-(void)setupNavigation{
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    navigationView.backgroundColor = navigationBarColor;
    [self.view addSubview:navigationView];
    //城市
    UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cityButton.frame = CGRectMake(10, 30, 40, 25);
    cityButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cityButton setTitle:@"北京" forState:UIControlStateNormal];
    [navigationView addSubview:cityButton];
    UIImageView *cityArrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cityButton.frame), 38, 13, 10)];
    [cityArrowImage setImage:[UIImage imageNamed:@"icon_homepage_downArrow"]];
    [navigationView addSubview:cityArrowImage];
    //地图
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.frame = CGRectMake(screen_width-42, 30, 42, 30);
    [locationButton setImage:[UIImage imageNamed:@"icon_homepage_map_old"] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(locationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:locationButton];
    
    //搜索框
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cityArrowImage.frame)+10, 30, 200, 25)];
    searchView.backgroundColor = RGB(7, 170, 153);
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 12;
    [navigationView addSubview:searchView];
    
    //
    UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 15, 15)];
    [searchImage setImage:[UIImage imageNamed:@"icon_homepage_search"]];
    [searchView addSubview:searchImage];
    
    UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 150, 25)];
    placeHolderLabel.font = [UIFont boldSystemFontOfSize:13];
    placeHolderLabel.text = @"请输入商家、品类、商圈";
    placeHolderLabel.textColor = [UIColor whiteColor];
    [searchView addSubview:placeHolderLabel];
}

-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height-49-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self setUpTableViewLoading];
    
}

-(void)setUpTableViewLoading{
    //添加下拉的动画图片
    //设置下拉刷新回调
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    //设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; ++i) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd",i]];
        [idleImages addObject:image];
    }
    [self.tableView.gifHeader setImages:idleImages forState:MJRefreshHeaderStateIdle];
    
    //设置即将刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd",i]];
        [refreshingImages addObject:image];
    }
    [self.tableView.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStatePulling];
    
    //设置正在刷新是的动画图片
    [self.tableView.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStateRefreshing];
    
    //马上进入刷新状态
    [self.tableView.gifHeader beginRefreshing];
}


-(void)locationButtonClicked:(UIButton *)sender{
    JZMapViewController *JZMapVC = [[JZMapViewController alloc] init];
    [self.navigationController pushViewController:JZMapVC animated:YES];
}

-(void)refreshData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        //
        [self getRushBuyData];
        [self getHotQueueData];
        [self getRecommendData];
        [self getDiscountData];
        dispatch_async(dispatch_get_main_queue(), ^{
            //update UI
        });
    });
}


//请求抢购数据
-(void)getRushBuyData{
    [[NetworkSingleton sharedManager] getRushBuyResult:nil url:rushBuyURL successBlock:^(id responseBody){
        NSDictionary *dataDic = [responseBody objectForKey:@"data"];
        RushDataModel *rushDataM = [RushDataModel objectWithKeyValues:dataDic];
        [_rushArray removeAllObjects];
        
        for (int i = 0; i < rushDataM.deals.count; i++) {
            RushDealsModel *deals = [RushDealsModel objectWithKeyValues:rushDataM.deals[i]];
            [_rushArray addObject:deals];
        }
        [self.tableView reloadData];
        
    } failureBlock:^(NSString *error){
        [self.tableView.header endRefreshing];
    }];
}
//请求热门排队数据
-(void)getHotQueueData{
    XDLocationManager *locationManager = [XDLocationManager sharedManager];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%f,%f?%@",hotQueueURL,locationManager.latitude,locationManager.longitude,hotQueueParameters];
    
    [[NetworkSingleton sharedManager] getHotQueueResult:nil url:urlStr successBlock:^(id responseBody){
        NSDictionary *dataDic = [responseBody objectForKey:@"data"];
        _hotQueueData = [HotQueueModel objectWithKeyValues:dataDic];
        
        [self.tableView reloadData];
    } failureBlock:^(NSString *error){
        [self.tableView.header endRefreshing];
    }];
}
//推荐数据
-(void)getRecommendData{
    
    XDLocationManager *locationManager = [XDLocationManager sharedManager];
    NSString *urlStr = [NSString stringWithFormat:@"%@&position=%f,%f%@",recommendURL,locationManager.latitude,locationManager.longitude,recommendParameters];
    
    
    
    [[NetworkSingleton sharedManager] getRecommendResult:nil url:urlStr successBlock:^(id responseBody){
        NSMutableArray *dataDic = [responseBody objectForKey:@"data"];
        [_recommendArray removeAllObjects];
        for (int i = 0; i < dataDic.count; i++) {
            RecommendModel *recommend = [RecommendModel objectWithKeyValues:dataDic[i]];
            [_recommendArray addObject:recommend];
        }
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSString *error){
        [self.tableView.header endRefreshing];
    }];
}

//获取折扣数据
-(void)getDiscountData{
    [[NetworkSingleton sharedManager] getDiscountResult:nil url:discountURL successBlock:^(id responseBody){
        
        NSMutableArray *dataDic = [responseBody objectForKey:@"data"];
        [_discountArray removeAllObjects];
        for (int i = 0; i < dataDic.count; i++) {
            DiscountModel *discount = [DiscountModel objectWithKeyValues:dataDic[i]];
            [_discountArray addObject:discount];
        }
        
        [self.tableView reloadData];
        
        [self.tableView.header endRefreshing];
        
    } failureBlock:^(NSString *error){
        [self.tableView.header endRefreshing];
    }];
}



#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 4) {
        return _recommendArray.count+1;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 180;
    }else if(indexPath.section == 1){
        if (_rushArray.count!=0) {
            return 120;
        }else{
            return 0.0;
        }
    }else if (indexPath.section == 2){
        if (_discountArray.count == 0) {
            return 0.0;
        }else{
            return 160.0;
        }
    }else if (indexPath.section == 3){
        if (_hotQueueData.title == nil) {
            return 0.0;
        }else{
            return 50.0;
        }
    }else if(indexPath.section == 4){
        if (indexPath.row == 0) {
            return 35.0;
        }else{
            return 100.0;
        }
    }else{
        return 70.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 10)];
    headerView.backgroundColor = RGB(239, 239, 244);
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    footerView.backgroundColor = RGB(239, 239, 244);
    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellIndentifier = @"menucell";
        HomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[HomeMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier menuArray:_menuArray];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 1){
        if (_rushArray.count == 0) {
            static NSString *cellIndentifier = @"nomorecell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            static NSString *cellIndentifier = @"rushcell";
            RushCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[RushCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            
            if (_rushArray.count!=0) {
                [cell setRushData:_rushArray];
            }
            cell.delegate = self;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else if (indexPath.section == 2){
        if (_discountArray.count == 0) {
            static NSString *cellIndentifier = @"nomorecell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            static NSString *cellIndentifier = @"discountcell";
            DiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[DiscountCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
            }
            
            cell.delegate = self;
            if (_discountArray.count != 0) {
                [cell setDiscountArray:_discountArray];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else if(indexPath.section == 3){
        if (_hotQueueData ==nil) {
            static NSString *cellIndentifier = @"nomorecell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            static NSString *cellIndentifier = @"hotqueuecell";
            HotQueueCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[HotQueueCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
            }
            
            if (_hotQueueData != nil) {
                [cell setHotQueue:_hotQueueData];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else{//推荐
        if(indexPath.row == 0){
            static NSString *cellIndentifier = @"morecell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            
            cell.textLabel.text = @"猜你喜欢";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            static NSString *cellIndentifier = @"recommendcell";
            RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[RecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            
            if(_recommendArray.count!=0){
                RecommendModel *recommend = _recommendArray[indexPath.row-1];
                [cell setRecommendData:recommend];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        
    }
}



#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        XDLocationManager *locationManager = [XDLocationManager sharedManager];
        NSString *urlStr = [NSString stringWithFormat:@"%@utm_campaign=%@%@lat=%f&lng=%f",hotQueueCellURL,hotQueueCellCampaign,hotQueueCellPatameters, locationManager.latitude,locationManager.longitude];
        
        HotQueueViewController *hotQVC = [[HotQueueViewController alloc] init];
        hotQVC.urlStr = urlStr;
        [self.navigationController pushViewController:hotQVC animated:YES];
        
    }else if (indexPath.section == 4){
        if (indexPath.row !=0) {
            RecommendModel *recommend = _recommendArray[indexPath.row-1];
            NSString *shopId = [recommend.id stringValue];
            ShopViewController *shopVC = [[ShopViewController alloc] init];
            shopVC.shopID = shopId;
            [self.navigationController pushViewController:shopVC animated:YES];
        }
    }
}


#pragma mark - DiscountDelegate
-(void)didSelectUrl:(NSString *)urlStr withType:(NSNumber *)type withId:(NSNumber *)ID withTitle:(NSString *)title{
    NSNumber *num = [[NSNumber alloc] initWithLong:1];
    if ([type isEqualToValue: num]) {
        DiscountViewController *discountVC = [[DiscountViewController alloc] init];
        discountVC.urlStr = urlStr;
        
        [self.navigationController pushViewController:discountVC animated:YES];
    }else{
        NSString *IDStr = [ID stringValue];
        DiscountOCViewController *disOCVC = [[DiscountOCViewController alloc] init];
        
        disOCVC.ID = IDStr;
        disOCVC.title = title;
        [self.navigationController pushViewController:disOCVC animated:YES];
    }
}

#pragma mark - RushDelegate
-(void)didSelectRushIndex:(NSInteger)index{
    RushViewController *rushVC = [[RushViewController alloc] init];
    [self.navigationController pushViewController:rushVC animated:YES];
}

@end
