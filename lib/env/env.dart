import 'package:CameraDirect/data/api_utils.dart';
import 'package:dio/dio.dart';

String baseUrl = "graph.facebook.com";

ApiUtils apiUtils = ApiUtils(  
  client: Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: 5000,
    receiveTimeout: 3000,)),
  host: baseUrl,
);