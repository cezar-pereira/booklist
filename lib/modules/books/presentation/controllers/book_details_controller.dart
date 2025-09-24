import 'package:flutter/foundation.dart';
import '../../../../shared/favorites_manager.dart';

class BookDetailsController extends ChangeNotifier {
  final FavoritesManager favoritesManager;

  BookDetailsController(this.favoritesManager);
}
