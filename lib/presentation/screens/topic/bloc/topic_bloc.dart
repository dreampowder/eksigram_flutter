import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eksigram/common/injection_container.dart';
import 'package:eksigram/domain/model/entity/model_failure.dart';
import 'package:eksigram/domain/model/entity/model_topic.dart';
import 'package:eksigram/domain/usecase/usecase_topic.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'topic_event.dart';
part 'topic_state.dart';

class ModelImageData{
  String url;
  int width;
  int height;
  ModelImageData(this.url, this.width, this.height);
}

class BlocTopic extends Bloc<EventTopic, StateTopic> {

  late final UseCaseTopic _useCaseTopic;

  final Map<String, ModelImageData> imageUrlMap = {};
  final Set<String> loadingImageUrls = {};

  BlocTopic({UseCaseTopic? useCaseTopic}) : super(StateTopicInitial()) {
    _useCaseTopic = useCaseTopic ?? injections();
    on<EventTopicGet>(_getTopic);
    on<EventTopicGetRealImageUrl>(_getRealImage);
  }

  FutureOr<void> _getTopic(EventTopicGet event, Emitter<StateTopic> emit) async{
    await _useCaseTopic.getTopic(event.id, event.page)
        .then((value) => value
        .fold(
            (l) => emit(StateTopicDidReceive(l)),
            (r) => emit(StateTopicFailure(r))
    ));
  }

  FutureOr<void> _getRealImage(EventTopicGetRealImageUrl event, Emitter<StateTopic> emit) async{
    if(loadingImageUrls.contains(event.url)){
      debugPrint("Already downloading an image");
      return;
    }
    if (imageUrlMap[event.url]?.url.isNotEmpty ?? false) {
      emit(StateTopicDidReceiveImageUrl(event.url, imageUrlMap[event.url]!.url,imageUrlMap[event.url]!.width,imageUrlMap[event.url]!.height));
      return;
    }
    loadingImageUrls.add(event.url);
    await _useCaseTopic.getRealImageUrl(event.url)
        .then((value) => value
        .fold(
            (l) async{
              loadingImageUrls.remove(event.url);
              imageUrlMap[event.url] = ModelImageData(l ?? "", 0, 0);
              if(l?.isEmpty ?? true){
                emit(StateTopicDidReceiveImageUrl(event.url, l,0,0));
              }else{
                await _calculateImageDimension(l!).then((size){
                  imageUrlMap[event.url] = ModelImageData(l ?? "", size.width.toInt(), size.height.toInt());
                  emit(StateTopicDidReceiveImageUrl(event.url, l,size.width.toInt(),size.height.toInt()));
                }).catchError((error){
                  emit(StateTopicDidReceiveImageUrl(event.url, l,0,0));
                });
              }
            },
            (r){
              loadingImageUrls.remove(event.url);
              emit(StateTopicFailure(r));
            }
    ));
  }

  Future<Size> _calculateImageDimension(String imageUrl) {
    Completer<Size> completer = Completer();
    Image image = Image(image: CachedNetworkImageProvider(imageUrl));
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
            (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }
}
