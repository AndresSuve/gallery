import 'package:flutter/material.dart';
import 'package:photo_gallery/models/photo.dart';
import 'package:photo_gallery/services/photo_service.dart';

class PhotoDetailScreen extends StatefulWidget {
  final Photo photo;

  PhotoDetailScreen({required this.photo});

  @override
  _PhotoDetailScreenState createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Detail'),
      ),
      body: Center(
        child: Hero(
          tag: widget.photo.url,
          child: Image.network(
            widget.photo.url,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
