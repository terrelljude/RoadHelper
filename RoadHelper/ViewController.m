//
//  ViewController.m
//  RoadHelper
//
//  Created by Terrell-Jude Ilechie on 7/17/20.
//  Copyright © 2020 Terrell-Jude Ilechie. All rights reserved.
//

#import "ViewController.h"
#import "RepairTableViewCell.h"

static UIColor *convertRatingIntoColor(CGFloat rating) {
    if (rating < 2.5) {
        return [UIColor redColor];
    } else if (rating < 4.0) {
        return [UIColor clearColor];
    } else {
        return [UIColor greenColor];
    }
}


@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

//@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *gasstations;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    NSURL *url = [NSURL URLWithString:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=39.000990,-76.769780&radius=5000&type=gas_station&key=AIzaSyCzJRqiTrPCQGVsDpQGVL60vGfbe0GVKNI"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog (@"%@", dataDictionary);
            
            self.gasstations = dataDictionary[@"results"];
            [self.tableView reloadData];
        }
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Configure the view for the selected state
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    if (self.gasstations.count > 0){
        cell.textLabel.text = self.gasstations[indexPath.row][@"name"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%1@",self.gasstations[indexPath.row][@"rating"]];
        cell.backgroundColor = convertRatingIntoColor([self.gasstations[indexPath.row][@"rating"] floatValue]);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?place_id=%@&fields=formatted_phone_number&key=AIzaSyCzJRqiTrPCQGVsDpQGVL60vGfbe0GVKNI",self.gasstations[indexPath.row][@"place_id"]]];
   NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
   NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
   NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       if (error != nil) {
           NSLog(@"%@", [error localizedDescription]);
       } else {
           NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           NSString *phNo = dataDictionary[@"result"][@"formatted_phone_number"];
           NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phNo]];
           
           if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
               [[UIApplication sharedApplication] openURL:phoneUrl];
           }
           
       }
   }];
   [task resume];
}

@end
