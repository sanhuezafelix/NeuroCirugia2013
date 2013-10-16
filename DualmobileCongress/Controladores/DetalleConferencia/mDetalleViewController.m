//
//  mDetalleViewController.m
//  DualmobileCongress
//
//  Created by luis Gonzalez on 07-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import "mDetalleViewController.h"
#import "mAppDelegate.h"
#import "GAI.h"


@interface mDetalleViewController ()
@property(nonatomic,strong)mAppDelegate *delegate;
@end

@implementation mDetalleViewController

-(void)awakeFromNib{
    UIImage *NotButtonImage = [[UIImage imageNamed:@"boton_nota"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
    [self.BotonNotificaciones setBackgroundImage:NotButtonImage
                                        forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //trackenado GA
    id trackerDetalleConferencia = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [trackerDetalleConferencia sendView:@"Detalle Conferencia"];
    self.Hora.text = self.horacelda;
    self.Expositor.text = [self.Referencia stringByAppendingFormat:@" %@",self.ExpositorCelda];
    self.Titulo.text = self.tituloCelda;
    self.ContenidoExposicion.text = self.ContenidoCelda;
    self.imagen.image = self.imagenEX;
    self.Lugar.text = self.LugarCelda;
    self.imagen.image = self.NombreImagen;
    self.Actividad.text = self.ActividadSpeaker;
   // NSLog(@"Titulo Celda ==> %@",self.tituloCelda);
      NSLog(@"Contenido Celda expocicion ==> %@",self.ContenidoCelda);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <6.0f)
    {
        [self.BotonPublicarFacebook setHidden:YES];
        [self.BotonPublicacionTwet setHidden:YES];
    }
    if (([self.Titulo.text isEqualToString:@"Almuerzo"]==TRUE)||([self.Titulo.text isEqualToString:@"Coffee Break"]==TRUE))
    {
        [self.botonDeTalleSpeaker setHidden:YES];
    }
    if (!self.EsSimposio) {
              self.DetailTableview.hidden = true;
        self.labelSimposio.hidden = true;
    }
    self.delegate = [[UIApplication sharedApplication]delegate];
    
   
    UIImage *NotButtonImage = [[UIImage imageNamed:@"boton_nota"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
    [self.BotonNotificaciones setBackgroundImage:NotButtonImage
                                        forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    self.title = @" ";
  
    
    NSArray *arr = [NSArray arrayWithObjects:
                    @"publi_bot_1.png",@"publi_bot_2.png",@"publi_bot_3.png", nil];
    [self.animationImageView setImagesArr:arr];
    self.animationImageView.showNavigator = NO;
    [self.animationImageView startAnimating];
    
}


- (IBAction)PublicaEnFaceBook:(id)sender {
    
    
    SLComposeViewController *Facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewControllerCompletionHandler completionHandler = ^(SLComposeViewControllerResult result)
        {
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"La publicación ha sido cancelada.");
                    
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Se ha publicado satisfactoriamente.");
                    [self socialTracking:@"Facebook" :@"Share"];
                    
                    
                    break;
                default:
                    break;
            }
            
            
        };
        
        if (([self.Titulo.text isEqualToString:@"Almuerzo"]==TRUE)||([self.Titulo.text isEqualToString:@"Coffee Break"]==TRUE))
        {
            self.MensajeInicial = [[NSString alloc]initWithFormat:@"Estoy en %@, desde mCongress", self.tituloCelda  ];
        }
        else
        {
            self.MensajeInicial = [[NSString alloc]initWithFormat:@"Estoy en %@ de %@ Expone %@ ", self.ActividadSpeaker,self.tituloCelda , self.Expositor.text ];
        }
        
        Facebook.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [Facebook setInitialText:self.MensajeInicial];
        [Facebook addImage:[UIImage imageNamed:@"mcongress_icon_114"]];
        [Facebook addURL:[NSURL URLWithString:@"http://www.mobicongress.com"]];
        [Facebook setCompletionHandler:completionHandler];
        [self presentViewController:Facebook animated:YES completion:nil];
    }
    
    //Pa la interacción social con feibu.
}

-(void)socialTracking:(NSString*)send:(NSString*)action{
    
    id socialTracking= [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [socialTracking sendSocial:send
                    withAction:action
                    withTarget:nil];
    
}

- (IBAction)PublicaEnTwiter:(id)sender {
    
    SLComposeViewController *twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewControllerCompletionHandler completionHandler = ^(SLComposeViewControllerResult result)
        {
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"La publicación ha sido cancelada.");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Se ha publicado satisfactoriamente.");
                    [self socialTracking:@"Twitter" :@"Tweet"];
                    
                    break;
                default:
                    break;
            }
        };
        
        if (([self.Titulo.text isEqualToString:@"Almuerzo"]==TRUE)||([self.Titulo.text isEqualToString:@"Coffee Break"]==TRUE))
        {
            self.MensajeInicial = [[NSString alloc]initWithFormat:@"Estoy en %@, desde mCongress", self.tituloCelda  ];
        }
        else
        {
            self.MensajeInicial = [[NSString alloc]initWithFormat:@"Estoy en %@ de %@ Expone %@ ", self.ActividadSpeaker,self.tituloCelda , self.Expositor.text ];
        }
        
        twitter.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [twitter addImage:[UIImage imageNamed:@"mcongress_icon_120"]];
        [twitter addURL:[NSURL URLWithString:@"http://www.mobicongress.com"]];
        [twitter setInitialText:self.MensajeInicial];
        [twitter setCompletionHandler:completionHandler];
        
        [self presentViewController:twitter animated:YES completion:nil];
    }
    
    
    //Interacción social con twitter.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Comprobamos si el identificador es el adecuado
    
    if ([segue.identifier isEqualToString:@"MapSpeaker"])
    {
        mMapaConferenciaViewController *destino = (mMapaConferenciaViewController *)segue.destinationViewController;
        
        destino.salon = self.LugarCelda;
    }
}


- (IBAction)RevelarMenuLateral:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECLeft];
    id eventoMenuLateral = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [eventoMenuLateral sendEventWithCategory:@"uiAction"
                                  withAction:@"buttonPress"
                                   withLabel:@"Interactúo con Menú Lateral"
                                   withValue:nil];
}

- (IBAction)GuardarCalendario:(id)sender
{
    
    UIImage *navBackgroundImage = [UIImage imageNamed:@"navbar_about"];
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    EKEventStore *AlmacenEventos = [[EKEventStore alloc] init];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >=6.0f) {
        EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
        if([AlmacenEventos respondsToSelector:@selector(requestAccessToEntityType:completion:)])
        {
            NSLog(@"status : %d",status);
            [AlmacenEventos requestAccessToEntityType:status completion:^(BOOL permiso, NSError *error) {
                if (permiso== true) {
                    NSLog(@"***** granted ***** :");
                    
                }}];}}
    
    EKEvent *evento  = [EKEvent eventWithEventStore:AlmacenEventos];
    if ([self.tituloCelda isEqualToString:@"Coffee Break"]==TRUE || [self.tituloCelda isEqualToString:@"Almuerzo"]== TRUE )
    {
        evento.title     = self.tituloCelda;
    }
    else
    {
        NSString * titulo = [[NSString alloc]initWithFormat:@"%@ - ",self.tituloCelda];
        titulo = [titulo stringByAppendingString:self.ExpositorCelda];
        evento.title     = titulo;
    }
    evento.location = self.LugarCelda;
    evento.startDate = self.DateInicio;
    evento.endDate   = self.DateFin;
    evento.allDay = NO;
    evento.notes =self.ContenidoCelda;
    evento.URL = [NSURL URLWithString:@"http://www.aimagos.com/index.php/es/"];
    
    EKEventEditViewController *controlador = [[EKEventEditViewController alloc]init];
    
    controlador.eventStore = AlmacenEventos;
    controlador.event = evento;
    controlador.topViewController.view.backgroundColor = [UIColor grayColor];
    
    UIImage *ImagenBotonCalendario = [[UIImage imageNamed:@"boton_vacio"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 7)];
    
    [[UIBarButtonItem appearance] setBackgroundImage:ImagenBotonCalendario forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    controlador.topViewController.title = @" ";
    controlador.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:controlador animated:YES];
    controlador.editViewDelegate = self;
    
    id gaiBotonCalendario = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [gaiBotonCalendario sendEventWithCategory:@"uiAction"
                                   withAction:@"Revelar Calendario"
                                    withLabel:@"Revelo el calendario"
                                    withValue:nil];
}

-(void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setTitulo:nil];
    [self setHora:nil];
    [self setExpositor:nil];
    [self setBotonPublicarFacebook:nil];
    [self setContenidoExposicion:nil];
    [self setBotonNotificaciones:nil];
    [self setRol:nil];
    [self setLugar:nil];
    [self setBotonImagenExpositor:nil];
    [self setBotonPublicacionTwet:nil];
    [self setBotonDeTalleSpeaker:nil];
    [super viewDidUnload];
}




@end
