import 'package:flutter/material.dart';
import 'package:photo_gallery/models/photo.dart';
import 'package:photo_gallery/screens/photo_detail_screen.dart';
import 'package:photo_gallery/controllers/photo_gallery_controller.dart';
import 'package:photo_gallery/screens/upload_photo_screen.dart';

class PhotoGalleryScreen extends StatefulWidget {
  @override
  _PhotoGalleryScreenState createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {
  final PhotoGalleryController _controller = PhotoGalleryController();

  @override
  void initState() {
    super.initState();
    _controller.loadPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Gallery'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _controller.loadPhotos,
          ),
        ],
      ),
      body: StreamBuilder<List<Photo>>(
        stream: _controller.photosStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Photo>? photos = snapshot.data;
            if (photos == null || photos.isEmpty) {
              return Center(child: Text('No photos available'));
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => PhotoDetailScreen(photo: photo),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            var tween = Tween(begin: Offset(1, 0), end: Offset(0, 0));
                            var curve = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                            var offsetAnimation = tween.animate(curve);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Hero(
                      tag: photo.url,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Image.network(
                          photo.url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UploadPhotoScreen()),
          );
        },
        tooltip: 'Upload Photo',
        child: Icon(Icons.add),
      ),
    );
  }
}
