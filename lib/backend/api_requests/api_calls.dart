import 'dart:convert';
import '../cloud_functions/cloud_functions.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start mem Group Code

class MemGroup {
  static String baseUrl = 'https://ff00-197-210-227-52.ngrok-free.app';
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  static ReadContractStateCall readContractStateCall = ReadContractStateCall();
  static RegisterANewUserCall registerANewUserCall = RegisterANewUserCall();
  static DeleteUserProfileCall deleteUserProfileCall = DeleteUserProfileCall();
  static UpdateUserProfileCall updateUserProfileCall = UpdateUserProfileCall();
}

class ReadContractStateCall {
  Future<ApiCallResponse> call({
    String? contract = 'QGpH2VTY7wKGQc_e2j_2KFCTMeL4hgbkWpsVweNa1Oo',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Read Contract State',
      apiUrl: '${MemGroup.baseUrl}/api/state/$contract',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic chats(dynamic response) => getJsonField(
        response,
        r'''$.chats''',
      );
  dynamic updates(dynamic response) => getJsonField(
        response,
        r'''$.status_updates''',
      );
  dynamic profiles(dynamic response) => getJsonField(
        response,
        r'''$.user_profiles''',
      );
}

class RegisterANewUserCall {
  Future<ApiCallResponse> call({
    String? caller = '',
    String? message = '',
    String? signature = '',
    String? fcmToken = 'fcm_null',
    String? contract = 'QGpH2VTY7wKGQc_e2j_2KFCTMeL4hgbkWpsVweNa1Oo',
  }) async {
    final ffApiRequestBody = '''
{
  "functionId": "$contract",
  "inputs": [
    {
      "input": {
        "function": "register",
        "caller": "$caller",
        "message": "$message",
        "data": {
          "fcmToken": "$fcmToken"
        },
        "signature": "$signature"
      }
    }
  ]
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Register a New User',
      apiUrl: '${MemGroup.baseUrl}/api/transactions',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic status(dynamic response) => getJsonField(
        response,
        r'''$.staus''',
      );
  dynamic state(dynamic response) => getJsonField(
        response,
        r'''$.data.execution.state''',
      );
  dynamic errors(dynamic response) => getJsonField(
        response,
        r'''$.data.execution.errors''',
      );
}

class DeleteUserProfileCall {
  Future<ApiCallResponse> call({
    String? caller = '',
    String? message = '',
    String? signature = '',
    String? contract = 'QGpH2VTY7wKGQc_e2j_2KFCTMeL4hgbkWpsVweNa1Oo',
  }) async {
    final ffApiRequestBody = '''
{
  "functionId": "$contract",
  "inputs": [
    {
      "input": {
        "function": "deleteProfile",
        "caller": "$caller",
        "message": "$message",
        "signature": "$signature"
      }
    }
  ]
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Delete User Profile',
      apiUrl: '${MemGroup.baseUrl}/api/transactions',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class UpdateUserProfileCall {
  Future<ApiCallResponse> call({
    String? caller = '',
    String? message = '',
    String? signature = '',
    String? alias = '',
    int? status = 0,
    bool? acceptMessages,
    String? profilePictureUrl = '',
    String? profileBio = '',
    bool? readReciepts = true,
    String? contract = 'QGpH2VTY7wKGQc_e2j_2KFCTMeL4hgbkWpsVweNa1Oo',
  }) async {
    final ffApiRequestBody = '''
{
  "functionId": "$contract",
  "inputs": [
    {
      "input": {
        "function": "updateProfile",
        "caller": "$caller",
        "message": "$message",
        "data": {
          "alias": "$alias",
          "status": $status,
          "acceptMessages": $acceptMessages,
          "profilePictureUrl": "$profilePictureUrl",
          "profileBio": "$profileBio",
          "readReciepts": $readReciepts
        },
        "signature": "$signature"
      }
    }
  ]
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Update User Profile',
      apiUrl: '${MemGroup.baseUrl}/api/transactions',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

/// End mem Group Code

/// Start irys Group Code

class IrysGroup {
  static GetCostForBytesUploadCall getCostForBytesUploadCall =
      GetCostForBytesUploadCall();
  static UploadFileToIrysCall uploadFileToIrysCall = UploadFileToIrysCall();
}

class GetCostForBytesUploadCall {
  Future<ApiCallResponse> call({
    int? bytes,
  }) async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'GetCostForBytesUploadCall',
        'variables': {
          'bytes': bytes,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }
}

class UploadFileToIrysCall {
  Future<ApiCallResponse> call({
    FFUploadedFile? memFile,
    dynamic tagsJson,
  }) async {
    final tags = _serializeJson(tagsJson);
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'UploadFileToIrysCall',
        'variables': {
          'memFile': memFile,
          'tags': tags,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }
}

/// End irys Group Code

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list);
  } catch (_) {
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar);
  } catch (_) {
    return isList ? '[]' : '{}';
  }
}
