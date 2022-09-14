import 'package:eksigram/common/injection_container.dart';
import 'package:eksigram/domain/model/entity/model_entry.dart';
import 'package:eksigram/domain/usecase/usecase_topic.dart';
import 'package:eksigram/presentation/screens/topic/bloc/topic_bloc.dart';
import 'package:eksigram/presentation/screens/topic/wiget/widget_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ScreenTopic extends StatefulWidget {
  final String id;
  const ScreenTopic({Key? key,required this.id}) : super(key: key);

  @override
  State<ScreenTopic> createState() => _ScreenTopicState();
}

class _ScreenTopicState extends State<ScreenTopic> {

  final BlocTopic _bloc = BlocTopic();
  late final PagingController<int, ModelEntry> _pagingController;
  bool didInitializePagingController = false;
  int startPage = -1;
  Set<int> requestedPages = {};
  @override
  void initState() {
    super.initState();
    _bloc.add(EventTopicGet(widget.id, 1));
  }

  void _initializePager(){
    didInitializePagingController = true;
    _pagingController = PagingController(firstPageKey: startPage);
    _pagingController.addPageRequestListener((pageKey) {
      if (requestedPages.contains(pageKey)) {
        return;
      }
      requestedPages.add(pageKey);
      _bloc.add(EventTopicGet(widget.id, pageKey));
    });
  }

  void _handleBlocState(BuildContext context, StateTopic state) {
    if(state is StateTopicDidReceive){
      if (startPage == -1) {
        startPage = state.topic.pageCount;
         _initializePager();
        setState(() {});
      }else{
        if (state.topic.page == 1 && state.topic.pageCount > 1) {
          _pagingController.appendLastPage(state.topic.entries);
        }else{
          _pagingController.nextPageKey = (_pagingController.nextPageKey ?? startPage) - 1;
          _pagingController.appendPage(state.topic.entries, _pagingController.nextPageKey);
        }
      }
    }
  }

  void _showInfo(){
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: const Text("eksigram"),
      content: const Text("Bu uygulama; kar amacı gütmeden, sadece eğitim amacı ile hazırlanmıştır. uygulamanın kaynak koduna 'https://github.com/stellar-projects/eksigram_flutter' adresi üzerinden erişebilirsiniz."),
      actions: [
        TextButton(onPressed: (){Navigator.of(context).pop();}, child: const Text("e bundan bana ne?"))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("eksigram"),
        actions: [
          IconButton(onPressed: _showInfo, icon: const Icon(Icons.info))
        ],
      ),
      body: BlocProvider.value(
        value: _bloc,
        child: BlocListener<BlocTopic, StateTopic>(
          bloc: _bloc,
          listener: _handleBlocState,
          child:(startPage == -1) ? const Center(child: CircularProgressIndicator(),) :
          RefreshIndicator(
            onRefresh: (){
              startPage = -1;
              _pagingController.refresh();
              _bloc.add(EventTopicGet(widget.id, 1));
              requestedPages.clear();
              return Future.value();
            },
            child: PagedListView.separated(
              pagingController: _pagingController,
              separatorBuilder: (context, index)=>Divider(color: Theme.of(context).colorScheme.primary,thickness: 0.5,),
              builderDelegate: PagedChildBuilderDelegate<ModelEntry>(
                itemBuilder: (context, item, index){
                  return WidgetEntry(entry: item);
                }
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onPressed() async{
    await injections<UseCaseTopic>().getTopic("anin-fotografi--6459985",932)
        .then((value) => value.fold(
            (l) => debugPrint(l.toString()),
            (r) => debugPrint(r.toString())
    ));
  }
}
