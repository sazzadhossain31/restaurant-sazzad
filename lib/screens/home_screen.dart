import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/recipe_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../models/recipe_model.dart';
import '../theme/app_theme.dart';
import '../widgets/food_widgets.dart';
import 'recipe_detail_screen.dart';
import 'profile_features/order_history_screen.dart';
import 'profile_features/manage_addresses_screen.dart';
import 'profile_features/payment_methods_screen.dart';
import 'profile_features/notifications_settings_screen.dart';
import 'profile_features/security_privacy_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  String _query = '';
  final _search = TextEditingController();
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _open(Widget page) =>
      Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));

  Widget _countBadge(int count, IconData icon) => Badge(
    isLabelVisible: count > 0,
    label: Text(count > 99 ? '99+' : '$count'),
    child: Icon(icon),
  );

  void _checkout(CartProvider cart) {
    final itemCount = cart.itemCount;
    final total = cart.totalAmount;

    // This app does not have a payment gateway yet, so checkout confirms the
    // locally saved order and resets the bag for the next order.
    cart.clearCart();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E22),
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppTheme.orange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 40,
                color: AppTheme.ink,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Order confirmed!',
              style: Theme.of(dialogContext).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Congratulations! Your $itemCount ${itemCount == 1 ? 'item is' : 'items are'} on the way. Total: \$${total.toStringAsFixed(2)}.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.muted, height: 1.5),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (mounted) setState(() => _tab = 0);
              },
              child: const Text('Keep exploring'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().itemCount;
    final favoriteCount = context.watch<FavoritesProvider>().itemCount;
    final destinations = [
      const NavigationDestination(
        icon: Icon(Icons.restaurant_menu_outlined),
        selectedIcon: Icon(Icons.restaurant_menu),
        label: 'Explore',
      ),
      NavigationDestination(
        icon: _countBadge(cartCount, Icons.shopping_bag_outlined),
        selectedIcon: _countBadge(cartCount, Icons.shopping_bag),
        label: 'My bag',
      ),
      NavigationDestination(
        icon: _countBadge(favoriteCount, Icons.favorite_border),
        selectedIcon: _countBadge(favoriteCount, Icons.favorite),
        label: 'Favorites',
      ),
      const NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Account',
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.orange,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.restaurant_menu_rounded,
                color: AppTheme.ink,
                size: 22,
              ),
            ),
            const SizedBox(width: 11),
            const Text(
              'SAVORIA',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: 1.3,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'My account',
            onPressed: () => setState(() => _tab = 3),
            icon: CircleAvatar(
              backgroundColor: AppTheme.orange.withValues(alpha: .15),
              child: const Icon(Icons.person_outline, color: AppTheme.orange),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (constraints.maxWidth >= 950)
              NavigationRail(
                selectedIndex: _tab,
                onDestinationSelected: (i) => setState(() => _tab = i),
                labelType: NavigationRailLabelType.all,
                backgroundColor: AppTheme.cream,
                indicatorColor: AppTheme.orange,
                selectedIconTheme: const IconThemeData(color: AppTheme.ink),
                destinations: destinations
                    .map(
                      (d) => NavigationRailDestination(
                        icon: d.icon,
                        selectedIcon: d.selectedIcon,
                        label: Text(d.label),
                      ),
                    )
                    .toList(),
              ),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: RefreshIndicator(
                    onRefresh: context.read<RecipeProvider>().refreshRecipes,
                    child: ListView(
                      padding: EdgeInsets.all(
                        constraints.maxWidth < 600 ? 20 : 32,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        if (_tab == 0)
                          ..._menu()
                        else if (_tab == 1)
                          ..._cart()
                        else if (_tab == 2)
                          ..._favorites()
                        else
                          ..._profile(),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MediaQuery.sizeOf(context).width < 950
          ? NavigationBar(
              selectedIndex: _tab,
              onDestinationSelected: (i) => setState(() => _tab = i),
              destinations: destinations,
            )
          : null,
    );
  }

  List<Widget> _menu() {
    final menu = context.watch<RecipeProvider>();
    final results = menu.recipes
        .where(
          (r) => '${r.title} ${r.restaurant} ${r.category}'
              .toLowerCase()
              .contains(_query),
        )
        .toList();
    return [
      Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE8A838), Color(0xFFB5741A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(34),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.ink,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      '🔥 SPECIAL OFFER • 35% OFF',
                      style: TextStyle(
                        color: AppTheme.orange,
                        letterSpacing: 1.4,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Savor 35% Off\nYour Next Feast',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.ink,
                      letterSpacing: -1,
                      height: 1.12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Handcrafted artisan recipes, seasonal gourmet specials & free priority delivery.',
                    style: TextStyle(
                      color: AppTheme.ink.withValues(alpha: .8),
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.ink,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.ink.withValues(alpha: .2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.confirmation_number_outlined,
                          color: AppTheme.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'CODE: SAVOR35',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '35% off orders \$30+ • Free delivery',
                                style: TextStyle(
                                  color: AppTheme.orange,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (MediaQuery.sizeOf(context).width > 600)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.ink.withValues(alpha: .12),
                    border: Border.all(
                      color: AppTheme.ink.withValues(alpha: .25),
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.percent_rounded,
                          size: 38,
                          color: AppTheme.ink,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'LIMITED',
                          style: TextStyle(
                            color: AppTheme.ink,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 28),
      TextField(
        controller: _search,
        onChanged: (value) =>
            setState(() => _query = value.trim().toLowerCase()),
        decoration: InputDecoration(
          hintText: 'Search handcrafted dishes, gourmet kitchens, or cuisines…',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear search',
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _search.clear();
                    setState(() => _query = '');
                  },
                ),
        ),
      ),
      const SizedBox(height: 18),
      Wrap(
        spacing: 10,
        runSpacing: 8,
        children: menu.categories
            .map(
              (c) => ChoiceChip(
                label: Text(c),
                selected: menu.selectedCategory == c,
                onSelected: (_) => menu.selectCategory(c),
                showCheckmark: false,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 9,
                ),
              ),
            )
            .toList(),
      ),
      const SizedBox(height: 30),
      Row(
        children: [
          Expanded(
            child: Text(
              _query.isEmpty ? "Chef's Menu" : 'Search results',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppTheme.orange.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              '${results.length} dishes',
              style: const TextStyle(
                color: AppTheme.orange,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      if (menu.isLoading)
        const Center(
          child: Padding(
            padding: EdgeInsets.all(48),
            child: CircularProgressIndicator(),
          ),
        )
      else if (menu.errorMessage != null)
        EmptyState(
          title: 'Menu unavailable',
          message: menu.errorMessage!,
          icon: Icons.wifi_off,
          action: FilledButton(
            onPressed: menu.refreshRecipes,
            child: const Text('Try again'),
          ),
        )
      else if (results.isEmpty)
        const EmptyState(
          title: 'No culinary matches found',
          message: 'Try exploring another category or adjusting your search keywords.',
        )
      else
        _grid(results),
    ];
  }

  Widget _grid(List<RecipeModel> recipes) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth > 860
          ? 3
          : constraints.maxWidth > 530
          ? 2
          : 1;
      final width = (constraints.maxWidth - (columns - 1) * 18) / columns;
      return Wrap(
        spacing: 18,
        runSpacing: 18,
        children: recipes
            .map((r) => SizedBox(width: width, child: _card(r)))
            .toList(),
      );
    },
  );
  Widget _card(RecipeModel r) {
    final favorites = context.watch<FavoritesProvider>();
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              InkWell(
                onTap: () => _open(RecipeDetailScreen(recipe: r)),
                child: FoodImage(url: r.imageUrl),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: IconButton.filledTonal(
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.ink.withValues(alpha: .7),
                  ),
                  tooltip: favorites.isFavorite(r.id)
                      ? 'Remove from favorites'
                      : 'Save to favorites',
                  onPressed: () => favorites.toggleFavorite(r.id),
                  icon: Icon(
                    favorites.isFavorite(r.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: AppTheme.orange,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.restaurant.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.3,
                    color: AppTheme.orange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 7),
                InkWell(
                  onTap: () => _open(RecipeDetailScreen(recipe: r)),
                  child: Text(
                    r.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${r.cookTimeMinutes} min  ·  ${r.calories} kcal',
                  style: const TextStyle(color: AppTheme.muted),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '\$${r.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    FilledButton.tonal(
                      onPressed: () {
                        context.read<CartProvider>().addItem(r);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${r.title} added to your dining bag'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text('+ Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _favorites() {
    final menu = context.watch<RecipeProvider>();
    final favorites = context.watch<FavoritesProvider>();
    final recipes = menu.allRecipes
        .where((r) => favorites.isFavorite(r.id))
        .toList();
    return [
      Text('Your Curated Favorites', style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 8),
      const Text(
        'The signature culinary creations you love returning to.',
        style: TextStyle(color: AppTheme.muted),
      ),
      const SizedBox(height: 28),
      if (menu.isLoading)
        const Center(child: CircularProgressIndicator())
      else if (menu.errorMessage != null)
        EmptyState(
          title: 'Favorites unavailable',
          message: menu.errorMessage!,
          action: FilledButton(
            onPressed: menu.refreshRecipes,
            child: const Text('Try again'),
          ),
        )
      else if (recipes.isEmpty)
        EmptyState(
          title: 'Your tasting list is empty',
          message: 'Tap the heart on any dish to save it to your curated favorites.',
          icon: Icons.favorite_border,
          action: FilledButton(
            onPressed: () => setState(() => _tab = 0),
            child: const Text("Explore Chef's Menu"),
          ),
        )
      else
        _grid(recipes),
    ];
  }

  List<Widget> _cart() {
    final cart = context.watch<CartProvider>();
    return [
      Text('Your Dining Bag', style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 8),
      Text(
        '${cart.itemCount} items, handpicked for your feast.',
        style: const TextStyle(color: AppTheme.muted),
      ),
      const SizedBox(height: 28),
      if (cart.isEmpty)
        EmptyState(
          title: 'Your dining bag is empty',
          message: 'Explore our artisan menu and add your favorite dishes to begin.',
          icon: Icons.shopping_bag_outlined,
          action: FilledButton(
            onPressed: () => setState(() => _tab = 0),
            child: const Text("Explore Chef's Menu"),
          ),
        )
      else ...[
        ...cart.items.entries.map((entry) {
          final item = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 72,
                            child: FoodImage(
                              url: item.recipe.imageUrl,
                              height: 72,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.recipe.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                '\$${item.recipe.price.toStringAsFixed(2)} each',
                                style: const TextStyle(color: AppTheme.muted),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Remove item',
                          onPressed: () => cart.removeItem(entry.key),
                          icon: const Icon(Icons.close, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton.outlined(
                          tooltip: 'Decrease quantity',
                          onPressed: () =>
                              cart.updateQuantity(entry.key, item.quantity - 1),
                          icon: const Icon(Icons.remove),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('${item.quantity}'),
                        ),
                        IconButton.outlined(
                          tooltip: 'Increase quantity',
                          onPressed: () =>
                              cart.updateQuantity(entry.key, item.quantity + 1),
                          icon: const Icon(Icons.add),
                        ),
                        const Spacer(),
                        Text(
                          '\$${(item.quantity * item.recipe.price).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Subtotal',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Ready to feast? Review your selections, then proceed to secure checkout.',
                  style: TextStyle(color: AppTheme.muted, height: 1.5),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () => _checkout(cart),
                  icon: const Icon(Icons.lock_outline),
                  label: Text(
                    'Checkout \$${cart.totalAmount.toStringAsFixed(2)}',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ];
  }

  List<Widget> _profile() {
    final auth = context.watch<AuthProvider>();
    return [
      Text('Dining Profile', style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 24),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: AppTheme.orange,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 32,
                  color: AppTheme.ink,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to the Table',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      auth.user?.email ?? '',
                      style: const TextStyle(color: AppTheme.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 24),
      _profileLink(
        Icons.receipt_long_outlined,
        'Dining history',
        'Past orders & receipts',
        const OrderHistoryScreen(),
      ),
      _profileLink(
        Icons.location_on_outlined,
        'Delivery addresses',
        'Saved homes, offices & destinations',
        const ManageAddressesScreen(),
      ),
      _profileLink(
        Icons.credit_card,
        'Payment methods',
        'Manage secure payment cards & options',
        const PaymentMethodsScreen(),
      ),
      _profileLink(
        Icons.notifications_outlined,
        'Notifications',
        'Chef specials, offers & order updates',
        const NotificationsSettingsScreen(),
      ),
      _profileLink(
        Icons.shield_outlined,
        'Security & privacy',
        'Account security & data preferences',
        const SecurityPrivacyScreen(),
      ),
      const SizedBox(height: 20),
      Semantics(
        label: auth.isLoading ? 'Signing out' : 'Sign out of your account',
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(72),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              foregroundColor: const Color(0xFFFF6B6B),
              backgroundColor: const Color(0xFF2A1515),
              side: const BorderSide(color: Color(0xFF4A2020)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            onPressed: auth.isLoading
                ? null
                : () async {
                    await auth.signOut();
                    if (!mounted) return;
                    if (auth.errorMessage != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        SnackBar(content: Text(auth.errorMessage!)),
                      );
                    }
                  },
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A1A1A),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.logout_rounded),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign out of Savoria',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'You can sign back in any time to resume dining',
                        style: TextStyle(fontSize: 12, color: AppTheme.muted),
                      ),
                    ],
                  ),
                ),
                if (auth.isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  Widget _profileLink(
    IconData icon,
    String title,
    String subtitle,
    Widget page,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppTheme.orange.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppTheme.orange),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppTheme.muted)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _open(page),
      ),
    ),
  );
}
