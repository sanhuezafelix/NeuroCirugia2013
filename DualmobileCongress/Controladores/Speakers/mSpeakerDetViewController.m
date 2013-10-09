//
//  mSpeakerDetViewController.m
//  DualmobileCongress
//
//  Created by luis Gonzalez on 31-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import "mSpeakerDetViewController.h"
#import "mAppDelegate.h"
#import "GAI.h"

@interface mSpeakerDetViewController ()
@property(nonatomic,strong)mAppDelegate *delegate;
@end

@implementation mSpeakerDetViewController

-(void)awakeFromNib{
    [self.DetailSpeakerTableview reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     //trackenado GA
        
    id trackerDetalleSpeaker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [trackerDetalleSpeaker sendView:@"DetalleSpeaker"];
    

    UIImage *NotButtonImage = [[UIImage imageNamed:@"boton_nota"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
    [self.BotonNotificaciones setBackgroundImage:NotButtonImage
                                        forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    self.title = @" ";
    self.delegate = [[UIApplication sharedApplication]delegate];
    self.NombreSpeaker.text = [self.ReferenciaSpeaker stringByAppendingFormat:@" %@",self.Nombrecelda];
    self.PaisSpeaker.text = self.Paiscelda;
    self.ImageViewSpeaker.image = self.ImagenDelSpeaker;
    if (self.Institucioncelda== nil) {
        NSLog(@"es nulo");
       

    }
    else{
        NSLog(@"no es nulo");
         self.InstitucionSpeaker.text = self.Institucioncelda;
    }
    self.Biografia.text = self.BiografiaCelda;
    
    NSLog(@"nombre: %@ Pais %@ Institucion %@", self.Nombrecelda , self.Paiscelda , self.Institucioncelda);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (IBAction)RevelarNotificaciones:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}


- (void)viewDidUnload {
    
    [self setBotonNotificaciones:nil];
    [self setDetailSpeakerTableview:nil];
    [self setNombreSpeaker:nil];
    [self setPaisSpeaker:nil];
    [self setInstitucionSpeaker:nil];
    [self setTitulosSpeaker:nil];
    [self setImageViewSpeaker:nil];
    [self setBiografia:nil];
    [super viewDidUnload];
}

@end
