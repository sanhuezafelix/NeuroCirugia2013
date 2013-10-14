//
//  Eventopadre.h
//  DualmobileCongress
//
//  Created by Arturo Sanhueza on 14-10-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Evento, Imagen, Institucion, Persona;

@interface Eventopadre : NSManagedObject

@property (nonatomic, retain) NSString * descripcionEP;
@property (nonatomic, retain) NSString * horaFinEP;
@property (nonatomic, retain) NSString * horaInicioEP;
@property (nonatomic, retain) NSNumber * patrocinioEP;
@property (nonatomic, retain) NSString * tipoEP;
@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) NSSet *participantes;
@property (nonatomic, retain) Institucion *institucionPatrocinante;
@property (nonatomic, retain) Imagen *imagenEventoPadre;
@property (nonatomic, retain) NSSet *eventoHijo;
@end

@interface Eventopadre (CoreDataGeneratedAccessors)

- (void)addParticipantesObject:(Persona *)value;
- (void)removeParticipantesObject:(Persona *)value;
- (void)addParticipantes:(NSSet *)values;
- (void)removeParticipantes:(NSSet *)values;

- (void)addEventoHijoObject:(Evento *)value;
- (void)removeEventoHijoObject:(Evento *)value;
- (void)addEventoHijo:(NSSet *)values;
- (void)removeEventoHijo:(NSSet *)values;

@end
