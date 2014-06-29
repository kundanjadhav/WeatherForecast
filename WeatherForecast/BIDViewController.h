//
//  BIDViewController.h
//  WeatherForecast
//
//  Created by Kundan Jadhav on 27/06/14.
//  Copyright (c) 2014 Kundan Jadhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"


@interface BIDViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    
    
    
    
}

@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UILabel *label4;
@property (strong, nonatomic) IBOutlet UILabel *label5;
@property (strong, nonatomic) IBOutlet UILabel *label6;
@property (strong, nonatomic) IBOutlet UILabel *label7;


@property(nonatomic,strong)MBProgressHUD *HUD;

@property (nonatomic, retain) CLLocation *lastLocation;
@property (nonatomic, retain) CLLocationManager *locationMgr;

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property(strong,nonatomic)NSMutableArray *dateArray;
@property(strong,nonatomic)NSMutableArray *dayArray;
@property(strong,nonatomic)NSMutableArray *tempArray;
@property(strong,nonatomic)NSMutableArray *minArray;
@property(strong,nonatomic)NSMutableArray *maxArray;
@property(strong,nonatomic)NSMutableArray *mornArray;
@property(strong,nonatomic)NSMutableArray *eveArray;
@property(strong,nonatomic)NSMutableArray *nightArray;

@property(strong,nonatomic)NSMutableArray *weatherDescArray;
@property(strong,nonatomic)NSMutableArray *humidity;
@property(strong,nonatomic)NSMutableArray *pressure;
@property(strong,nonatomic)NSMutableArray *windSpeed;
@property(strong,nonatomic)NSMutableArray *clouds;

@property (strong, nonatomic) IBOutlet UILabel *morning;
@property (strong, nonatomic) IBOutlet UILabel *evening;
@property (strong, nonatomic) IBOutlet UILabel *night;
@property (strong, nonatomic) IBOutlet UILabel *humidityLabel;
@property (strong, nonatomic) IBOutlet UILabel *pressureLabel;
@property (strong, nonatomic) IBOutlet UILabel *speed;
@property (strong, nonatomic) IBOutlet UILabel *cloudsLabel;

@property (strong, nonatomic) IBOutlet UILabel *day;
@property (strong, nonatomic) IBOutlet UILabel *weatherDesc;
@property (strong, nonatomic) IBOutlet UILabel *RealTemp;
@property (strong, nonatomic) IBOutlet UILabel *minTemp;
@property (strong, nonatomic) IBOutlet UILabel *maxTemp;
@property (strong, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) IBOutlet UITextField *CityName;
- (IBAction)CurrentLocation:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *myTable;


@end
