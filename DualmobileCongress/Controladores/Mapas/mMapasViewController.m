//
//  mMapasViewController.m
//  DualmobileCongress
//
//  Created by luis Gonzalez on 11-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import "mMapasViewController.h"
#import "REPagedScrollView.h"
#import "mZoomMapas.h"
#import "GAI.h"


@interface mMapasViewController ()

@end

@implementation mMapasViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     //trackenado GA
        
    id trackerMapa = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [trackerMapa sendView:@"Mapa"];
    

    
    UIImage *barButtonImage = [[UIImage imageNamed:@"btnmenu.png"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
    [self.BotonMenu setBackgroundImage:barButtonImage
                              forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.title= @" ";
    UIImage *NotButtonImage = [[UIImage imageNamed:@"boton_nota"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
    [self.BotonNotificaciones setBackgroundImage:NotButtonImage
                              forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
       self.title = @" ";
    
    NSArray *arr = [NSArray arrayWithObjects:
                    @"aimagos.png",@"publicidad_ahora.png", nil];
    [self.animationImageView setImagesArr:arr];
    self.animationImageView.showNavigator = NO;
    [self.animationImageView startAnimating];


    [self IniciarPageView];
   
}

-(void)IniciarPageView{
    REPagedScrollView *scrollView = [[REPagedScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    mZoomMapas *zoom = [[mZoomMapas alloc]initWithImageMapName:@"salonriesco_nivel1.jpg" atLocation:CGPointMake(5, 5)];
    [scrollView addPage:zoom];
    zoom = [[mZoomMapas alloc]initWithImageMapName:@"salonriesco_nivel2.jpg" atLocation:CGPointMake(5, 5)];
    [scrollView addPage:zoom];

}

- (void)viewDidUnload {
    [self setBotonMenu:nil];
    [super viewDidUnload];
}
- (IBAction)RevelarMenuLateral:(id)sender {
     [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)RevelarNotificaciones:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECLeft];
}
@end
