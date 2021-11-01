//
//  HomeViewController.m
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/26.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "HostViewController.h"
#import "AudienceViewController.h"
#import "LVSRoomListResponse.h"
#import "HomeTableViewCell.h"
#import "LVSUser.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *startLiveButton;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) LVSRoomListData *data;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.title = @"Qucik Demo";
    [self buildLayout];
    [self fetchRoomList];
    [self registerNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.view.backgroundColor = lvsMainColor;
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
#pragma mark - fetch 

- (void)fetchRoomList {
    
    if (![LVSUser isLogin]) {
        return;
    }
    
    [LVSWebService roomListWithSize:20 page:1 type:LVSRoomTypeVideo responseClass:[LVSRoomListResponse class] success:^(id  _Nullable responseObject) {
        
        if (responseObject) {
            LVSRoomListResponse *roomListResponse = (LVSRoomListResponse *)responseObject;
            if (roomListResponse.code.integerValue == LVSStatusCodeSuccess) {
                LVSLog(@"home view controller fetch room list success")
                LVSLog(@"room list total count is %ld",(long)roomListResponse.data.rooms.count);
                self.data = roomListResponse.data;
                NSArray *result = [roomListResponse.data.rooms filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                    LVSRoomListRoom *room = (LVSRoomListRoom *)evaluatedObject;
                    return  room.roomType.integerValue == 3;
                }]];
                [self.dataSource addObjectsFromArray:result];
                [self.tableView.mj_header endRefreshing];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            } else {
                if (roomListResponse.msg) {
                    LVSLog(@"home view controller fetch room list failed code: %d msg: %@",roomListResponse.code.intValue,roomListResponse.msg);
                }
            }
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        LVSLog(@"home view controller fetch room list failed code: %ld msg: %@",error.code,error.description);
        
    }];
}

#pragma mark - register notification

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchRoomList) name:LVSLoginSuccessNotification object:nil];
}

#pragma mark - actions

- (void)startLive {
    if ([LVSUser isLogin]) {
        HostViewController *hostVC = [[HostViewController alloc] init];
        [self.navigationController pushViewController:hostVC animated:YES];
    } else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

#pragma mark - tablview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:HomeTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HomeTableViewCellIdentifier];
    }
    
    LVSRoomListRoom *room = self.dataSource[indexPath.row];
    
    [cell updateRoomName:room.roomName roomId:room.roomId];
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LVSRoomListRoom *room = self.dataSource[indexPath.row];
    if (room && room.roomId) {
        AudienceViewController *vc = [[AudienceViewController alloc] initWithRoomId:room.roomId roomName:room.roomName];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - getter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor blackColor];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        WeakSelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            StrongSelf
            [strongSelf.dataSource removeAllObjects];
            [strongSelf fetchRoomList];
     }];
    }
    return  _tableView;
}

- (UIButton *)startLiveButton {
    if (_startLiveButton == nil) {
        _startLiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startLiveButton.backgroundColor = lvsMainColor;
        _startLiveButton.layer.masksToBounds = YES;
        _startLiveButton.layer.cornerRadius = 32;
        [_startLiveButton setTitle:@"Start live" forState:UIControlStateNormal];
        [_startLiveButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_startLiveButton addTarget:self action:@selector(startLive) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startLiveButton;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [@[] mutableCopy];
    }
    return _dataSource;
}
#pragma mark -layout subview

- (void)buildLayout {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.startLiveButton];
    [self.startLiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(64.f, 64.f));
        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
        make.centerX.equalTo(self.view);
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
