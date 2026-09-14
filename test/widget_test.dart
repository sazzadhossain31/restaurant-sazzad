import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant/providers/cart_provider.dart';
import 'package:restaurant/providers/favorites_provider.dart';
import 'package:restaurant/providers/recipe_provider.dart';
import 'package:restaurant/services/menu_service.dart';
import 'package:restaurant/screens/recipe_detail_screen.dart';
import 'package:restaurant/screens/profile_features/order_history_screen.dart';
import 'package:restaurant/theme/app_theme.dart';
import 'package:restaurant/providers/auth_provider.dart';
import 'package:restaurant/screens/login_screen.dart';
import 'package:restaurant/screens/home_screen.dart';
import 'package:restaurant/main.dart';
import 'package:restaurant/models/user_model.dart';

class JsonBundle extends CachingAssetBundle {
  final String content;
  JsonBundle(this.content);
  @override
  Future<String> loadString(String key, {bool cache = true}) async => content;
  @override
  Future<ByteData> load(String key) async => throw UnimplementedError();
}

class TestAuth extends ChangeNotifier implements AuthProvider {
  bool loading = false;
  @override
  UserModel? get user => null;
  @override
  bool get isLoading => loading;
  @override
  bool get isAuthenticated => false;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Bundled JSON has unique menu IDs and usable fields', () async {
    final menu = await MenuService().loadMenu();
    expect(menu, isNotEmpty);
    expect(menu.map((r) => r.id).toSet().length, menu.length);
    expect(menu.every((r) => r.price > 0 && r.ingredients.isNotEmpty), isTrue);
  });
  test('Duplicate IDs and invalid prices are rejected', () async {
    final data =
        jsonDecode(await rootBundle.loadString('assets/data/menu.json'))
            as Map<String, dynamic>;
    final rows = data['recipes'] as List;
    rows.add(rows.first);
    await expectLater(
      MenuService(bundle: JsonBundle(jsonEncode(data))).loadMenu(),
      throwsFormatException,
    );
    rows.removeLast();
    rows.first['price'] = -1;
    await expectLater(
      MenuService(bundle: JsonBundle(jsonEncode(data))).loadMenu(),
      throwsFormatException,
    );
  });
  test('Provider filters JSON and preserves full catalog', () async {
    final provider = RecipeProvider();
    while (provider.isLoading) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    expect(provider.errorMessage, isNull);
    final total = provider.allRecipes.length;
    provider.selectCategory('Pizza');
    expect(provider.recipes.every((r) => r.category == 'Pizza'), isTrue);
    expect(provider.allRecipes.length, total);
    provider.dispose();
  });
  test('Malformed JSON surfaces a recoverable error', () async {
    final provider = RecipeProvider(
      service: MenuService(bundle: JsonBundle('invalid')),
    );
    while (provider.isLoading) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    expect(provider.errorMessage, isNotNull);
    expect(provider.recipes, isEmpty);
    await provider.refreshRecipes();
    expect(provider.isLoading, isFalse);
    provider.dispose();
  });
  test(
    'Cart quantities, totals and JSON persistence work without legacy samples',
    () async {
      SharedPreferences.setMockInitialValues({'cart_items': '{"old":{}}'});
      final prefs = await SharedPreferences.getInstance();
      final recipe = (await MenuService().loadMenu()).first;
      final cart = CartProvider(prefs);
      expect(cart.isEmpty, isTrue);
      cart.addItem(recipe, quantity: 2);
      expect(cart.totalAmount, recipe.price * 2);
      cart.updateQuantity(recipe.id, 3);
      expect(CartProvider(prefs).itemCount, 3);
      cart.updateQuantity(recipe.id, 0);
      expect(cart.isEmpty, isTrue);
    },
  );
  testWidgets('Dish details fit a narrow screen and add the chosen quantity', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final recipe = (await tester.runAsync(
      () => MenuService().loadMenu(),
    ))!.first;
    final cart = CartProvider(prefs);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: cart),
          ChangeNotifierProvider(create: (_) => FavoritesProvider(prefs)),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: RecipeDetailScreen(recipe: recipe),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Add to bag'), 300);
    await tester.tap(find.byTooltip('Increase quantity'));
    await tester.pump();
    await tester.tap(find.text('Add to bag'));
    await tester.pump();
    expect(cart.itemCount, 2);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Order history shows no invented orders', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const OrderHistoryScreen()),
    );
    await tester.pumpAndSettle();
    expect(find.text('No orders yet'), findsOneWidget);
    expect(find.text('Delivered'), findsNothing);
  });
  for (final size in [const Size(360, 800), const Size(1280, 900)]) {
    testWidgets('Login and registration fit $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => TestAuth(),
          child: MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Sign in'));
      await tester.tap(find.text('Sign in'));
      await tester.pump();
      expect(find.text('Enter a valid email address.'), findsOneWidget);
      await tester.ensureVisible(find.text('Create an account'));
      await tester.tap(find.text('Create an account'));
      await tester.pumpAndSettle();
      expect(find.text('Join Savoria.\nTaste extraordinary.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('Menu searches JSON and favorites ignore category selection', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final provider = RecipeProvider();
    await tester.runAsync(() async {
      while (provider.isLoading) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    });
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(create: (_) => TestAuth()),
          ChangeNotifierProvider.value(value: provider),
          ChangeNotifierProvider(create: (_) => CartProvider(prefs)),
          ChangeNotifierProvider(create: (_) => FavoritesProvider(prefs)),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'garden margherita');
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('1 dishes'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('1 dishes'), findsOneWidget);
    await tester.ensureVisible(find.byTooltip('Save to favorites'));
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 100));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Save to favorites'));
    provider.selectCategory('Bowls');
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('Garden margherita'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Wishlist badge and checkout confirmation reflect cart state', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final recipes = RecipeProvider();
    await tester.runAsync(() async {
      while (recipes.isLoading) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    });
    final recipe = recipes.allRecipes.first;
    final cart = CartProvider(prefs)..addItem(recipe);
    final favorites = FavoritesProvider(prefs)..toggleFavorite(recipe.id);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(create: (_) => TestAuth()),
          ChangeNotifierProvider.value(value: recipes),
          ChangeNotifierProvider.value(value: cart),
          ChangeNotifierProvider.value(value: favorites),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(favorites.itemCount, 1);
    expect(find.text('1'), findsNWidgets(2));

    await tester.tap(find.text('My bag'));
    await tester.pumpAndSettle();
    final checkoutLabel = 'Checkout \$${recipe.price.toStringAsFixed(2)}';
    await tester.scrollUntilVisible(find.text(checkoutLabel), 200);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -200));
    await tester.pumpAndSettle();
    await tester.tap(find.text(checkoutLabel));
    await tester.pumpAndSettle();

    expect(cart.isEmpty, isTrue);
    expect(find.text('Order confirmed!'), findsOneWidget);
    expect(find.textContaining('Congratulations!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Auth gate keeps the sign-in form mounted while submitting', (
    tester,
  ) async {
    final auth = TestAuth();
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>.value(
        value: auth,
        child: MaterialApp(theme: AppTheme.light, home: const AuthGate()),
      ),
    );
    await tester.enterText(
      find.byType(TextFormField).first,
      'person@example.com',
    );
    auth.loading = true;
    // Simulate the provider's submission notification.
    auth.notifyListeners();
    await tester.pump();
    expect(find.text('person@example.com'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}
