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
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Beer type in your schema. */
@immutable
class Beer extends Model {
  static const classType = const _BeerModelType();
  final String id;
  final String? _name;
  final String? _type;
  final double? _abv;
  final String? _imageInternalId;
  final String? _imageExternalUrl;
  final String? _breweryID;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  String get name {
    try {
      return _name!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }

  String get type {
    try {
      return _type!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }

  double? get abv {
    return _abv;
  }

  String? get imageInternalId {
    return _imageInternalId;
  }

  String? get imageExternalUrl {
    return _imageExternalUrl;
  }

  String? get breweryID {
    return _breweryID;
  }

  const Beer._internal({required this.id, required name, required type, abv, imageInternalId, imageExternalUrl, breweryID}): _name = name, _type = type, _abv = abv, _imageInternalId = imageInternalId, _imageExternalUrl = imageExternalUrl, _breweryID = breweryID;

  factory Beer({String? id, required String name, required String type, double? abv, String? imageInternalId, String? imageExternalUrl, String? breweryID}) {
    return Beer._internal(
        id: id == null ? UUID.getUUID() : id,
        name: name,
        type: type,
        abv: abv,
        imageInternalId: imageInternalId,
        imageExternalUrl: imageExternalUrl,
        breweryID: breweryID);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Beer &&
        id == other.id &&
        _name == other._name &&
        _type == other._type &&
        _abv == other._abv &&
        _imageInternalId == other._imageInternalId &&
        _imageExternalUrl == other._imageExternalUrl &&
        _breweryID == other._breweryID;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Beer {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("type=" + "$_type" + ", ");
    buffer.write("abv=" + (_abv != null ? _abv!.toString() : "null") + ", ");
    buffer.write("imageInternalId=" + "$_imageInternalId" + ", ");
    buffer.write("imageExternalUrl=" + "$_imageExternalUrl" + ", ");
    buffer.write("breweryID=" + "$_breweryID");
    buffer.write("}");

    return buffer.toString();
  }

  Beer copyWith({String? id, String? name, String? type, double? abv, String? imageInternalId, String? imageExternalUrl, String? breweryID}) {
    return Beer(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        abv: abv ?? this.abv,
        imageInternalId: imageInternalId ?? this.imageInternalId,
        imageExternalUrl: imageExternalUrl ?? this.imageExternalUrl,
        breweryID: breweryID ?? this.breweryID);
  }

  Beer.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _name = json['name'],
        _type = json['type'],
        _abv = (json['abv'] as num?)?.toDouble(),
        _imageInternalId = json['imageInternalId'],
        _imageExternalUrl = json['imageExternalUrl'],
        _breweryID = json['breweryID'];

  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'type': _type, 'abv': _abv, 'imageInternalId': _imageInternalId, 'imageExternalUrl': _imageExternalUrl, 'breweryID': _breweryID
  };

  static final QueryField ID = QueryField(fieldName: "beer.id");
  static final QueryField NAME = QueryField(fieldName: "name");
  static final QueryField TYPE = QueryField(fieldName: "type");
  static final QueryField ABV = QueryField(fieldName: "abv");
  static final QueryField IMAGEINTERNALID = QueryField(fieldName: "imageInternalId");
  static final QueryField IMAGEEXTERNALURL = QueryField(fieldName: "imageExternalUrl");
  static final QueryField BREWERYID = QueryField(fieldName: "breweryID");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Beer";
    modelSchemaDefinition.pluralName = "Beers";

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
        key: Beer.NAME,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Beer.TYPE,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Beer.ABV,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Beer.IMAGEINTERNALID,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Beer.IMAGEEXTERNALURL,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Beer.BREWERYID,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _BeerModelType extends ModelType<Beer> {
  const _BeerModelType();

  @override
  Beer fromJson(Map<String, dynamic> jsonData) {
    return Beer.fromJson(jsonData);
  }
}