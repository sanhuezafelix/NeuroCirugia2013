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
    id trackerJornada = [[GAI sharedInstance] trackerWithTrackingId:@"UA-37133331-3"];
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
                    @"publi_bot_1.png",@"publi_bot_2.png", nil];
    [self.animationImageView setImagesArr:arr];
    self.animationImageView.showNavigator = NO;
    [self.animationImageView startAnimating];
	
}

-(void)callampaDelMapaIphone4 {
    
    if ([self.salon isEqualToString:@"Salón Bombal A"])
    {
        Cordenadax = 130;
        Cordenaday = 85;
        self.NombreMapa = @"lobby.png";
        
    }
    else if ([self.salon isEqualToString:@"Salón Bombal B"])
    {
        Cordenadax = 130;
        Cordenaday = 30;
        self.NombreMapa = @"lobby.png";
        
    }
    else if ([self.salon isEqualToString:@"Salón Bombal A-B"])
    {
        Cordenadax = 115;
        Cordenaday = 55;
        self.NombreMapa = @"lobby.png";
        
    }
    else if ([self.salon isEqualToString:@"Terraza"])
    {
        Cordenadax = 180;
        Cordenaday = 280;
        self.NombreMapa = @"piso_2.png";
        
    }
    else if ([self.salon isEqualToString:@"Salón Sausalito A-B"])
    {
        Cordenadax = 102;
        Cordenaday = 115;
        self.NombreMapa = @"piso_2.png";
        
    }
    
    else if ([self.salon isEqualToString:@"Salón Sausalito A"])
    {
        Cordenadax = 102;
        Cordenaday = 115;
        self.NombreMapa = @"piso_2.png";
        
    }
    
    
    else if ([self.salon isEqualToString:@"Salón Sausalito B"])
    {
        Cordenadax = 102;
        Cordenaday = 115;
        self.NombreMapa = @"piso_2.png";
        
    }
    
    
    else if ([self.salon isEqualToString:@"Salón Miramar"])
    {
        Cordenadax = 90;
            // 90 90
        Cordenaday = 90;
        self.NombreMapa = @"zocalo.png";
        
    }
    
    else if ([self.salon isEqualToString:@"Salón Vergara A"])
    {
        Cordenadax = 150;
        Cordenaday = 125;
        self.NombreMapa = @"zocalo.png";
        
    }
    
    else if ([self.salon isEqualToString:@"Salón Vergara B"])
    {
        Cordenadax = 150;
        Cordenaday = 40;
        self.NombreMapa = @"zocalo.png";
        
    }
    
    else if ([self.salon isEqualToString:@"Salón Vergara C"])
    {
        Cordenadax = 150;
        Cordenaday = 30;
        self.NombreMapa = @"zocalo.png";
        
    }
    
    else if ([self.salon isEqualToString:@"Salón Vergara A-B-C"])
    {
        Cordenadax = 150;
        Cordenaday = 40;
        self.NombreMapa = @"zocalo.png";
        
    }
    
    else
    {
        Cordenadax = 180;
        Cordenaday = 40;
        self.NombreMapa = @"salonriesco_nivel2.jpg";
    }
}
-(void)callampaDelMapaIphone5{
    
    if ([self.salon isEqualToString:@"Salón Bombal A"])
    {
        Cordenadax = 160;
        Cordenaday = 110;
        self.NombreMapa = @"lobby.png";
        
    }
    else if ([self.salon isEqualToString:@"Salón Bombal B"])
    {
        Cordenadax = 160;
        Cordenaday = 40;
        self.NombreMapa = @"lobby.png";
        
    }
    else if ([self.salon isEqualToString:@"Salón Bombal A-B"])
    {
        Cordenadax = 130;
        Cordenaday = 80;
        self.NombreMapa = @"lobby.png";
        
    }
    else if ([self.salon isEqualToString:@"Terraza"])
    {
        Cordenadax = 120;
        Cordenaday = 280;
        self.NombreMapa = @"piso_2.png";
        
    }
    else if ([self.salon isEqualToString:@"Salón Sausalito A-B"])
    {
        Cordenadax = 127;
        Cordenaday = 160;
        self.NombreMapa = @"piso_2.png";
        
    }
    
    else if ([self.salon isEqualToString:@"Salón Sausalito A"])
    {
        Cordenadax = 127;
        Cordenaday = 160;
        self.NombreMapa = @"piso_2.png";
        
    }
    
    
    else if ([self.salon isEqualToString:@"Salón Sausalito B"])
    {
        Cordenadax = 127;
        Cordenaday = 160;
        self.NombreMapa = @"piso_2.png";
        
    }
    
    
    else if ([self.salon isEqualToString:@"Salón Miramar"])
    {
        Cordenadax = 113;
        Cordenaday = 120;
        self.NombreMapa = @"piso_2.png";
        
    }
    
    else if ([self.salon isEqualToString:@"Salón Vergara A"])
    {
        Cordenadax = 180;
        Cordenaday = 165;
        self.NombreMapa = @"zocalo.png";
        
    }
    
    else if ([self.salon isEqualToString:@"Salón Vergara B"])
    {
        Cordenadax = 180;
        Cordenaday = 110;
        self.NombreMapa = @"zocalo.png";
        
    }
    
    else if ([self.salon isEqualToString:@"Salón Vergara C"])
    {
        Cordenadax = 180;
        Cordenaday = 50;
        self.NombreMapa = @"zocalo.png";
        
    }
    
    else if ([self.salon isEqualToString:@"Salón Vergara A-B-C"])
    {
        Cordenadax = 180;
        Cordenaday = 110;
        self.NombreMapa = @"zocalo.png";
        
    }
    
    else
    {
        Cordenadax = 180;
        Cordenaday = 40;
        self.NombreMapa = @"salonriesco_nivel2.jpg";
    }
}

@end
