import 'package:flutter/material.dart';

import 'package:march_tales_app/core/helpers/fetchGoogleImages.dart';
import 'package:march_tales_app/features/Quote/types/Quote.dart';

class QuoteImage extends StatefulWidget {
  const QuoteImage({
    super.key,
    required this.quote,
  });

  final Quote quote;

  @override
  State<QuoteImage> createState() => _QuoteImageState();
}

class _QuoteImageState extends State<QuoteImage> {
  bool isLoading = false;
  String errorStr = '';
  String imgUrl = '';
  List<String> imgList = [];
  String author = '';
  int imgIdx = 0;

  @override
  void initState() {
    super.initState();
    getImageUrlFuture();
  }

  getImageUrlFuture() {
    print('[QuoteImage:getImageUrlFuture]: ${widget.quote.author}');
    // Re-fetch image url...
    imgIdx = 0;
    setState(() {
      author = widget.quote.author;
      isLoading = true;
      imgUrl = '';
      errorStr = '';
    });
    final queryStr = "$author square portrait";
    fetchGoogleImages(queryStr).then((list) {
      print("[QuoteImage:getImageUrlFuture] Done: $list");
      setState(() {
        imgList = list;
        imgUrl = imgList[imgIdx];
      });
    }).catchError((error) {
      print("[QuoteImage:getImageUrlFuture] Error: $error");
      setState(() {
        errorStr = error.toString();
      });
    }).whenComplete(() {
      print("[QuoteImage:getImageUrlFuture] Complete");
      setState(() {
        isLoading = false;
      });
    });
  }

  checkData() {
    print('[QuoteImage:checkData]: ${widget.quote.author}');
    // Re-fetch image url...
    if (author != widget.quote.author) {
      getImageUrlFuture();
    }
  }

  void onImageError(String url) {
    // Select next image
    print(
        "[QuoteImage:onImageError] Trying to select the next image on imgIdx: ($imgIdx) url: $url imgUrl: $imgUrl"); //  obj: $obj trace: $trace");
    // Change image if it's still current one
    if (imgUrl == url) {
      imgIdx++;
      setState(() {
        imgUrl = imgIdx < imgList.length ? imgList[imgIdx] : '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    checkData();
    print("[QuoteImage:build] Start build with author:$author isLoading=$isLoading imgIdx=$imgIdx errorStr=$errorStr");
    if (isLoading) {
      return Text('Loading...');
      // return const CircularProgressIndicator(strokeWidth: 2);
    }
    if (errorStr.isNotEmpty) {
      return Text(errorStr);
    }
    if (imgUrl.isEmpty) {
      return Text('No image found');
    }
    print("[QuoteImage:build] Rendering an image with url: $imgUrl");
    return QuoteImageWidget(
      url: imgUrl,
      onImageError: onImageError,
    );
    /*
    return FutureBuilder<List<String>>(
      future: getImageUrlFuture(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        final imgList = snapshot.data;
        if (imgList != null && imgIdx >= imgList.length) {
          return Text('Can not found an image');
        }
        return QuoteImageWidget(
          url: imgList != null ? imgList[imgIdx] : null,
          onImageError: onImageError,
        );
      },
    );
    */
  }
}

class QuoteImageWidget extends StatelessWidget {
  const QuoteImageWidget({
    super.key,
    required this.url,
    required this.onImageError,
  });

  final String url;
  final Function(String) onImageError;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }
    return CircleAvatar(
      radius: 100,
      backgroundColor: Colors.white,
      foregroundImage: NetworkImage(
        url,
      ),
      onForegroundImageError: (obj, trace) {
        onImageError(url);
      },
    );
  }
}
