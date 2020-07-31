//
//  RepairViewController.m
//  RoadHelper
//
//  Created by Terrell-Jude Ilechie on 7/29/20.
//  Copyright © 2020 Terrell-Jude Ilechie. All rights reserved.
//

#import "RepairViewController.h"

@interface RepairViewController ()

@end

@implementation RepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

  NSURL *url = [NSURL URLWithString:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=39.000990,-76.769780&radius=1000&type=gasstation&keyword=car&key=AIzaSyAt9E5urPXSm4eXcIt97PJl-8NGRo7aiq4"];
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
               for (NSDictionary *gasstation in self.gasstations) {
                   NSLog(@"%@", gasstation[@"business_status"]);
               }

           
               
           
           }
       }];
    [task resume];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
