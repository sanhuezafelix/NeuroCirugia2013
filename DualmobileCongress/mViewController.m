//
//  mViewController.m
//  DualmobileCongress
//
//  Created by luis Gonzalez on 06-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import "mViewController.h"
#import "mAppDelegate.h"
#import "Institucion.h"
#import "Lugar.h"
#import "GAI.h"
#import "Evento.h"
#import "Persona.h"
#import "Notificacion.h"
#import "Eventopadre.h"


@interface mViewController ()

@property (nonatomic,strong) mAppDelegate *delegate;

@end

@implementation mViewController
@synthesize comenzarBoton;

-(void)awakeFromNib{
}



-(void)IniciarSincro{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL estadoAutorizador = [defaults boolForKey:@"kAutorizadorSincronizacion"];
    
    NSTimeInterval intervalIniciaSincro = [defaults floatForKey:@"kIntervaloHoraSincro"];
    
    [defaults setBool:YES forKey:@"kAutorizadorSincronizacion"];
    [defaults synchronize];
    
    self.timerPermiteSincro = [NSTimer scheduledTimerWithTimeInterval:intervalIniciaSincro
                                                               target:self
                                                             selector:@selector(PararSincro)
                                                             userInfo:nil
                                                              repeats:NO];
    NSLog(@" *************** INICIA la Sincro ******************* %d", estadoAutorizador);
    
    
    
}

-(void)PararSincro{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL estadoAutorizador = [defaults boolForKey:@"kAutorizadorSincronizacion"];
    
    
    NSTimeInterval intervalParaSincro = [defaults floatForKey:@"kIntervaloHoraNoSincro"];
    
    [defaults setBool:NO forKey:@"kAutorizadorSincronizacion"];
    [defaults synchronize];
    
    self.timerParaSincro = [NSTimer scheduledTimerWithTimeInterval:intervalParaSincro
                                                            target:self
                                                          selector:@selector(IniciarSincro)
                                                          userInfo:nil
                                                           repeats:NO];
    
    
    NSLog(@"**************** PARA sincro *********************** %d", estadoAutorizador);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = [[UIApplication sharedApplication] delegate];
    
    [self CargaInicialDatos];
    
    [self IniciarSincro];
    
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Ahora"];
    
    
}

- (IBAction)comenzarAccion:(id)sender {
    id eventoComenzar = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [eventoComenzar sendEventWithCategory:@"uiAction"
                               withAction:@"buttonPress"
                                withLabel:@"Presionó botón Comenzar"
                                withValue:nil];
}


- (IBAction)IniciarSesion:(id)sender
{
    //[self CargadorBaseDatosImagenes:@"Imagen"];
    [self Guardar];
    
    if ([self.UserMail.text length]>0 && [self.UserName.text length] >0  && [self.UserSpecialty.text length]>0 )
    {
        NSLog(@"textfield con datos");
    }
}


- (IBAction)CerrarTeclado:(id)sender {
    NSLog(@"apretaste fondo");
    [sender resignFirstResponder];
    [self.UserMail resignFirstResponder];
    [self.UserName resignFirstResponder];
    [self.UserSpecialty resignFirstResponder];
    
}

-(BOOL)VerificarMail:(NSString*)UserMail
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:UserMail];
    
}

#pragma mark - Carga base datos


-(void)CargaInicialDatos
{
    NSFetchRequest *fetchRequestEvento = [[NSFetchRequest alloc] init];
    NSEntityDescription *entidadEvento = [NSEntityDescription entityForName:@"Evento"
                                                     inManagedObjectContext:self.delegate.managedObjectContext];
    [fetchRequestEvento setEntity:entidadEvento];
    NSError *errorEvento;
    NSArray *arrayEvento =     [self.delegate.managedObjectContext executeFetchRequest:fetchRequestEvento error:&errorEvento];
    
    [arrayEvento description];
    
    NSFetchRequest *fetchRequestPersona = [[NSFetchRequest alloc] init];
    NSEntityDescription *entidadPersona = [NSEntityDescription entityForName:@"Persona"
                                                      inManagedObjectContext:self.delegate.managedObjectContext];
    [fetchRequestPersona setEntity:entidadPersona];
    NSError *errorPersona;
    NSArray *arrayPersona = [self.delegate.managedObjectContext executeFetchRequest:fetchRequestPersona error:&errorPersona];
    [arrayPersona description];

   
    NSFetchRequest *fetchRequestLugar = [[NSFetchRequest alloc] init];
    NSEntityDescription *entidadLugar = [NSEntityDescription entityForName:@"Lugar"
                                                inManagedObjectContext:self.delegate.managedObjectContext];
    [fetchRequestLugar setEntity:entidadLugar];
    NSError *errorLugar;
    NSArray *arrayLugar = [self.delegate.managedObjectContext executeFetchRequest:fetchRequestLugar error:&errorLugar];
    [arrayLugar description];

   
    NSFetchRequest *fetchRequestInstitucion = [[NSFetchRequest alloc] init];
    NSEntityDescription *entidadInstitucion = [NSEntityDescription entityForName:@"Institucion"
                                                          inManagedObjectContext:self.delegate.managedObjectContext];
    [fetchRequestInstitucion setEntity:entidadInstitucion];
    NSError *errorInstitucion;
     NSArray *arrayInstitucion = [self.delegate.managedObjectContext executeFetchRequest:fetchRequestInstitucion error:&errorInstitucion];
    [arrayInstitucion description];

    
   
    NSFetchRequest *fetchRequestEventopadre = [[NSFetchRequest alloc] init];
    NSEntityDescription *entidadEventopadre = [NSEntityDescription entityForName:@"Eventopadre"
                                                          inManagedObjectContext:self.delegate.managedObjectContext];
    [fetchRequestEventopadre setEntity:entidadEventopadre];
    NSError *errorEventopadre;
    NSArray *arrayEventopadre =[self.delegate.managedObjectContext executeFetchRequest:fetchRequestEventopadre error:&errorEventopadre];
    [arrayEventopadre description];


    Evento *eventito;
    [eventito.lugarEnQueMeDesarrollo.nombreLugar description];
    [eventito.speaker.nombre description];
    [eventito.speaker.lugarDondeProvengo.nombreLugar description];
    [eventito.eventoPadre.tituloEP description];
    [eventito.eventoPadre.lugarEnQueMeDesarrollo.nombreLugar description];
    
    
}



#pragma mark - Plist Metodos

-(void)Guardar{
    
    NSLog(@"guardando...");
    
    NSDictionary *diccionario = [[NSDictionary alloc]initWithObjectsAndKeys:self.UserName.text,@"Nombre",self.UserMail.text ,@"Mail",self.UserSpecialty.text,@"Especialidad", nil];
    
    [diccionario writeToFile:[self Ruta] atomically:YES];
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Ahora"];
    
}
-(NSString *)Ruta{
    NSString * PathFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"ruta ==> %@",[PathFolder stringByAppendingPathExtension:@"Usuarios.plist"] );
    return [PathFolder stringByAppendingPathExtension:@"Usuarios.plist"];
}

#pragma mark - Eventos Generales de la Vista

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    
}

- (void)viewDidUnload {
    
    [self setUserName:nil];
    [self setUserSpecialty:nil];
    [self setUserMail:nil];
    [self setComenzarBoton:nil];
    [super viewDidUnload];
}



@end