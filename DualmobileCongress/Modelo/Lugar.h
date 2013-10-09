//
//  Lugar.h
//  DualmobileCongress
//
//  Created by felix sanhueza on 6/6/13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Evento, Institucion, Pais, Persona;

@interface Lugar : NSManagedObject

@property (nonatomic, retain) NSString * ciudad;
@property (nonatomic, retain) NSString * nombreLugar;
@property (nonatomic, retain) NSSet *eventoLugar;
@property (nonatomic, retain) NSSet *institucionAqui;
@property (nonatomic, retain) Pais *paisEnQueEstoy;
@property (nonatomic, retain) NSSet *personaDelQueSoyProcedencia;
@end

@interface Lugar (CoreDataGeneratedAccessors)

- (void)addEventoLugarObject:(Evento *)value;
- (void)removeEventoLugarObject:(Evento *)value;
- (void)addEventoLugar:(NSSet *)values;
- (void)removeEventoLugar:(NSSet *)values;

- (void)addInstitucionAquiObject:(Institucion *)value;
- (void)removeInstitucionAquiObject:(Institucion *)value;
- (void)addInstitucionAqui:(NSSet *)values;
- (void)removeInstitucionAqui:(NSSet *)values;

- (void)addPersonaDelQueSoyProcedenciaObject:(Persona *)value;
- (void)removePersonaDelQueSoyProcedenciaObject:(Persona *)value;
- (void)addPersonaDelQueSoyProcedencia:(NSSet *)values;
- (void)removePersonaDelQueSoyProcedencia:(NSSet *)values;

@end
