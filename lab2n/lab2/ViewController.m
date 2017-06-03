//
//  ViewController.m
//  lab2
//
//  Created by Admin on 14.04.17.
//  Copyright (c) 2017 student. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *indicator;
@property(nonatomic)CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    //[self.locationManager stopUpdatingLocation];
    
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)refresh:(id)sender {
    [_locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    NSString *geoCoords;
    if (currentLocation != nil) {
        geoCoords = [NSString stringWithFormat:@"(%.8f%%2C%%20%.8f)", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
    }
    
    NSURL *url = [[NSURL alloc] initWithString:[@[@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places%20where%20text%3D%22", geoCoords, @"%22)%20and%20u%3D'c'&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"] componentsJoinedByString:@""]];
    
    NSData *contents = [[NSData alloc] initWithContentsOfURL:url];
    NSDictionary *forecasting = [NSJSONSerialization JSONObjectWithData:contents options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *currentForecast = [[[[forecasting valueForKey:@"query"] valueForKey:@"results"]valueForKey:@"channel"]valueForKey:@"item"];
    
    NSString *lowTemperature = [[currentForecast valueForKey:@"condition"] valueForKey:@"temp"];
    
    double temperature = [lowTemperature doubleValue];
    
    [self.indicator setText:[NSString stringWithFormat:@"%.1f", temperature]];
    if(temperature > 25) [[self indicator] setTextColor:[UIColor redColor]];
    else if(temperature > 5) [[self indicator] setTextColor:[UIColor yellowColor]];
    else [[self indicator] setTextColor:[UIColor blueColor]];
    
    [_locationManager stopUpdatingLocation];
    
}

@end
