//
//  FiltersViewController.m
//  Yelp
//
//  Created by Miles Spielberg on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "YelpFilterSettings.h"
#import "SortOrderCell.h"
#import "RadiusCell.h"
#import "SwitchCell.h"
#import "NSArray+ArrayOps.h"
#import "Units.h"

@interface FiltersViewController () <UITableViewDataSource, SortOrderCellDelegate, RadiusCellDelegate, SwitchCellDelegate>
@property (strong, nonatomic) UINib *switchCellNib;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SortOrderCell *sortOrderCell;
@property (strong, nonatomic) RadiusCell *radiusCell;
@property (strong, nonatomic) SwitchCell *dealsCell;
@property (strong, nonatomic) NSArray *generalFilterCells;
@property (strong, nonatomic) SwitchCell *showAllCategoriesCell;
@property (strong, nonatomic) NSArray *currentlyShownCategories;
@end

@implementation FiltersViewController

- (FiltersViewController *)init {
    self = [super init];
    if (self) {
        self.title = @"Filters";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone)];
        
        self.sortOrderCell = [[NSBundle mainBundle] loadNibNamed:@"SortOrderCell" owner:self options:nil].firstObject;
        self.sortOrderCell.delegate = self;
        
        self.radiusCell = [[NSBundle mainBundle] loadNibNamed:@"RadiusCell" owner:self options:nil].firstObject;
        self.radiusCell.delegate = self;
        
        self.switchCellNib = [UINib nibWithNibName:@"SwitchCell" bundle:nil];
        
        self.dealsCell = [self switchCellWithTitle:@"Offering a Deal"];
        
        self.generalFilterCells = @[self.sortOrderCell, self.radiusCell, self.dealsCell];
        
        if (!self.filterSettings)
            self.filterSettings = [[YelpFilterSettings alloc] init];
        
        self.radiusCell.value = self.filterSettings.searchRadiusInMiles;
        
        self.showAllCategoriesCell = [self switchCellWithTitle:@"Show All Categories"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:self.switchCellNib forCellReuseIdentifier:@"SwitchCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SwitchCell *)switchCellWithTitle:(NSString *)title {
    SwitchCell *cell = [self.switchCellNib instantiateWithOwner:self options:nil].firstObject;
    cell.delegate = self;
    cell.title = title;
    return cell;
}

- (void)setFilterSettings:(YelpFilterSettings *)filterSettings {
    NSLog(@"Entering setFilterSettings = %@", filterSettings);

    _filterSettings = [filterSettings copy];
    NSLog(@"Setting filterSettings = %@", _filterSettings);
    self.sortOrderCell.value = filterSettings.sortType;
    self.radiusCell.value = filterSettings.searchRadiusInMiles;
    self.dealsCell.on = filterSettings.dealsFilter;
    
    [self reloadCategories];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onCancel {
    NSLog(@"called onCancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onDone {
    NSLog(@"called onDone");
    [self.delegate filtersViewController:self didUpdateFilterSettings:self.filterSettings];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Category control

+ (NSArray *)allCategories {
    return @[
             @{@"name" : @"Afghan", @"code": @"afghani" },
             @{@"name" : @"African", @"code": @"african" },
             @{@"name" : @"Senegalese", @"code": @"senegalese" },
             @{@"name" : @"South African", @"code": @"southafrican" },
             @{@"name" : @"American, New", @"code": @"newamerican" },
             @{@"name" : @"American, Traditional", @"code": @"tradamerican" },
             @{@"name" : @"Arabian", @"code": @"arabian" },
             @{@"name" : @"Argentine", @"code": @"argentine" },
             @{@"name" : @"Armenian", @"code": @"armenian" },
             @{@"name" : @"Asian Fusion", @"code": @"asianfusion" },
             @{@"name" : @"Australian", @"code": @"australian" },
             @{@"name" : @"Austrian", @"code": @"austrian" },
             @{@"name" : @"Bangladeshi", @"code": @"bangladeshi" },
             @{@"name" : @"Barbeque", @"code": @"bbq" },
             @{@"name" : @"Basque", @"code": @"basque" },
             @{@"name" : @"Belgian", @"code": @"belgian" },
             @{@"name" : @"Brasseries", @"code": @"brasseries" },
             @{@"name" : @"Brazilian", @"code": @"brazilian" },
             @{@"name" : @"Breakfast & Brunch", @"code": @"breakfast_brunch" },
             @{@"name" : @"British", @"code": @"british" },
             @{@"name" : @"Buffets", @"code": @"buffets" },
             @{@"name" : @"Burgers", @"code": @"burgers" },
             @{@"name" : @"Burmese", @"code": @"burmese" },
             @{@"name" : @"Cafes", @"code": @"cafes" },
             @{@"name" : @"Cafeteria", @"code": @"cafeteria" },
             @{@"name" : @"Cajun/Creole", @"code": @"cajun" },
             @{@"name" : @"Cambodian", @"code": @"cambodian" },
             @{@"name" : @"Caribbean", @"code": @"caribbean" },
             @{@"name" : @"Dominican", @"code": @"dominican" },
             @{@"name" : @"Haitian", @"code": @"haitian" },
             @{@"name" : @"Puerto Rican", @"code": @"puertorican" },
             @{@"name" : @"Trinidadian", @"code": @"trinidadian" },
             @{@"name" : @"Catalan", @"code": @"catalan" },
             @{@"name" : @"Cheesesteaks", @"code": @"cheesesteaks" },
             @{@"name" : @"Chicken Shop", @"code": @"chickenshop" },
             @{@"name" : @"Chicken Wings", @"code": @"chicken_wings" },
             @{@"name" : @"Chinese", @"code": @"chinese" },
             @{@"name" : @"Cantonese", @"code": @"cantonese" },
             @{@"name" : @"Dim Sum", @"code": @"dimsum" },
             @{@"name" : @"Shanghainese", @"code": @"shanghainese" },
             @{@"name" : @"Szechuan", @"code": @"szechuan" },
             @{@"name" : @"Comfort Food", @"code": @"comfortfood" },
             @{@"name" : @"Corsican", @"code": @"corsican" },
             @{@"name" : @"Creperies", @"code": @"creperies" },
             @{@"name" : @"Cuban", @"code": @"cuban" },
             @{@"name" : @"Czech", @"code": @"czech" },
             @{@"name" : @"Delis", @"code": @"delis" },
             @{@"name" : @"Diners", @"code": @"diners" },
             @{@"name" : @"Fast Food", @"code": @"hotdogs" },
             @{@"name" : @"Filipino", @"code": @"filipino" },
             @{@"name" : @"Fish & Chips", @"code": @"fishnchips" },
             @{@"name" : @"Fondue", @"code": @"fondue" },
             @{@"name" : @"Food Court", @"code": @"food_court" },
             @{@"name" : @"Food Stands", @"code": @"foodstands" },
             @{@"name" : @"French", @"code": @"french" },
             @{@"name" : @"Gastropubs", @"code": @"gastropubs" },
             @{@"name" : @"German", @"code": @"german" },
             @{@"name" : @"Gluten-Free", @"code": @"gluten_free" },
             @{@"name" : @"Greek", @"code": @"greek" },
             @{@"name" : @"Halal", @"code": @"halal" },
             @{@"name" : @"Hawaiian", @"code": @"hawaiian" },
             @{@"name" : @"Himalayan/Nepalese", @"code": @"himalayan" },
             @{@"name" : @"Hong Kong Style Cafe", @"code": @"hkcafe" },
             @{@"name" : @"Hot Dogs", @"code": @"hotdog" },
             @{@"name" : @"Hot Pot", @"code": @"hotpot" },
             @{@"name" : @"Hungarian", @"code": @"hungarian" },
             @{@"name" : @"Iberian", @"code": @"iberian" },
             @{@"name" : @"Indian", @"code": @"indpak" },
             @{@"name" : @"Indonesian", @"code": @"indonesian" },
             @{@"name" : @"Irish", @"code": @"irish" },
             @{@"name" : @"Italian", @"code": @"italian" },
             @{@"name" : @"Japanese", @"code": @"japanese" },
             @{@"name" : @"Ramen", @"code": @"ramen" },
             @{@"name" : @"Teppanyaki", @"code": @"teppanyaki" },
             @{@"name" : @"Korean", @"code": @"korean" },
             @{@"name" : @"Kosher", @"code": @"kosher" },
             @{@"name" : @"Laotian", @"code": @"laotian" },
             @{@"name" : @"Latin American", @"code": @"latin" },
             @{@"name" : @"Colombian", @"code": @"colombian" },
             @{@"name" : @"Salvadorean", @"code": @"salvadorean" },
             @{@"name" : @"Venezuelan", @"code": @"venezuelan" },
             @{@"name" : @"Live/Raw Food", @"code": @"raw_food" },
             @{@"name" : @"Malaysian", @"code": @"malaysian" },
             @{@"name" : @"Mediterranean", @"code": @"mediterranean" },
             @{@"name" : @"Falafel", @"code": @"falafel" },
             @{@"name" : @"Mexican", @"code": @"mexican" },
             @{@"name" : @"Middle Eastern", @"code": @"mideastern" },
             @{@"name" : @"Egyptian", @"code": @"egyptian" },
             @{@"name" : @"Lebanese", @"code": @"lebanese" },
             @{@"name" : @"Modern European", @"code": @"modern_european" },
             @{@"name" : @"Mongolian", @"code": @"mongolian" },
             @{@"name" : @"Moroccan", @"code": @"moroccan" },
             @{@"name" : @"Pakistani", @"code": @"pakistani" },
             @{@"name" : @"Persian/Iranian", @"code": @"persian" },
             @{@"name" : @"Peruvian", @"code": @"peruvian" },
             @{@"name" : @"Pizza", @"code": @"pizza" },
             @{@"name" : @"Polish", @"code": @"polish" },
             @{@"name" : @"Portuguese", @"code": @"portuguese" },
             @{@"name" : @"Poutineries", @"code": @"poutineries" },
             @{@"name" : @"Russian", @"code": @"russian" },
             @{@"name" : @"Salad", @"code": @"salad" },
             @{@"name" : @"Sandwiches", @"code": @"sandwiches" },
             @{@"name" : @"Scandinavian", @"code": @"scandinavian" },
             @{@"name" : @"Scottish", @"code": @"scottish" },
             @{@"name" : @"Seafood", @"code": @"seafood" },
             @{@"name" : @"Singaporean", @"code": @"singaporean" },
             @{@"name" : @"Slovakian", @"code": @"slovakian" },
             @{@"name" : @"Soul Food", @"code": @"soulfood" },
             @{@"name" : @"Soup", @"code": @"soup" },
             @{@"name" : @"Southern", @"code": @"southern" },
             @{@"name" : @"Spanish", @"code": @"spanish" },
             @{@"name" : @"Sri Lankan", @"code": @"srilankan" },
             @{@"name" : @"Steakhouses", @"code": @"steak" },
             @{@"name" : @"Sushi Bars", @"code": @"sushi" },
             @{@"name" : @"Taiwanese", @"code": @"taiwanese" },
             @{@"name" : @"Tapas Bars", @"code": @"tapas" },
             @{@"name" : @"Tapas/Small Plates", @"code": @"tapasmallplates" },
             @{@"name" : @"Tex-Mex", @"code": @"tex-mex" },
             @{@"name" : @"Thai", @"code": @"thai" },
             @{@"name" : @"Turkish", @"code": @"turkish" },
             @{@"name" : @"Ukrainian", @"code": @"ukrainian" },
             @{@"name" : @"Uzbek", @"code": @"uzbek" },
             @{@"name" : @"Vegan", @"code": @"vegan" },
             @{@"name" : @"Vegetarian", @"code": @"vegetarian" },
             @{@"name" : @"Vietnamese", @"code": @"vietnamese" }];
}

+ (NSArray *)preferredCategories {
    return @[@"tradamerican", @"chinese", @"italian"];
}

- (NSArray *)categoriesToShow {
    if (self.showAllCategoriesCell.on) {
        return [FiltersViewController allCategories];
    } else if (self.filterSettings.activeCategories.count > 0) {
        return [[FiltersViewController allCategories] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [self.filterSettings.activeCategories indexOfObject:evaluatedObject[@"code"]] != NSNotFound;
        }]];
    } else {
        return [[FiltersViewController allCategories] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [[FiltersViewController preferredCategories] indexOfObject:evaluatedObject[@"code"]] != NSNotFound;
        }]];
    }
}

- (void)reloadCategories {
    self.currentlyShownCategories = [self categoriesToShow];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.generalFilterCells.count;
            break;
        case 1:
            return self.currentlyShownCategories.count + 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return self.generalFilterCells[indexPath.row];
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                return self.showAllCategoriesCell;
            } else {
                NSDictionary *category = self.currentlyShownCategories[indexPath.row - 1];
                SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
                cell.delegate = self;
                cell.title = category[@"name"];
                cell.on = [self.filterSettings.activeCategories indexOfObject:category[@"code"]] != NSNotFound;
                return cell;
            }
            break;
        }
        default:
            return nil;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"General";
            break;
        case 1:
            return @"Categories";
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
}

#pragma mark SortOrderCellDelegate

- (void)sortOrderCell:(SortOrderCell *)sortOrderCell didChangeValue:(NSInteger)value {
    NSLog(@"Got new sort order: %ld", value);
    self.filterSettings.sortType = value;
}

#pragma mark RadiusCellDelegate

- (void)radiusCell:(RadiusCell *)radiusCell didSelectValue:(float)value {
    NSLog(@"Got new value from RadiusCell: %f", value);
    self.filterSettings.searchRadiusInMiles = value;
}

#pragma mark SwitchCellDelegate

- (void)switchCell:(SwitchCell *)switchCell changedValue:(BOOL)value {
    NSLog(@"Got changedValue: %d", value);
    if (switchCell == self.dealsCell) {
        self.filterSettings.dealsFilter = value;
    } else if (switchCell == self.showAllCategoriesCell) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            [self reloadCategories];
        });
    } else {
        NSInteger row = [self.tableView indexPathForCell:switchCell].row;
        NSString *categoryName = self.currentlyShownCategories[row - 1][@"code"];
        NSArray *filteredCategoryList = [self.filterSettings.activeCategories filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return ![evaluatedObject isEqualToString:categoryName];
        }]];
        NSLog(@"filteredCategoryList = %@", filteredCategoryList);
        NSArray *newCategoryList = filteredCategoryList;
        if (value) {
            newCategoryList = [filteredCategoryList arrayByAddingObject:categoryName];
        }
        NSLog(@"newCategoryList = %@", newCategoryList);

        self.filterSettings.activeCategories = newCategoryList;
    }
}

@end
