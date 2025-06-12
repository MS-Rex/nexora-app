import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'models/chat_request.dart';
import 'models/chat_response.dart';
part 'chat_api.g.dart';

@injectable
@RestApi()
abstract class ChatApi {
  @factoryMethod
  factory ChatApi(Dio dio, {String baseUrl}) = _ChatApi;

  @POST("api/mobile-api/message/send")
  Future<ChatResponse> sendMessage(@Body() ChatRequest request);
}
