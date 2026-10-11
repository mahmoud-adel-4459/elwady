import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/delivery_address.dart';
import '../models/order_summary.dart';

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
    notifyListeners();
  }

  void setTab(int index) {
    _currentTab = index;
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
    notifyListeners();
  }

  void markNotificationsRead() {
    _notificationsRead = true;
    notifyListeners();
  }

  void confirmOrder(OrderSummary order) {
    completedOrder = order;
    _cartItems.clear();
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
    notifyListeners();
  }

  void verifyOtpSuccess() {
    if (_isFirstTimeUser) {
      _currentFlow = AppFlow.profileSetup;
    } else {
      _currentFlow = AppFlow.locationPermission;
    }
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
