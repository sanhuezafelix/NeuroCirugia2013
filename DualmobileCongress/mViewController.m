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



- (void)viewDidLoad
{
    [super viewDidLoad];

    self.delegate = [[UIApplication sharedApplication] delegate];
    
    [self CargadorBaseDatosNoImagenes];


//    NSArray *nombresEntidad = [[NSArray alloc] init];
//    nombresEntidad = [NSArray arrayWithObjects:@"Evento", @"Persona", @"Lugar",@"Eventopadre",@"Notificacion",@"Institucion", nil];
    
    [self activaInicioTimer];
    
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Ahora"];


    if ([[NSFileManager defaultManager]fileExistsAtPath:[self Ruta]] == TRUE) {
        self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Ahora"];
        
        
    }
}

- (IBAction)comenzarAccion:(id)sender {
    
    [self CargadorBaseDatosNoImagenes];


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

//-(void)CargadorBaseDatosImagenes:(NSString*)entidadImagen;
//{
//    
//        
//        [self.ActividadServidor startAnimating];
//        NSFetchRequest *fetchRequestImagen = [[NSFetchRequest alloc] init];
//        // asignamos el nombre de la entidad a utilizar
//        NSEntityDescription *entidad = [NSEntityDescription entityForName:entidadImagen
//                                                   inManagedObjectContext:self.delegate.managedObjectContext];
//        [fetchRequestImagen setEntity:entidad];
//        NSError *error;
//        NSArray *fetchedObjectsImagen = [self.delegate.managedObjectContext executeFetchRequest:fetchRequestImagen
//                                                                           error:&error];
//        [self.ActividadServidor stopAnimating];
//
//    // <---NSLog
//    
//    NSLog(@"IMAGENES %@", [fetchRequestImagen description]);
//    
//    // NSLog--->
//}
    
-(void)CargadorBaseDatosNoImagenes
{
    
    
    NSFetchRequest *fetchRequestLugar = [[NSFetchRequest alloc] init];
    // asignamos el nombre de la entidad a utilizar
    NSEntityDescription *entidadLugar = [NSEntityDescription entityForName:@"Lugar"
                                               inManagedObjectContext:self.delegate.managedObjectContext];
    [fetchRequestLugar setEntity:entidadLugar];
    NSError *errorLugar;
    NSArray *fetchedObjectsLugar = [self.delegate.managedObjectContext executeFetchRequest:fetchRequestLugar error:&errorLugar];
    
    // <---NSLog
    //
    NSLog(@"Objetos %@", [fetchedObjectsLugar objectEnumerator]);
    
    
    
    NSFetchRequest *fetchRequestEvento = [[NSFetchRequest alloc] init];
    // asignamos el nombre de la entidad a utilizar
    NSEntityDescription *entidadEvento = [NSEntityDescription entityForName:@"Evento"
                                               inManagedObjectContext:self.delegate.managedObjectContext];
    [fetchRequestEvento setEntity:entidadEvento];
    NSError *errorEvento;
    NSArray *fetchedObjectsEvento = [self.delegate.managedObjectContext executeFetchRequest:fetchRequestEvento error:&errorEvento];
    
    // <---NSLog
    //
    NSLog(@"Objetos %@", [fetchedObjectsEvento objectEnumerator]);
    
    
    
    NSFetchRequest *fetchRequestPersona = [[NSFetchRequest alloc] init];
    // asignamos el nombre de la entidad a utilizar
    NSEntityDescription *entidadPersona = [NSEntityDescription entityForName:@"Persona"
                                               inManagedObjectContext:self.delegate.managedObjectContext];
    [fetchRequestPersona setEntity:entidadPersona];
    NSError *errorPersona;
    NSArray *fetchedObjectsPersona = [self.delegate.managedObjectContext executeFetchRequest:fetchRequestPersona error:&errorPersona];
    
    // <---NSLog
    //
    NSLog(@"Objetos %@", [fetchedObjectsPersona objectEnumerator]);
    
    
    
    NSFetchRequest *fetchRequestInstitucion = [[NSFetchRequest alloc] init];
    // asignamos el nombre de la entidad a utilizar
    NSEntityDescription *entidadInstitucion = [NSEntityDescription entityForName:@"Institucion"
                                               inManagedObjectContext:self.delegate.managedObjectContext];
    [fetchRequestInstitucion setEntity:entidadInstitucion];
    NSError *errorInstitucion;
    NSArray *fetchedObjectsInstitucion = [self.delegate.managedObjectContext executeFetchRequest:fetchRequestInstitucion error:&errorInstitucion];
    
    // <---NSLog
    //
    NSLog(@"Objetos %@", [fetchedObjectsInstitucion objectEnumerator]);
    
}

-(void)activaInicioTimer{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:NO forKey:@"kCanceladorInicioTimer"];
    
    [defaults synchronize];
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
    
    [self activaInicioTimer];
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
