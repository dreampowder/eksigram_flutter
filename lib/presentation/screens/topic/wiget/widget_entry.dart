import 'package:eksigram/domain/model/entity/model_entry.dart';
import 'package:eksigram/presentation/screens/topic/bloc/topic_bloc.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WidgetEntry extends StatefulWidget {
  final ModelEntry entry;
  const WidgetEntry({Key? key,required this.entry}) : super(key: key);

  @override
  State<WidgetEntry> createState() => _WidgetEntryState();
}

class _WidgetEntryState extends State<WidgetEntry> {

  Map<String,String> realImageUrls = {};
  double aspectRatio = 1.0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  void _handleBlocState(BuildContext context, state) {
    if (state is StateTopicDidReceiveImageUrl) {
      if (widget.entry.images.contains(state.sourceUrl)) {
        _processImageResponse(state.sourceUrl, state.imageUrl ?? "", state.width, state.height);
      }
    }
  }

  void _processImageResponse(String sourceUrl, String url, int width, int height){
    realImageUrls[sourceUrl] = url;
    if (width != 0 && height != 0) {
      var aspect = width.toDouble() / height.toDouble();
      if (aspect > aspectRatio) {
        aspectRatio = aspect;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<BlocTopic>(context),
      listener: _handleBlocState,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _user(),
          _images(),
          _stats(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.entry.body),
          )
        ],
      ),
    );
  }

  Widget _stats(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(Icons.favorite,size: 14,color: Theme.of(context).colorScheme.primary,),
          const SizedBox(width: 4,),
          Text("${widget.entry.favCount}",style: Theme.of(context).textTheme.bodySmall,)
        ],
      ),
    );
  }

  Widget _user(){
    var url = widget.entry.author.photoUrl ?? "";
    Widget? image;
    if (url.contains("default-profile-picture")) {
      url = "https:$url";
      image = SvgPicture.network(url,width: 30,height: 30,fit: BoxFit.cover);
    }else{
      image = CachedNetworkImage(imageUrl: url,width: 30,height: 30,fit: BoxFit.cover,);
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if(widget.entry.author.photoUrl != null)ClipOval(child: image!),
          const SizedBox(width: 8,),
          Text(widget.entry.author.userName)
        ],
      ),
    );
  }

  Widget _images(){
    List<Widget> children = [];
    for (var value in widget.entry.images) {
      if (realImageUrls[value] == null) {
        children.add(const Center(child: CircularProgressIndicator(),));
        BlocProvider.of<BlocTopic>(context).add(EventTopicGetRealImageUrl(value));
      }else{
        if (realImageUrls[value]!.isNotEmpty) {
          children.add(CachedNetworkImage(imageUrl: realImageUrls[value]!,fit: BoxFit.cover,));
        }
      }
    }
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Stack(
        children: [
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              children: children,
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: realImageUrls.values.where((element) => element.isNotEmpty).length,
              effect: WormEffect(dotWidth: 8,dotHeight: 8,spacing: 4,dotColor: Colors.white,activeDotColor: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(WidgetEntry oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entry.id != widget.entry.id) {
      realImageUrls.clear();
      aspectRatio = 1.0;
    }
  }
}
