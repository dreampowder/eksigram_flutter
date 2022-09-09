part of 'topic_bloc.dart';

@immutable
abstract class EventTopic {}

class EventTopicGet extends EventTopic{
  final String id;
  final int page;
  EventTopicGet(this.id, this.page);
}

class EventTopicGetRealImageUrl extends EventTopic{
  final String url;
  EventTopicGetRealImageUrl(this.url);
}