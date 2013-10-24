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
    
    if (self.LugarCelda != NULL) {
        self.Lugar.text = self.LugarCelda;
    }
    else{
        self.Lugar.text = @"";
        [self.BotonMapa setHidden:TRUE];
    }
    
    if (self.EsSimposio) {
        self.Hora.text = self.horacelda;
        self.Expositor.text = [self.Referencia stringByAppendingFormat:@" %@",self.ExpositorCelda];
        self.Titulo.text = self.tituloCelda;
        self.ContenidoExposicion.text = self.ContenidoCelda;
        self.CoordinadorEP.text = self.descEP2;
        self.Actividad.text = self.ActividadSpeaker;
        self.TituloEP.text = self.tituloEP2;
        self.TipoEventoPadre.text = self.tipoEventoPadre2;
        self.infoEP.text = self.descEP2;
        self.lugarEP.text = self.lugarEP2;
        self.HoraEP.text = self.horaEP2;
        self.ActividadEP.text = self.tipoEventoPadre2;
        self.lugarEP.text = self.LugarsimposioPadre;
        self.labelBarra.text = self.nombreBarra;
        self.BotonSimposio.hidden = false;
        self.ContenidoExposicion.hidden = true;
        
        
    }else{
        self.Hora.text = self.horacelda;
        self.Expositor.text = [self.Referencia stringByAppendingFormat:@" %@",self.ExpositorCelda];
        self.Titulo.text = self.tituloCelda;
        self.ContenidoExposicion.text = self.ContenidoCelda;
        self.CoordinadorEP.text = self.descEP2;
        self.Actividad.text = self.ActividadSpeaker;
        self.TituloEP.text = self.tituloCelda;
        self.TipoEventoPadre.text = self.ActividadSpeaker;
        self.infoEP.text = self.ContenidoCelda;
        self.lugarEP.text = self.LugarCelda;
        self.HoraEP.text = self.horacelda;
        self.ActividadEP.text = self.ActividadSpeaker;
        self.labelBarra.text = self.nombreBarra;
        self.BotonSimposio.hidden = true;
        self.ContenidoExposicion.hidden = false;


    }
    
    
        NSLog(@"Contenido Nombre simposio==> %@",self.NombreSimposioPadre);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <6.0f)
    {
        [self.BotonPublicarFacebook setHidden:YES];
        [self.BotonPublicacionTwet setHidden:YES];
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self              action:@selector(imageTapped:)];
    self.animationImageView.userInteractionEnabled = YES;
    [self.animationImageView addGestureRecognizer:tap];
    
}
- (void )imageTapped:(UITapGestureRecognizer *) gestureRecognizer
{
    NSLog(@"tap imagen");
    id TokeImagenTracking = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [TokeImagenTracking sendEventWithCategory:@"uiAction"
                                   withAction:@"Tap Publicidad"
                                    withLabel:@"Tap Branding Principal"
                                    withValue:nil];
    
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
        
      
        
       /* self.MensajeInicial = [[NSString alloc]initWithFormat:@"Estoy en %@ de %@ Expone %@ ", self.ActividadSpeaker,self.tituloCelda , self.Expositor.text ];*/
         self.MensajeInicial = [[NSString alloc]initWithFormat:@"Estoy en %@, XXXI Congreso Sopnia ", self.tituloCelda ];
        
       
        
        Facebook.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [Facebook setInitialText:self.MensajeInicial];
        [Facebook addImage:[UIImage imageNamed:@"logoSopnia"]];
        [Facebook addURL:[NSURL URLWithString:@"http://www.sopnia.com"]];
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
      self.MensajeInicial = [[NSString alloc]initWithFormat:@"Estoy en %@, XXXI Congreso Sopnia ", self.tituloCelda ];
        
        twitter.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [twitter addImage:[UIImage imageNamed:@"logoSopnia"]];
        [twitter addURL:[NSURL URLWithString:@"http://www.sopnia.com"]];
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
    if ([segue.identifier isEqualToString:@"DetSimposio"])
    {
         mSimposioDetViewController *destino = (mSimposioDetViewController *)segue.destinationViewController;
        
        destino.EsSimposio = TRUE;
        destino.tituloCelda = self.NombreSimposioPadre;
        destino.ContenidoeventoHijoCelda = self.TipoSimposioPadre;
        destino.horacelda = self.HorasimposioPadre;
        destino.LugarCelda = self.LugarsimposioPadre;
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
    if (self.LugarCelda != NULL) {
        evento.location = self.LugarCelda;
        evento.notes =self.ContenidoCelda;
        if (self.tituloCelda != NULL&& self.ContenidoCelda != NULL) {
            NSString * titulo = [[NSString alloc]initWithFormat:@"%@ - ",self.tituloCelda];
            titulo = [titulo stringByAppendingString:self.ExpositorCelda];
            evento.title     = titulo;
        }
        else{
            evento.title     = self.tituloCelda;
            
        }
        
    }
    else{
        evento.title     = self.tituloCelda;
        
    }
    
    evento.startDate = self.DateInicio;
    evento.endDate   = self.DateFin;
    evento.allDay = NO;
    
    evento.URL = [NSURL URLWithString:@"http://www.sopnia.com"];
    
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
