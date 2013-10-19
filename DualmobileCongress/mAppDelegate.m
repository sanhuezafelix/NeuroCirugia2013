//
//  mAppDelegate.m
//  DualmobileCongress
//
//  Created by luis Gonzalez on 06-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import "mAppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "mCongressIncrementalStore.h"
#import "mConexionRed.h"
#import "Orbiter.h"
#import "GAI.h"
#import "Eventopadre.h"
#import "Persona.h"
#import "Lugar.h"
#import "Evento.h"
#import "Institucion.h"
#import "Notificacion.h"
#import "mCongressAPIClient.h"

static NSString *const kStoreName = @"Congresos.sqlite";

@implementation mAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    //Creamos un NSUSerDefault para soportar el control de la sincronización por intervalos de tiempo
    [self NotificacionLocal];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {}
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (![defaults boolForKey:@"kValoresGuardados"])
    {
        NSDictionary *defaultValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithFloat:7.0], @"kIntervaloHoraSincro",
                                       
                                       [NSNumber numberWithFloat:30.0], @"kIntervaloHoraNoSincro",
                                       [NSNumber numberWithBool:YES], @"kAutorizadorSincronizacion",
                                       [NSNumber numberWithBool:YES], @"kPrimeraSincro",
                                       
                                       
                                       [NSNumber numberWithBool:YES], @"kValoresGuardados",
                                       nil];
        
        [defaults registerDefaults:defaultValues];
    }
    
    
    
    // Opcional: envia automáticamente excepciones no controladas de nuestra app a Google.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Opcional: establece 20 segundos como intervalo para comunicar con Google.
    [GAI sharedInstance].dispatchInterval = 20;
    // Opcional: activa el modo debug para obtener información adicional.
    [GAI sharedInstance].debug = YES;
    // Creamos la instancia del tracker indicando el ID de seguimiento que hemos obtenido anteriormente.
    id tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    
    NSLog(@"%@",tracker);
    
    
    
    
    return YES;
    
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Notificacion Local
-(void)NotificacionLocal{
    
    NSDate *horaDispocitivo = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *strDate = [dateFormatter stringFromDate:horaDispocitivo];
    NSRange remplazoFecha = {11,8};
    NSDate *HoraActual = [dateFormatter dateFromString:[strDate stringByReplacingCharactersInRange:remplazoFecha withString:@"09:00:00"]];
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    NSLog(@"esta es la fecha transformada %@",HoraActual);
    // debe de activarse dentro de 5 segundos
    NSLog(@"esta es la hra actual %@",[[NSDate alloc] initWithTimeIntervalSinceNow:5]);
    notification.fireDate = HoraActual;
    // mensaje que saldrá en la alerta
    notification.alertBody = @"Ha Comenzado el congreso";
    // sonido por defecto
    notification.soundName = UILocalNotificationDefaultSoundName;
    // título del botón
    notification.alertAction = @"Ir a la Aplicacion";
    notification.hasAction = YES;
    // activa la notificación
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - Core Data stack

// Devuelve el managed object context para la App
// Si el contexto no existe, se crea y une al persistentCoordinator de la App

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}
// Devuelve el managed object model para la App
// Si el modelo no existe, se crea desde el modelo de la App

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Congresos" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}
// Devuelve el persistent store coordinator para la App.
// Si el coordinador no existe, se crea y la App lo añade.

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    AFIncrementalStore *incrementalStore = (AFIncrementalStore *)[_persistentStoreCoordinator addPersistentStoreWithType:[mCongressIncrementalStore type] configuration:nil URL:nil options:nil error:nil];
    
    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:kStoreName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Congresos2" ofType:@"sqlite"]];
        NSError* err = nil;
        
        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err]) {
            NSLog(@"Oops, could copy preloaded data");
    }
}
    NSDictionary *options = @{
                              NSInferMappingModelAutomaticallyOption : @(YES),
                              NSMigratePersistentStoresAutomaticallyOption: @(YES)
                    };
    
    NSError *error = nil;
    if (![incrementalStore.backingPersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
     NSLog(@"SQLite URL: %@", [[self applicationDocumentsDirectory] URLByAppendingPathComponent:kStoreName]);
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Devuelve la URL de la carpeta Documents de la App.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}//

#pragma -mark Notificaciones delegados

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"\nPush notifications are not supported in the iOS Simulator.\n");
    } else {
        NSLog(@"\napplication:didFailToRegisterForRemoteNotificationsWithError: %@\n", error);
	}
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [[ParseOrbiter parseManagerWithApplicationID:@"YACUWrIsFNmUe3vLSjp4CAuiwDKzp5LGRtNyG8Fq" RESTAPIKey:@"UX2hpIyQeAbkUGFwhjDe136B4Eg6FhT59XnLBoNO"] registerDeviceToken:deviceToken withAlias:@"Callampa" badge:nil channels:[NSSet setWithArray:[NSArray arrayWithObjects:@"callampon",@"callampin",nil]  ]timeZone:[NSTimeZone defaultTimeZone] success:^(id responseObject) {
        NSLog(@"El Registro (con 'h' el 'ha' ése luchin) ha sido realizado : %@", responseObject);
        
    } failure:^(NSError *error) {
        NSLog(@"Error por : %@", error);
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    id eventoComenzar = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [eventoComenzar sendEventWithCategory:@"uiAction"
                               withAction:@"push"
                                withLabel:@"Recibido"
                                withValue:nil];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge];
    NSDictionary *payload = [userInfo objectForKey:@"aps"];
    NSString *alertMessage = [payload objectForKey:@"alert"];
    
    
    UIApplicationState estadus = [application applicationState];
    if (estadus == UIApplicationStateActive) {
        
               NSString *titulengue = @"OK";
        NSString *texto = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Te informamos que:"
                                                            message:texto
                                                           delegate:self
                                                  cancelButtonTitle:titulengue
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
        
}
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    NSLog(@"todos los valores de Userinfo ==>%@",[userInfo allValues]);
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"No se ha podido guardar la heua: %@", [error localizedDescription]);
        abort();
        
    }
}

 #pragma mark - Eventos generales de la App

-(void)applicationWillEnterForeground:(UIApplication *)application{

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
   [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"llegó la notificación");
   // application.applicationIconBadgeNumber = application.applicationIconBadgeNumber +1;
}

@end
