/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, file_names, unnecessary_new, prefer_if_null_operators, prefer_const_constructors, slash_for_doc_comments, annotate_overrides, non_constant_identifier_names, unnecessary_string_interpolations, prefer_adjacent_string_concatenation, unnecessary_const, dead_code

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'Beer.dart';


/** This is an auto generated class representing the Brewery type in your schema. */
@immutable
class Brewery extends Model {
  static const classType = const _BreweryModelType();
  final String id;
  final String? _name;
  final String? _country;
  final String? _description;
  final List<Beer>? _beers;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get name {
    return _name;
  }
  
  String? get country {
    return _country;
  }
  
  String? get description {
    return _description;
  }
  
  List<Beer>? get beers {
    return _beers;
  }
  
  const Brewery._internal({required this.id, name, country, description, beers}): _name = name, _country = country, _description = description, _beers = beers;
  
  factory Brewery({String? id, String? name, String? country, String? description, List<Beer>? beers}) {
    return Brewery._internal(
      id: id == null ? UUID.getUUID() : id,
      name: name,
      country: country,
      description: description,
      beers: beers != null ? List<Beer>.unmodifiable(beers) : beers);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Brewery &&
      id == other.id &&
      _name == other._name &&
      _country == other._country &&
      _description == other._description &&
      DeepCollectionEquality().equals(_beers, other._beers);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Brewery {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("country=" + "$_country" + ", ");
    buffer.write("description=" + "$_description");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Brewery copyWith({String? id, String? name, String? country, String? description, List<Beer>? beers}) {
    return Brewery(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      description: description ?? this.description,
      beers: beers ?? this.beers);
  }
  
  Brewery.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _country = json['country'],
      _description = json['description'],
      _beers = json['beers'] is List
        ? (json['beers'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => Beer.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'country': _country, 'description': _description, 'beers': _beers?.map((Beer? e) => e?.toJson()).toList()
  };

  static final QueryField ID = QueryField(fieldName: "brewery.id");
  static final QueryField NAME = QueryField(fieldName: "name");
  static final QueryField COUNTRY = QueryField(fieldName: "country");
  static final QueryField DESCRIPTION = QueryField(fieldName: "description");
  static final QueryField BEERS = QueryField(
    fieldName: "beers",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (Beer).toString()));
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Brewery";
    modelSchemaDefinition.pluralName = "Breweries";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ]),
      AuthRule(
        authStrategy: AuthStrategy.PRIVATE,
        operations: [
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Brewery.NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Brewery.COUNTRY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Brewery.DESCRIPTION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: Brewery.BEERS,
      isRequired: false,
      ofModelName: (Beer).toString(),
      associatedKey: Beer.BREWERYID
    ));
  });
}

class _BreweryModelType extends ModelType<Brewery> {
  const _BreweryModelType();
  
  @override
  Brewery fromJson(Map<String, dynamic> jsonData) {
    return Brewery.fromJson(jsonData);
  }
}