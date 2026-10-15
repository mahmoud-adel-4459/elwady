import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/delivery_address.dart';
import '../models/order_summary.dart';
import '../models/order_record.dart';

enum AppFlow {
  splash,
  onboarding,
  login,
  otp,
  profileSetup,
  locationPermission,
  main
}

class AppProvider extends ChangeNotifier {
  SharedPreferences? _prefs;

  /// Restores the last flow step, tab and profile data saved by [_persist].
  Future<void> restore() async {
    try {
      final prefs = _prefs = await SharedPreferences.getInstance();
      final flow = prefs.getInt('flow');
      if (flow != null && flow > 0 && flow < AppFlow.values.length) {
        _currentFlow = AppFlow.values[flow];
      }
      final tab = prefs.getInt('tab');
      if (tab != null && tab >= 0 && tab < 5) _currentTab = tab;
      _phoneForOtp = prefs.getString('phoneForOtp') ?? _phoneForOtp;
      _isFirstTimeUser = prefs.getBool('isFirstTimeUser') ?? _isFirstTimeUser;
      _customerName = prefs.getString('customerName') ?? _customerName;
      _customerEmail = prefs.getString('customerEmail') ?? _customerEmail;
      _customerCity = prefs.getString('customerCity') ?? _customerCity;
      _customerPhone = prefs.getString('customerPhone') ?? _customerPhone;
    } catch (_) {
      // Fall back to the default first-launch state.
    }
  }

  void _persist() {
    final prefs = _prefs;
    if (prefs == null) return;
    prefs.setInt('flow', _currentFlow.index);
    prefs.setInt('tab', _currentTab);
    prefs.setString('phoneForOtp', _phoneForOtp);
    prefs.setBool('isFirstTimeUser', _isFirstTimeUser);
    prefs.setString('customerName', _customerName);
    prefs.setString('customerEmail', _customerEmail);
    prefs.setString('customerCity', _customerCity);
    prefs.setString('customerPhone', _customerPhone);
  }

  /// True when the system back button should close the app.
  bool get canExitApp {
    switch (_currentFlow) {
      case AppFlow.splash:
      case AppFlow.onboarding:
        return true;
      case AppFlow.main:
        return _currentTab == 0 && !_categoryListing;
      default:
        return false;
    }
  }

  /// Steps back one screen inside the flow (call when [canExitApp] is false).
  void handleBack() {
    switch (_currentFlow) {
      case AppFlow.login:
        setFlow(AppFlow.onboarding);
      case AppFlow.otp:
        setFlow(AppFlow.login);
      case AppFlow.profileSetup:
        setFlow(AppFlow.otp);
      case AppFlow.locationPermission:
        setFlow(_isFirstTimeUser ? AppFlow.profileSetup : AppFlow.otp);
      case AppFlow.main:
        if (_categoryListing) {
          showCategoryCards();
        } else if (_currentTab != 0) {
          setTab(0);
        }
      default:
        break;
    }
  }

  AppFlow _currentFlow = AppFlow.splash;
  AppFlow get currentFlow => _currentFlow;

  int _currentTab = 0;
  int get currentTab => _currentTab;

  String _currentCategory = 'all';
  String get currentCategory => _currentCategory;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // Auth & Profile
  String _phoneForOtp = '50 123 4567';
  String get phoneForOtp => _phoneForOtp;

  bool _isFirstTimeUser = true;
  bool get isFirstTimeUser => _isFirstTimeUser;

  final Set<String> _registeredPhones = {'501234567', '555123456'};

  String _customerName = 'أحمد رمضان';
  String get customerName => _customerName;

  String _customerEmail = 'ahmed@email.com';
  String get customerEmail => _customerEmail;

  String _customerCity = 'الرياض';
  String get customerCity => _customerCity;

  String _customerPhone = '+966 578 234 567';
  String get customerPhone => _customerPhone;

  final List<DeliveryAddress> addresses = [
    const DeliveryAddress(
        id: 'home',
        label: 'المنزل (الافتراضي)',
        address: 'حي النرجس، شارع عثمان بن عفان، الرياض',
        branch: 'فرع شمال الرياض'),
    const DeliveryAddress(
        id: 'work',
        label: 'العمل / المكتب',
        address: 'حي العليا، طريق الملك فهد، الرياض',
        branch: 'فرع وسط الرياض'),
    const DeliveryAddress(
        id: 'chalet',
        label: 'الاستراحة / المزرعة',
        address: 'طريق الثمامة، الرياض',
        branch: 'فرع الشرق المبرد'),
  ];
  int _addressIndex = 0;
  DeliveryAddress get currentAddress => addresses[_addressIndex];
  String get deliveryAddress => currentAddress.address;
  bool _categoryListing = false;
  bool get categoryListing => _categoryListing;
  bool _notificationsRead = false;
  bool get notificationsRead => _notificationsRead;
  int get unreadNotifications => _notificationsRead ? 0 : 3;
  OrderSummary? completedOrder;

  // Orders placed in this session (newest first)
  final List<OrderRecord> orders = [];

  // Saved payment cards
  final List<SavedCard> cards = [
    const SavedCard(
        id: 'card_default',
        brand: 'Mastercard',
        last4: '4242',
        holder: 'أحمد رمضان'),
  ];

  // Wishlist
  final Set<int> _wishlist = {1, 3};
  Set<int> get wishlist => _wishlist;

  // Cart
  final List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;

  // Master Data
  final List<CategoryItem> categories = const [
    CategoryItem(id: 'all', name: 'الكل', icon: '✨'),
    CategoryItem(id: 'carcasses', name: 'الذبائح الكاملة', icon: '🐑'),
    CategoryItem(id: 'fresh_cuts', name: 'اللحوم الطازجة', icon: '🥩'),
    CategoryItem(id: 'butchery_prep', name: 'التقطيع والتجهيز', icon: '🔪'),
    CategoryItem(id: 'offers', name: 'عروض الأسبوع', icon: '🏷️'),
  ];

  final List<Product> products = const [
    Product(
      id: 1,
      title: 'خروف نعيمي كامل بلدي',
      subtitle: 'ذبح وتجهيز في نفس اليوم تحت إشراف بيطري',
      category: 'carcasses',
      badge: 'الأكثر طلباً',
      price: 1450,
      unit: 'ذبيحة',
      baseWeight: 14.0,
      mainImage: 'assets/images/hero_banner.jpg',
      rating: 4.9,
      reviewsCount: 128,
      description:
          'ذبيحة نعيمي طازجة ذبحت اليوم، نضمن لك أعلى معايير الجودة مع تنظيف كامل وتشفية متقنة.',
    ),
    Product(
      id: 2,
      title: 'ريش غنم بلدي فاخرة',
      subtitle: 'ضأن صغير طازج جاهز للشواء أو الطبخ',
      category: 'fresh_cuts',
      badge: 'طازج اليوم',
      price: 380,
      unit: 'كيلو',
      baseWeight: 1.0,
      mainImage: 'assets/images/steak.jpg',
      rating: 4.8,
      reviewsCount: 94,
      description:
          'قطع ريش مأخوذة من أفضل عروق الغنم البلدي، تتميز بالطراوة ونسبة الشحم المتوازنة.',
    ),
    Product(
      id: 3,
      title: 'تندرلوين عجل بلدي فاخر',
      subtitle: 'قطع فيليه طرية مختارة فائقة الجودة',
      category: 'fresh_cuts',
      badge: 'مميّز',
      price: 420,
      unit: 'كيلو',
      baseWeight: 1.0,
      mainImage: 'assets/images/product_1.jpg',
      rating: 5.0,
      reviewsCount: 63,
      description:
          'أطرى قطعة لحم على الإطلاق، مثالية للستيك السريع والشواء الفاخر بدون أي عظم.',
    ),
    Product(
      id: 4,
      title: 'ستيك لحم بقر مزدوج للشواء',
      subtitle: 'قطعتان سميكتان متبلتان للشواء الفوري',
      category: 'fresh_cuts',
      badge: 'عرض خاص',
      price: 190,
      unit: 'علبة',
      baseWeight: 0.6,
      mainImage: 'assets/images/product_3.jpg',
      rating: 4.7,
      reviewsCount: 42,
      description:
          'قطعتان ستيك ريب آي متساويتان، جاهزتان للطهي المباشر في الفرن أو الجريل.',
    ),
    Product(
      id: 5,
      title: 'لحم مفروم بلدي طازج',
      subtitle: 'مفروم وجهين بلحم عجل وغنم طازج بدون شحوم زائدة',
      category: 'butchery_prep',
      badge: 'خصم 15%',
      price: 340,
      unit: 'كيلو',
      baseWeight: 1.0,
      mainImage: 'assets/images/product_4.jpg',
      rating: 4.9,
      reviewsCount: 115,
      description:
          'يُفرم طازجاً فور استلام الطلب، مثالي للحواوشي، الكفتة، أو صواني الفرن العائلية.',
    ),
    Product(
      id: 6,
      title: 'بوكس المشاوي الملكي العائلي',
      subtitle: 'تشكيلة كباب، شيش، ريش متبلة تكفي 6-8 أفراد',
      category: 'offers',
      badge: 'توفير عائلي',
      price: 590,
      unit: 'بوكس',
      baseWeight: 3.5,
      mainImage: 'assets/images/product_2.jpg',
      rating: 4.9,
      reviewsCount: 88,
      description:
          'بوكس مجهز ومغلف تفريغ هواء، يحتوي على كباب بلدي، ريش غنم، وكفتة متبلة.',
    ),
  ];

  AppProvider() {
    // Initial Mock Cart item
    _cartItems.add(
      CartItem(
        product: products[1],
        weightLabel: '1 كجم',
        weightMultiplier: 1.0,
        quantity: 1,
        cut: 'مكعبات خضار وطبخ (قطع صغيرة)',
        packaging: 'أطباق فوم مفرغة من الهواء (Vacuum)',
        notes: 'تقطيع متساوي بدون شحم زائد',
        totalPrice: 380,
      ),
    );
  }

  // Filtered Products
  List<Product> get filteredProducts {
    String normalize(String value) => value
        .toLowerCase()
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u0640]'), '')
        .replaceAll(RegExp('[أإآٱ]'), 'ا')
        .replaceAll('ى', 'ي')
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
    final terms = normalize(_searchQuery).split(' ').where((t) => t.isNotEmpty);
    return products.where((p) {
      final matchesCat =
          _currentCategory == 'all' || p.category == _currentCategory;
      final categoryName =
          categories.firstWhere((c) => c.id == p.category).name;
      final searchable =
          normalize('${p.title} ${p.subtitle} ${p.description} $categoryName');
      final matchesSearch = terms.every(searchable.contains);
      return matchesCat && matchesSearch;
    }).toList();
  }

  // Cart Totals
  double get cartSubtotal =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => 25.0;
  double get cartTotal => cartSubtotal + deliveryFee;

  // Flow Navigation Methods
  void setFlow(AppFlow flow) {
    _currentFlow = flow;
    _persist();
    notifyListeners();
  }

  void setTab(int index) {
    _currentTab = index;
    _persist();
    notifyListeners();
  }

  void setCategory(String catId) {
    _currentCategory = catId;
    notifyListeners();
  }

  void openCategory(String catId) {
    _currentCategory = catId == 'extras' ? 'all' : catId;
    _categoryListing = true;
    notifyListeners();
  }

  void showCategoryCards() {
    _categoryListing = false;
    _currentCategory = 'all';
    _searchQuery = '';
    notifyListeners();
  }

  void selectAddress(DeliveryAddress address) {
    final index = addresses.indexWhere((a) => a.id == address.id);
    if (index < 0) return;
    _addressIndex = index;
    notifyListeners();
  }

  void updateProfile({String? name, String? email, String? phone}) {
    if (name != null) _customerName = name;
    if (email != null) _customerEmail = email;
    if (phone != null) _customerPhone = phone;
    _persist();
    notifyListeners();
  }

  void markNotificationsRead() {
    _notificationsRead = true;
    notifyListeners();
  }

  void confirmOrder(OrderSummary order, {String paymentMethod = 'cash'}) {
    completedOrder = order;
    orders.insert(
        0,
        OrderRecord(
            number: 5413 + orders.length,
            items: List.of(_cartItems),
            summary: order,
            paymentMethod: paymentMethod,
            createdAt: DateTime.now()));
    _cartItems.clear();
    notifyListeners();
  }

  void markOrderDelivered(OrderRecord order) {
    order.delivered = true;
    notifyListeners();
  }

  void rateOrder(OrderRecord order, int rating) {
    order.rating = rating;
    notifyListeners();
  }

  /// Copies the items of a previous order back into the cart.
  void reorder(Iterable<CartItem> items) {
    for (final i in items) {
      _cartItems.insert(
          0,
          CartItem(
              product: i.product,
              weightLabel: i.weightLabel,
              weightMultiplier: i.weightMultiplier,
              quantity: i.quantity,
              cut: i.cut,
              packaging: i.packaging,
              headOption: i.headOption,
              offalOption: i.offalOption,
              notes: i.notes,
              totalPrice: i.totalPrice));
    }
    _currentTab = 2;
    _persist();
    notifyListeners();
  }

  // Addresses
  void addAddress(DeliveryAddress address, {bool makeDefault = false}) {
    addresses.add(address);
    if (makeDefault) _addressIndex = addresses.length - 1;
    notifyListeners();
  }

  void updateAddress(DeliveryAddress address) {
    final index = addresses.indexWhere((a) => a.id == address.id);
    if (index < 0) return;
    addresses[index] = address;
    notifyListeners();
  }

  bool removeAddress(String id) {
    if (addresses.length <= 1) return false;
    final currentId = currentAddress.id;
    addresses.removeWhere((a) => a.id == id);
    final keep = addresses.indexWhere((a) => a.id == currentId);
    _addressIndex = keep < 0 ? 0 : keep;
    notifyListeners();
    return true;
  }

  // Payment cards
  void addCard(SavedCard card) {
    cards.add(card);
    notifyListeners();
  }

  void removeCard(String id) {
    cards.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  /// Clears every piece of user data and returns to the login screen.
  Future<void> deleteAccount() async {
    _cartItems.clear();
    orders.clear();
    cards.clear();
    _wishlist.clear();
    completedOrder = null;
    _customerName = '';
    _customerEmail = '';
    _customerCity = 'الرياض';
    _customerPhone = '';
    _isFirstTimeUser = true;
    _currentTab = 0;
    _categoryListing = false;
    _currentCategory = 'all';
    _searchQuery = '';
    try {
      await _prefs?.clear();
    } catch (_) {}
    _currentFlow = AppFlow.login;
    _persist();
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query;
    if (_currentTab == 1 && !_categoryListing) _currentCategory = 'all';
    notifyListeners();
  }

  // Auth Logic: Phone entry & verification
  void submitPhoneNumber(String phone, String dialCode) {
    final cleanPhone = phone
        .replaceAll(RegExp(r'\D'), '')
        .replaceFirst(RegExp(r'^966'), '')
        .replaceFirst(RegExp(r'^0+'), '');
    _isFirstTimeUser = !_registeredPhones.contains(cleanPhone);
    _phoneForOtp = '$dialCode $phone';
    _currentFlow = AppFlow.otp;
    _persist();
    notifyListeners();
  }

  void verifyOtpSuccess() {
    if (_isFirstTimeUser) {
      _currentFlow = AppFlow.profileSetup;
    } else {
      _currentFlow = AppFlow.locationPermission;
    }
    _persist();
    notifyListeners();
  }

  void completeProfileSetup(
      {required String name, required String email, required String city}) {
    _customerName = name;
    _customerEmail = email;
    _customerCity = city;
    _customerPhone = _phoneForOtp;
    final clean = _phoneForOtp
        .replaceAll(RegExp(r'\D'), '')
        .replaceFirst(RegExp(r'^966'), '')
        .replaceFirst(RegExp(r'^0+'), '');
    if (clean.isNotEmpty) {
      _registeredPhones.add(clean);
    }
    _currentFlow = AppFlow.locationPermission;
    _persist();
    notifyListeners();
  }

  // Cart Operations
  void addToCart(CartItem item) {
    _cartItems.insert(0, item);
    notifyListeners();
  }

  void updateQuantity(int index, int newQty) {
    if (index >= 0 && index < _cartItems.length) {
      if (newQty <= 0) {
        _cartItems.removeAt(index);
      } else {
        final item = _cartItems[index];
        final unitPrice = item.totalPrice / item.quantity;
        item.quantity = newQty;
        // Total price recalculation
        _cartItems[index] = CartItem(
          product: item.product,
          weightLabel: item.weightLabel,
          weightMultiplier: item.weightMultiplier,
          quantity: newQty,
          cut: item.cut,
          packaging: item.packaging,
          headOption: item.headOption,
          offalOption: item.offalOption,
          notes: item.notes,
          totalPrice: unitPrice * newQty,
        );
      }
      notifyListeners();
    }
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  void toggleWishlist(int productId) {
    if (_wishlist.contains(productId)) {
      _wishlist.remove(productId);
    } else {
      _wishlist.add(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
