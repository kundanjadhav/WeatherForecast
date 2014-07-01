//
//  BIDViewController.m
//  WeatherForecast
//
//  Created by Kundan Jadhav on 27/06/14.
//  Copyright (c) 2014 Kundan Jadhav. All rights reserved.
//

#import "BIDViewController.h"
#import "UIColor+FlatUI.h"
#import "UISlider+FlatUI.h"
#import "UIStepper+FlatUI.h"
#import "UITabBar+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "FUIButton.h"
#import "FUISwitch.h"
#import "UIFont+FlatUI.h"
#import "FUIAlertView.h"
#import "UIBarButtonItem+FlatUI.h"
#import "UIProgressView+FlatUI.h"
#import "FUISegmentedControl.h"
#import "UIPopoverController+FlatUI.h"
#import "CELLTableViewCell.h"
#import "UITableViewCell+FlatUI.h"

#define GDQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
@interface BIDViewController ()

@end

@implementation BIDViewController
@synthesize CityName;
@synthesize myTable;
@synthesize maxTemp,minTemp,city,RealTemp,weatherDesc,day;
@synthesize dayArray,tempArray,maxArray,minArray,weatherDescArray,dateArray,mornArray,eveArray,nightArray,humidity,pressure,clouds,windSpeed;
@synthesize image,morning,evening,night,humidityLabel,pressureLabel,speed,cloudsLabel;
@synthesize HUD;
@synthesize label1,label2,label3,label4,label5,label6,label7;


#pragma mark Core location delagates

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation

{
    if (!self.lastLocation) {
        self.lastLocation = newLocation;
    }
    
    if (newLocation.coordinate.latitude != self.lastLocation.coordinate.latitude &&
        newLocation.coordinate.longitude != self.lastLocation.coordinate.longitude) {
        self.lastLocation = newLocation;
        NSLog(@"New location: %f, %f",self.lastLocation.coordinate.latitude,self.lastLocation.coordinate.longitude);
        [self.locationMgr stopUpdatingLocation];
        
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CityName.delegate=self;
    CityName.returnKeyType=UIReturnKeySearch;
    myTable.dataSource=self;
    myTable.delegate=self;
    dayArray=[[NSMutableArray alloc]init];
    tempArray=[[NSMutableArray alloc]init];
    maxArray=[[NSMutableArray alloc]init];
    minArray=[[NSMutableArray alloc]init];
    weatherDescArray=[[NSMutableArray alloc]init];
    dateArray=[[NSMutableArray alloc]init];
    mornArray=[[NSMutableArray alloc]init];
    eveArray=[[NSMutableArray alloc]init];
    nightArray=[[NSMutableArray alloc]init];
    humidity=[[NSMutableArray alloc]init];
    pressure=[[NSMutableArray alloc]init];
    windSpeed=[[NSMutableArray alloc]init];
    clouds=[[NSMutableArray alloc]init];



    CityName.clearButtonMode = UITextFieldViewModeWhileEditing;


    
    self.locationMgr = [[CLLocationManager alloc] init];
    self.locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationMgr.delegate = self;
    
    [self.locationMgr startUpdatingLocation];
    self.lastLocation = nil;
    
    label1.hidden=YES;
    label2.hidden=YES;
    label3.hidden=YES;
    label4.hidden=YES;
    label5.hidden=YES;
    label6.hidden=YES;
    label7.hidden=YES;

    
    
}
//to get forecast details by city name

-(void)getForecaseinfo:(NSString *)getCityName
{
    HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 460) ];
    HUD.labelText = @"Fetching data...";
    [self.view addSubview:HUD];
    [HUD show:YES];


    
    
    getCityName = [getCityName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    
    dispatch_async(GDQueue, ^{
        
        NSString *JSONURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&cnt=14&APPID=af963c335e516a9962c3f653a6c5dd1d",getCityName];
        NSData* dataDirections = [NSData dataWithContentsOfURL:[NSURL URLWithString:JSONURL] ];
        [self performSelectorOnMainThread:@selector(fetchedDataorigin:) withObject:dataDirections waitUntilDone:YES];
        });

    
    
}


- (void)fetchedDataorigin:(NSData *)responseData
{
    NSError* error;
        if (!responseData) {
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"No internet", @"No Internet") message:NSLocalizedString(@"Internet connection problem", @"Internet connection problem") delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay")  otherButtonTitles:nil];
        
        [alert show];
            [HUD hide:YES];
            [HUD removeFromSuperViewOnHide];
    }
    
    else
   
    {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:kNilOptions
                                                               error:&error];

        
        NSString *status=[json valueForKey:@"cod"];
        
        if ([status isEqualToString:@"404"]) {
            
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Invalid city", @"No Internet") message:NSLocalizedString(@"Please check entered city name", @"Internet connection problem") delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay")  otherButtonTitles:nil];
            [alert show];
            
            [HUD hide:YES];
            [HUD removeFromSuperViewOnHide];
            }
        
        else
        
            {
            
            
            NSArray *myArray = [json valueForKey:@"list"];
        
            
                //to get weather icon for today forecast
                //dispatch_async(GDQueue, ^{
                    NSString* code=[[[[myArray objectAtIndex:0]valueForKey:@"weather"]objectAtIndex:0] valueForKey:@"icon"];

                    NSString *JSONURL = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",code];
                    
                    
                    UIImage *imageview = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:JSONURL]]];
                    [image initWithImage:imageview];

               // });

            
            
            
            
            

            NSString *city_str= [[json valueForKey:@"city"]valueForKey:@"name"];
            NSString *country_str= [[json valueForKey:@"city"]valueForKey:@"country"];

            city.text=[NSString stringWithFormat:@"%@  %@",city_str,country_str];
                CityName.text=city_str;


            

            [dayArray removeAllObjects];
            [dateArray removeAllObjects];
            [tempArray removeAllObjects];
            [maxArray removeAllObjects];
            [minArray removeAllObjects];
            [mornArray removeAllObjects];
            [eveArray removeAllObjects];
            [nightArray removeAllObjects];
            [humidity removeAllObjects];
            [pressure removeAllObjects];
            [windSpeed removeAllObjects];
            [clouds removeAllObjects];


            
            [weatherDescArray removeAllObjects];

            
            NSString *temp;
            float realTemp;
            NSString *str;
            //get data from json response
            for (int i=0; i<myArray.count; i++) {
                
                
                NSString *time_string= [[myArray valueForKey:@"dt"]objectAtIndex:i];
                double unixTimeStamp = [time_string doubleValue];
                NSTimeInterval _interval=unixTimeStamp;
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
                NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
                [_formatter setLocale:[NSLocale currentLocale]];
                [_formatter setDateFormat:@"dd.MM.yyyy"];
                NSString *_date=[_formatter stringFromDate:date];
                [dateArray addObject:_date];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"EEEE"];
                NSString *dayName = [dateFormatter stringFromDate:date];
                [dayArray addObject:dayName];
                
                
                temp= [[[myArray valueForKey:@"temp"]objectAtIndex:i] valueForKey:@"day"];
                realTemp= [temp floatValue];
                realTemp = realTemp-273.15;
                str = [NSString stringWithFormat:@"%.1f ºC", realTemp];
                [tempArray addObject:str];
                
                
                
                temp=[[[myArray valueForKey:@"temp"]objectAtIndex:i] valueForKey:@"min"];
                realTemp= [temp floatValue];
                realTemp = realTemp-273.15;
                str = [NSString stringWithFormat:@"%.1f ºC", realTemp];
                [minArray addObject:str];
                
                
                temp=[[[myArray valueForKey:@"temp"]objectAtIndex:i] valueForKey:@"max"];
                realTemp= [temp floatValue];
                realTemp = realTemp-273.15;
                str = [NSString stringWithFormat:@"%.1f ºC", realTemp];
                [maxArray addObject:str];
                
                temp=[[[myArray valueForKey:@"temp"]objectAtIndex:i] valueForKey:@"morn"];
                realTemp= [temp floatValue];
                realTemp = realTemp-273.15;
                str = [NSString stringWithFormat:@"%.1f ºC", realTemp];
                [mornArray addObject:str];
                
                
                temp=[[[myArray valueForKey:@"temp"]objectAtIndex:i] valueForKey:@"eve"];
                realTemp= [temp floatValue];
                realTemp = realTemp-273.15;
                str = [NSString stringWithFormat:@"%.1f ºC", realTemp];
                [eveArray addObject:str];
                
                
                temp=[[[myArray valueForKey:@"temp"]objectAtIndex:i] valueForKey:@"night"];
                realTemp= [temp floatValue];
                realTemp = realTemp-273.15;
                str = [NSString stringWithFormat:@"%.1f ºC", realTemp];
                [nightArray addObject:str];

                
                [weatherDescArray addObject:[[[[myArray objectAtIndex:i]valueForKey:@"weather"]objectAtIndex:0] valueForKey:@"description"]];
                
                
                
                [humidity addObject:[[myArray valueForKey:@"humidity"]objectAtIndex:i]];
                
                
                [pressure addObject:[[myArray valueForKey:@"pressure"]objectAtIndex:i]];
                
                [windSpeed addObject:[[myArray valueForKey:@"speed"]objectAtIndex:i]];

                [clouds addObject:[[myArray valueForKey:@"clouds"]objectAtIndex:i]];


                
                
                //today weather Forecast******
                
                
                
                
                
            }
                RealTemp.text=tempArray[0];
                minTemp.text=[NSString stringWithFormat:@"↓ %.@",minArray[0]];
                maxTemp.text=[NSString stringWithFormat:@"↑ %.@",maxArray[0]];
                weatherDesc.text=weatherDescArray[0];
                day.text=dayArray[0];
                morning.text=mornArray[0];
                evening.text=eveArray[0];
                night.text=nightArray[0];
                humidityLabel.text=[NSString stringWithFormat:@"%.@%%",humidity[0]];
                pressureLabel.text=[NSString stringWithFormat:@"%@hPa",pressure[0]];
                speed.text=[NSString stringWithFormat:@"%.@mps",windSpeed[0]];
                cloudsLabel.text=[NSString stringWithFormat:@"%.@%%",clouds[0]];
                
                
                
                label1.hidden=NO;
                label2.hidden=NO;
                label3.hidden=NO;
                label4.hidden=NO;
                label5.hidden=NO;
                label6.hidden=NO;
                label7.hidden=NO;


            
            [myTable reloadData];
            [self.myTable setContentOffset:CGPointZero animated:YES];
                
            [HUD hide:YES];
            [HUD removeFromSuperViewOnHide];


        }
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [self getForecaseinfo:CityName.text];

        [textField resignFirstResponder];
    return YES;
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 14;//[arrayDistance count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell123";
    CELLTableViewCell *cell = [CELLTableViewCell configureFlatCellWithColor:[UIColor grayColor] selectedColor:[UIColor cloudsColor] reuseIdentifier:CellIdentifier inTableView:(UITableView *)tableView];
    
    if (!cell) {
        cell = [[CELLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell configureFlatCellWithColor:[UIColor greenSeaColor] selectedColor:[UIColor cloudsColor]];
        cell.cornerRadius = 5.f; //Optional
        if (tableView.style == UITableViewStyleGrouped) {
            cell.separatorHeight = 2.f; //Optional
        }
        else {
            cell.separatorHeight = 0.;
        }
    }
    
    if (dayArray.count==0) {
        cell.day.text=@" ";
        cell.date.text=@" ";
        cell.temp.text=@" ";
        cell.weatherDesc.text=@" ";
        cell.min.text=@" ";
        cell.max.text=@" ";


    }
    else{
        cell.day.text=[dayArray objectAtIndex:indexPath.row];
        cell.date.text=[dateArray objectAtIndex:indexPath.row];
        cell.temp.text=[tempArray objectAtIndex:indexPath.row];
       // cell.weatherImage.image=[dayArray objectAtIndex:indexPath.row];
        cell.weatherDesc.text=[weatherDescArray objectAtIndex:indexPath.row];
        
        
        cell.min.text=[NSString stringWithFormat:@"↓%.@",[minArray objectAtIndex:indexPath.row]];
        cell.max.text=[NSString stringWithFormat:@"↑%.@",[maxArray objectAtIndex:indexPath.row]];
        


    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    day.text=[dayArray objectAtIndex:indexPath.row];
   // cell.date.text=[dateArray objectAtIndex:indexPath.row];
    RealTemp.text=[tempArray objectAtIndex:indexPath.row];
    // cell.weatherImage.image=[dayArray objectAtIndex:indexPath.row];
    weatherDesc.text=[weatherDescArray objectAtIndex:indexPath.row];
    humidityLabel.text=[NSString stringWithFormat:@"%.@%%",[humidity objectAtIndex:indexPath.row]];
    pressureLabel.text=[NSString stringWithFormat:@"%.@hPa",[pressure objectAtIndex:indexPath.row]];
    speed.text=[NSString stringWithFormat:@"%.@mps",[windSpeed objectAtIndex:indexPath.row]];
    cloudsLabel.text=[NSString stringWithFormat:@"%.@%%",[clouds objectAtIndex:indexPath.row]];



    
    
    
    
    minTemp.text=[NSString stringWithFormat:@"↓%.@",[minArray objectAtIndex:indexPath.row]];
    maxTemp.text=[NSString stringWithFormat:@"↑%.@",[maxArray objectAtIndex:indexPath.row]];
    morning.text=[NSString stringWithFormat:@"%.@",[mornArray objectAtIndex:indexPath.row]];
    evening.text=[NSString stringWithFormat:@"%.@",[eveArray objectAtIndex:indexPath.row]];
    night.text=[NSString stringWithFormat:@"%.@",[nightArray objectAtIndex:indexPath.row]];


    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

//to get current location usiong GPS
- (IBAction)CurrentLocation:(id)sender {
    
    NSLog(@"New location: %f, %f",self.lastLocation.coordinate.latitude,self.lastLocation.coordinate.longitude);
    
    NSNumber *lat = [[NSNumber alloc] initWithDouble:self.lastLocation.coordinate.latitude];
    NSNumber *log = [[NSNumber alloc] initWithDouble:self.lastLocation.coordinate.longitude];
    
    if ([lat isEqualToNumber:[NSNumber numberWithInt:0]]) {
        
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"SORRY" message:@"Unable to detect your location" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        CityName.text=@"Detecting location....";
        CityName.textColor=[UIColor blueColor];


    dispatch_async(GDQueue, ^{
        
        
        NSString *JSONURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&key=AIzaSyBVwy6PHQAjMNKHFdodn-S3oEo_V_MdmWg",lat,log];
        NSData* dataDirections = [NSData dataWithContentsOfURL:[NSURL URLWithString:JSONURL] ];
        [self performSelectorOnMainThread:@selector(fetchedDataCurrentLocation:) withObject:dataDirections waitUntilDone:YES];
    });

    }
    
}

- (void)fetchedDataCurrentLocation:(NSData *)responseData
{
    NSError* error;
    
    if (!responseData) {
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"No internet", @"No Internet") message:NSLocalizedString(@"Internet connection problem", @"Internet connection problem") delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay")  otherButtonTitles:nil];
        
        [alert show];
        CityName.text=@"No Internet";
        CityName.textColor=[UIColor redColor];
        
    }
    
    else
        
    {
        // TO get city name from google API
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:kNilOptions
                                                               error:&error];NSArray *resultArray = [json valueForKey:@"results"];
        NSArray* subArray=[[resultArray objectAtIndex:0]valueForKey:@"address_components"];
        for (int i=0; i<subArray.count; i++) {
            NSString*types=[[[subArray objectAtIndex:i]valueForKey:@"types"]objectAtIndex:0];
            if ([types isEqualToString:@"administrative_area_level_2"]) {
                NSString *long_name=[[subArray objectAtIndex:i]valueForKey:@"long_name"];
                NSLog(@"%@",long_name);
                
                [self getForecaseinfo:long_name];
                CityName.text=long_name;
                CityName.textColor=[UIColor blackColor];

                                break;
            }
            
          //  NSLog(@"%@",types);
        
        }

       
    }
}
@end
