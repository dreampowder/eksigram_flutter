part of 'topic_bloc.dart';

@immutable
abstract class StateTopic {}

class StateTopicInitial extends StateTopic {}

class StateTopicDidReceive extends StateTopic{
  final ModelTopic topic;
  StateTopicDidReceive(this.topic);
}

class StateTopicFailure extends StateTopic{
  final Failure? failure;
  StateTopicFailure(this.failure);
}

class StateTopicDidReceiveImageUrl extends StateTopic{
  final String sourceUrl;
  final String? imageUrl;
  final int width;
  final int height;
  StateTopicDidReceiveImageUrl(this.sourceUrl, this.imageUrl,this.width,this.height);
}