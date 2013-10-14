//
//  Institucion.h
//  DualmobileCongress
//
//  Created by Arturo Sanhueza on 14-10-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Evento, Eventopadre, Lugar, Persona;

@interface Institucion : NSManagedObject

@property (nonatomic, retain) NSString * descripcionInstitucion;
@property (nonatomic, retain) NSString * nombreInstitucion;
@property (nonatomic, retain) NSString * tipoInstitucion;
@property (nonatomic, retain) Evento *eventoQuePatrocino;
@property (nonatomic, retain) Lugar *lugarEnqueEstoy;
@property (nonatomic, retain) NSSet *personaQuePatrocino;
@property (nonatomic, retain) NSSet *eventoPadreQuePatrocino;
@end

@interface Institucion (CoreDataGeneratedAccessors)

- (void)addPersonaQuePatrocinoObject:(Persona *)value;
- (void)removePersonaQuePatrocinoObject:(Persona *)value;
- (void)addPersonaQuePatrocino:(NSSet *)values;
- (void)removePersonaQuePatrocino:(NSSet *)values;

- (void)addEventoPadreQuePatrocinoObject:(Eventopadre *)value;
- (void)removeEventoPadreQuePatrocinoObject:(Eventopadre *)value;
- (void)addEventoPadreQuePatrocino:(NSSet *)values;
- (void)removeEventoPadreQuePatrocino:(NSSet *)values;

@end
