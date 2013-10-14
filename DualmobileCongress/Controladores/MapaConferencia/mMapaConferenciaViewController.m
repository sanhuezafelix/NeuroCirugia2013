//
//  mMapaConferenciaViewController.m
//  DualmobileCongress
//
//  Created by luis Gonzalez on 12-06-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import "mMapaConferenciaViewController.h"

@interface mMapaConferenciaViewController ()

@end

@implementation mMapaConferenciaViewController

- (void)viewDidLoad
{
    id trackerJornada = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [trackerJornada sendView:@"MapaConferencia"];

    CGRect limitesDeLaPantalla = [[UIScreen mainScreen] bounds];
    if (limitesDeLaPantalla.size.height == 480) {
        
    NSLog(@"el salón maricón pa iphone 4 es: %@",self.salon);
    
        [self callampaDelMapaIphone4];
    }
    else {
    
    NSLog(@"el salón maricón pa iphone 5 es: %@",self.salon);

        [self callampaDelMapaIphone5];
        
    }
    
    mZoomMapas *zoom = [[mZoomMapas alloc]initWithImageMapName:self.NombreMapa atLocation:CGPointMake(0,0) ImageMarkNane:@"pinRed" atLocationMark:CGPointMake(Cordenadax , Cordenaday)];
   
    [self.view addSubview:zoom];
    self.title = @" ";
    
    NSArray *arr = [NSArray arrayWithObjects:
                    @"publi_bot_1.png",@"publi_bot_2.png",@"publi_bot_3.png", nil];
    [self.animationImageView setImagesArr:arr];
    self.animationImageView.showNavigator = NO;
    [self.animationImageView startAnimating];
	
}

-(void)callampaDelMapaIphone4 {

    if ([self.salon isEqualToString:@"Salón 1"])
    {
        Cordenadax = 140;
        Cordenaday = 40;
        self.NombreMapa = @"salonriesco_nivel1.jpg";
        
    }
    else if ([self.salon isEqualToString:@"Salón 2"])
    {
        Cordenadax = 140;
        Cordenaday = 150;
        self.NombreMapa = @"salonriesco_nivel2.jpg";
        
    }
    else if ([self.salon isEqualToString:@"Salón 3"])
    {
        Cordenadax = 250;
        Cordenaday = 200;
        self.NombreMapa = @"salonriesco_nivel2.jpg";
        
    }
    else if ([self.salon isEqualToString:@"Salón 4"])
    {
        Cordenadax = 180;
        Cordenaday = 280;
        self.NombreMapa = @"salonriesco_nivel1.jpg";
        
    }
    else if ([self.salon isEqualToString:@"Salón 5"])
    {
        Cordenadax = 180;
        Cordenaday = 40;
        self.NombreMapa = @"salonriesco_nivel2.jpg";
        
    }
    else
    {
        Cordenadax = 180;
        Cordenaday = 40;
        self.NombreMapa = @"salonriesco_nivel2.jpg";
    }
}
-(void)callampaDelMapaIphone5{

    [self callampaDelMapaIphone4];
    Cordenaday = Cordenaday +60;
    
}


@end
