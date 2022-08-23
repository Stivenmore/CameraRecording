import 'dart:convert';

import 'package:CameraDirect/data/Response/result.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

const String kAuthorizationHeader = 'Authorization';
const String kBearer = 'Bearer';

enum Method {
  delete,
  get,
  getDio,
  patch,
  post,
  put,
}

/// Api helper for make calls to the [Dio] client
///
/// Remember that you can return a mock file of set a temporal url for a custom
/// branch that is not already deployed of merged in release. See [makeRequest]
/// for more info.
class ApiUtils {
  final Dio _client;
  final String _host;


  ApiUtils({
    required Dio client,
    required String host,
  })  : _client = client,
        _host = host;


  /// If the backend is no already implement you can use [temporalHost] for make
  /// the request to a custom endpoint something like:
  /// _**myBranch/my/endpoint/**_ Remember don't use [https://] or similar the
  /// client already make this additions in the initialization and the route
  /// must be raw.
  ///
  /// In the other way if you need return a mock file you can specific the path
  /// with [mockResponseFile] and later of 2 seconds this will be return a
  /// response with the mock response.
  ///
  /// The mock files are loaded from `assets/mocks/` something like:
  /// _**assets/mocks/yourAwesomeMock.json**_
  Future<Result<dynamic, BackendError>> makeRequest({
    dynamic data,
    String? errorPath,
    String? errorDescriptionPath,
    Map<String, dynamic>? headers,
    required Method method,
    String? mockResponseFile,
    required String path,
    Map<String, dynamic>? queryParameters,
    bool onlyPath = false,
    String? contentType,

    /// Use only if need inject a temporal host with a custom deployment branch
    String? temporalHost,
  }) async {
    /// Return a mock response if the file is specified
    if (mockResponseFile?.isNotEmpty ?? false) {
      final response = await _getMockResponse(mockResponseFile!);
      return Success(response);
    }

    Map<String, dynamic> _headers = <String, dynamic>{};

    //Bearer authorization header
   //_headers[kAuthorizationHeader] = '$kBearer $_tokenAuthorization';

    //Additional headers
    _headers.addAll(headers ?? {});

    

    if(onlyPath){
      path = '$_host/$path';
    }

    final Response response;

    final Options options = Options(
      headers: _headers,
      contentType: contentType
    );

    Uri uri = Uri.https(_host, path, queryParameters);

    try {
      switch (method) {
        case Method.delete:
          response = await _client.deleteUri(
            uri,
            options: options,
          );
          break;
        case Method.get:
          response = await _client.getUri(
            uri,
            options: options,
          );
          break;
        case Method.getDio:
          response = await _client.get(
            path,
            options: options,
          );
          break;
        case Method.patch:
          response = await _client.patchUri(
            uri,
            data: data,
            options: options,
          );
          break;
        case Method.post:
          response = await _client.postUri(
            uri,
            data: data,
            options: options,
          );
          break;
        case Method.put:
          response = await _client.putUri(
            uri,
            data: data,
            options: options,
          );
          break;
      }
      return Result.success(response);
    } on DioError catch (error) {
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.receiveTimeout:
        case DioErrorType.sendTimeout:
          return Result.fail(
            BackendError(
              statusCode: 408,
              description: error.error,
              err: 'TimeOut',
            ),
          );
        default:
          return Result.fail(
            BackendError(
              data: error.response?.data is String
                  ? {"message": ''}
                  : (error.response!.data as Map),
              statusCode: error.response?.statusCode ?? -1,
            ),
          );
      }
    }
  }

  Future<Map<String, dynamic>> _getMockResponse(String filePath) =>
      Future.delayed(
        const Duration(seconds: 2),
        () async {
          final file = await rootBundle.loadString('assets/mocks/$filePath');
          return jsonDecode(file);
        },
      );
}
