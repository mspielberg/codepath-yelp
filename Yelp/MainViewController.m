//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "FiltersViewController.h"
#import "BusinessCell.h"
#import "YelpClient.h"

NSString * const kYelpConsumerKey = @"5tdZLFmgNWTUKR_wZZrc6g";
NSString * const kYelpConsumerSecret = @"i8JNsuZKli9Mva_tYV_qgBVPacs";
NSString * const kYelpToken = @"G7shCJi_KsMRZhGfyyvM8L9fKbU2o4UT";
NSString * const kYelpTokenSecret = @"J-9igA_UsK-64QE5WS3iBBHGd0M";

@interface MainViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSString *searchTerm;
@property (strong, nonatomic) YelpFilterSettings *filterSettings;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UIView *loadingFooterView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property NSInteger totalResults;
@property (nonatomic, strong) NSArray *results;

@property (nonatomic, strong) BusinessCell *sizingCell;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    
    self.searchTerm = @"";
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    
    self.navigationItem.leftBarButtonItem.title = @"Filters";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStylePlain target:self action:@selector(onShowFilters)];
    self.navigationItem.titleView = self.searchBar;
    
    self.results = @[];
    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.tableView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    
    UINib *businessCellNib = [UINib nibWithNibName:@"BusinessCell" bundle:nil];
    [self.tableView registerNib:businessCellNib forCellReuseIdentifier:@"BusinessCell"];
    
    self.sizingCell = [businessCellNib instantiateWithOwner:nil options:nil][0];
    self.sizingCell.frame = self.tableView.frame;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    
    self.loadingFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 50)];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.center = self.loadingFooterView.center;
    [self.loadingFooterView addSubview:self.activityIndicator];
    
    [self loadMoreResults];
}

- (void)loadMoreResults {
    [self.client searchWithTerm:self.searchTerm filters:self.filterSettings offset:self.results.count success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        self.totalResults = [response[@"total"] integerValue];
        self.results = [self.results arrayByAddingObjectsFromArray:response[@"businesses"]];
        [self.activityIndicator stopAnimating];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:NO];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if (![self.searchTerm isEqualToString:self.searchBar.text])
        [self executeSearch];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if (![self.searchTerm isEqualToString:searchBar.text] && searchBar.text.length == 0)
        [self executeSearch];
}

- (void)executeSearch {
    self.searchTerm = self.searchBar.text;
    [self onRefresh];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.index = indexPath.row;
    cell.business = [[Business alloc] initWithDictionary:self.results[indexPath.row]];
    
//    NSLog(@"row = %ld, totalResults = %ld", indexPath.row, self.totalResults);
    if (indexPath.row == self.results.count - 1 && indexPath.row + 1 < self.totalResults) {
        [self.activityIndicator startAnimating];
        self.tableView.tableFooterView = self.loadingFooterView;
        [self loadMoreResults];
    }
    
    return cell;
}

- (void)onRefresh {
    NSLog(@"Reloading tableView data");
    self.results = @[];
    [self.tableView reloadData];
    [self loadMoreResults];
    [self.refreshControl endRefreshing];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"entering heightForRowAtIndexPath");
    self.sizingCell.index = indexPath.row;
    self.sizingCell.business = [[Business alloc] initWithDictionary:self.results[indexPath.row]];
//    NSLog(@"Sizing row %ld with business %@", indexPath.row, self.sizingCell.business);
    [self.sizingCell layoutSubviews];
    CGFloat desiredHeight = [self.sizingCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    NSLog(@"Calculated height %f for row %ld", desiredHeight, indexPath.row);
    return desiredHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.searchBar.text = self.searchTerm;
    [self.searchBar endEditing:NO];
}

#pragma mark FiltersViewControllerDelegate

- (void)onShowFilters {
//    NSLog(@"Entering onShowFilters");
    FiltersViewController *fvc = [[FiltersViewController alloc] init];
    fvc.delegate = self;
    NSLog(@"Settings filterSettings: %@", self.filterSettings); 
    fvc.filterSettings = self.filterSettings;
    UINavigationController *fnvc = [[UINavigationController alloc]initWithRootViewController:fvc];
    
    [self presentViewController:fnvc animated:YES completion:nil];
}

- (void)filtersViewController:(FiltersViewController *)filtersViewController didUpdateFilterSettings:(YelpFilterSettings *)filterSettings {
    NSLog(@"didUpdateFilterSettings: %@", filterSettings);
    self.filterSettings = [filterSettings copy];
    [self onRefresh];
}

@end
