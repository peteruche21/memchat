// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class WalletStruct extends BaseStruct {
  WalletStruct({
    String? address,
    String? credential,
  })  : _address = address,
        _credential = credential;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  set address(String? val) => _address = val;
  bool hasAddress() => _address != null;

  // "credential" field.
  String? _credential;
  String get credential => _credential ?? '';
  set credential(String? val) => _credential = val;
  bool hasCredential() => _credential != null;

  static WalletStruct fromMap(Map<String, dynamic> data) => WalletStruct(
        address: data['address'] as String?,
        credential: data['credential'] as String?,
      );

  static WalletStruct? maybeFromMap(dynamic data) =>
      data is Map<String, dynamic> ? WalletStruct.fromMap(data) : null;

  Map<String, dynamic> toMap() => {
        'address': _address,
        'credential': _credential,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'address': serializeParam(
          _address,
          ParamType.String,
        ),
        'credential': serializeParam(
          _credential,
          ParamType.String,
        ),
      }.withoutNulls;

  static WalletStruct fromSerializableMap(Map<String, dynamic> data) =>
      WalletStruct(
        address: deserializeParam(
          data['address'],
          ParamType.String,
          false,
        ),
        credential: deserializeParam(
          data['credential'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'WalletStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is WalletStruct &&
        address == other.address &&
        credential == other.credential;
  }

  @override
  int get hashCode => const ListEquality().hash([address, credential]);
}

WalletStruct createWalletStruct({
  String? address,
  String? credential,
}) =>
    WalletStruct(
      address: address,
      credential: credential,
    );
