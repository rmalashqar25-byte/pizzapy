import 'package:flutter/material.dart';

void main() => runApp(const PyApp());

const ink = Color(0xFF241E1A);
const red = Color(0xFFD9362B);
const cream = Color(0xFFFAF6EF);
const muted = Color(0xFF817A73);
const yellow = Color(0xFFFFD35A);

class Food {
  const Food(
    this.name,
    this.description,
    this.category,
    this.price,
    this.image,
    this.tag,
  );
  final String name, description, category, image, tag;
  final double price;
}

const foods = <Food>[
  Food(
    'Classic Margherita',
    'Tomato, fresh mozzarella, basil & olive oil',
    'Pizza',
    8.99,
    'assets/images/margherita.png',
    'BEST SELLER',
  ),
  Food(
    'Pepperoni Pop',
    'Crispy pepperoni, mozzarella & house sauce',
    'Pizza',
    10.99,
    'assets/images/pepperoni.png',
    'POPULAR',
  ),
  Food(
    'Smoky BBQ Chicken',
    'Grilled chicken, red onion & smoky BBQ',
    'Pizza',
    12.49,
    'assets/images/bbq_chicken.png',
    'NEW',
  ),
  Food(
    'Garden Party',
    'Roasted veggies, olives, basil & mozzarella',
    'Pizza',
    10.49,
    'assets/images/veggie.png',
    'FRESH',
  ),
  Food(
    'Loaded Fries',
    'Golden fries, parmesan & fresh herbs',
    'Sides',
    4.99,
    'assets/images/fries.png',
    'SIDE KICK',
  ),
];

String cash(double amount) =>
    String.fromCharCode(36) + amount.toStringAsFixed(2);

class PyApp extends StatelessWidget {
  const PyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Py Pizza',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: cream,
      colorScheme: ColorScheme.fromSeed(seedColor: red, primary: red),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: ink,
          fontSize: 34,
          height: 1.04,
          fontWeight: FontWeight.w900,
        ),
        headlineMedium: TextStyle(
          color: ink,
          fontSize: 27,
          fontWeight: FontWeight.w900,
        ),
        titleLarge: TextStyle(
          color: ink,
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
      ),
    ),
    home: const PyHome(),
  );
}

class PyHome extends StatefulWidget {
  const PyHome({super.key});
  @override
  State<PyHome> createState() => _PyHomeState();
}

class _PyHomeState extends State<PyHome> {
  int page = 0;
  String category = 'All';
  final search = TextEditingController();
  final Map<Food, int> cart = {};
  final Set<Food> favorites = {};

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  int get count => cart.values.fold(0, (a, b) => a + b);
  double get subtotal =>
      cart.entries.fold(0, (sum, entry) => sum + entry.key.price * entry.value);

  void menu([String filter = 'All']) => setState(() {
    page = 1;
    category = filter;
  });
  void add(Food food, [int amount = 1]) {
    setState(() => cart[food] = (cart[food] ?? 0) + amount);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${food.name} added to your bag'),
        backgroundColor: ink,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'VIEW BAG',
          textColor: yellow,
          onPressed: () => setState(() => page = 2),
        ),
      ),
    );
  }

  void detail(Food food) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: cream,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (_) => FoodSheet(food: food, onAdd: add),
  );
  void quantity(Food food, int change) => setState(() {
    final next = (cart[food] ?? 0) + change;
    if (next < 1) {
      cart.remove(food);
    } else {
      cart[food] = next;
    }
  });

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 620),
      child: Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: page,
            children: [homePage(), menuPage(), cartPage()],
          ),
        ),
        bottomNavigationBar: bottomBar(),
      ),
    ),
  );

  Widget header() => Padding(
    padding: const EdgeInsets.fromLTRB(24, 13, 24, 15),
    child: Row(
      children: [
        Container(
          width: 47,
          height: 47,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: red,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text(
            'Py',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -2,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PY PIZZA',
              style: TextStyle(
                color: ink,
                fontSize: 15,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
            ),
            Text(
              'Good food. Great mood.',
              style: TextStyle(color: muted, fontSize: 11),
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: () => setState(() => page = 2),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 47,
            height: 47,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.shopping_bag_outlined, color: ink),
                if (count > 0)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: red,
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget homePage() => ListView(
    children: [
      header(),
      const Padding(
        padding: EdgeInsets.fromLTRB(24, 12, 24, 4),
        child: Text(
          'Hey, pizza lover 👋',
          style: TextStyle(
            color: muted,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          'Your next favorite\nbite is here.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      const SizedBox(height: 21),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: InkWell(
          onTap: () => menu(),
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: muted),
                SizedBox(width: 11),
                Text(
                  'Search pizza, sides...',
                  style: TextStyle(color: muted, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 22),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          height: 215,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: red,
            borderRadius: BorderRadius.circular(27),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -90,
                top: -50,
                child: Container(
                  width: 275,
                  height: 275,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE44B38),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: -43,
                top: 10,
                child: ClipOval(
                  child: Image.asset(
                    foods.first.image,
                    width: 204,
                    height: 204,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(left: 21, top: 21, child: tag('THE PY SPECIAL')),
              const Positioned(
                left: 21,
                top: 62,
                child: Text(
                  'Pizza that\nhits different.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    height: 1.08,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Positioned(
                left: 21,
                bottom: 18,
                child: FilledButton(
                  onPressed: () => detail(foods.first),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: red,
                    minimumSize: const Size(0, 38),
                  ),
                  child: const Text(
                    'Order now  →',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 25),
      section('What are you craving?', 'Explore all', () => menu()),
      const SizedBox(height: 12),
      SizedBox(
        height: 94,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            categoryTile(
              'All food',
              Icons.restaurant_menu_rounded,
              yellow,
              () => menu(),
            ),
            categoryTile(
              'Pizza',
              Icons.local_pizza_rounded,
              const Color(0xFFFFE4DA),
              () => menu('Pizza'),
            ),
            categoryTile(
              'Sides',
              Icons.fastfood_rounded,
              const Color(0xFFE4EAD9),
              () => menu('Sides'),
            ),
          ],
        ),
      ),
      const SizedBox(height: 22),
      section('Crowd favorites', 'See menu', () => menu()),
      const SizedBox(height: 12),
      SizedBox(
        height: 260,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: 4,
          separatorBuilder: (context, index) => const SizedBox(width: 13),
          itemBuilder: (_, i) => featured(foods[i]),
        ),
      ),
      const SizedBox(height: 25),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(19),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE9C6),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Row(
            children: [
              CircleAvatar(
                backgroundColor: yellow,
                child: Icon(Icons.local_fire_department_rounded, color: ink),
              ),
              SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fresh from the oven',
                      style: TextStyle(color: ink, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      'Made for your good mood, every day.',
                      style: TextStyle(color: muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 28),
    ],
  );

  Widget section(String title, String action, VoidCallback onTap) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            '$action  →',
            style: const TextStyle(
              color: red,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );
  Widget categoryTile(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) => Padding(
    padding: const EdgeInsets.only(right: 11),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),
      child: Container(
        width: 115,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(19),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: ink, size: 27),
            Text(
              title,
              style: const TextStyle(
                color: ink,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    ),
  );
  Widget tag(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: yellow,
      borderRadius: BorderRadius.circular(7),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: ink,
        fontSize: 9,
        fontWeight: FontWeight.w900,
        letterSpacing: .4,
      ),
    ),
  );
  Widget featured(Food food) => GestureDetector(
    onTap: () => detail(food),
    child: Container(
      width: 188,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(21),
                ),
                child: Image.asset(
                  food.image,
                  width: 188,
                  height: 145,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(top: 9, left: 9, child: tag(food.tag)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Text(
              food.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: ink,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 2, 12, 0),
            child: Text(
              food.category,
              style: const TextStyle(color: muted, fontSize: 11),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 1, 9, 6),
            child: Row(
              children: [
                Text(
                  cash(food.price),
                  style: const TextStyle(
                    color: red,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                addButton(food),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget menuPage() {
    final term = search.text.trim().toLowerCase();
    final matches = foods
        .where(
          (food) =>
              (category == 'All' ||
                  category == food.category ||
                  (category == 'Favorites' && favorites.contains(food))) &&
              (term.isEmpty ||
                  '${food.name} ${food.description} ${food.category}'
                      .toLowerCase()
                      .contains(term)),
        )
        .toList();
    return Column(
      children: [
        header(),
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 9, 24, 2),
                child: Text(
                  'Explore the menu',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Your cravings have excellent taste.',
                  style: TextStyle(color: muted, fontSize: 13),
                ),
              ),
              const SizedBox(height: 19),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  key: const ValueKey('menu-search'),
                  controller: search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search pizza, sides...',
                    hintStyle: const TextStyle(color: muted, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: muted),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    for (final value in ['All', 'Pizza', 'Sides', 'Favorites'])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(value),
                          selected: category == value,
                          showCheckmark: false,
                          onSelected: (_) => setState(() => category = value),
                          backgroundColor: Colors.white,
                          selectedColor: ink,
                          side: BorderSide.none,
                          labelStyle: TextStyle(
                            color: category == value ? Colors.white : ink,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 17),
              if (matches.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 65, horizontal: 24),
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded, size: 50, color: muted),
                      SizedBox(height: 12),
                      Text(
                        'Nothing on the menu matches that yet.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: muted),
                      ),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: LayoutBuilder(
                    builder: (_, box) => Wrap(
                      spacing: 12,
                      runSpacing: 13,
                      children: [
                        for (final food in matches)
                          SizedBox(
                            width: (box.maxWidth - 12) / 2,
                            child: menuCard(food),
                          ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ],
    );
  }

  Widget menuCard(Food food) => InkWell(
    onTap: () => detail(food),
    borderRadius: BorderRadius.circular(21),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(21),
                ),
                child: AspectRatio(
                  aspectRatio: 1.25,
                  child: Image.asset(food.image, fit: BoxFit.cover),
                ),
              ),
              Positioned(top: 8, left: 8, child: tag(food.tag)),
              Positioned(
                top: 2,
                right: 3,
                child: IconButton.filledTonal(
                  onPressed: () => setState(
                    () => favorites.contains(food)
                        ? favorites.remove(food)
                        : favorites.add(food),
                  ),
                  icon: Icon(
                    favorites.contains(food)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: favorites.contains(food) ? red : ink,
                    size: 18,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(34, 34),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(11, 10, 11, 0),
            child: Text(
              food.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: ink,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(11, 3, 11, 0),
            child: Text(
              food.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: muted, fontSize: 10, height: 1.25),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(11, 7, 8, 8),
            child: Row(
              children: [
                Text(
                  cash(food.price),
                  style: const TextStyle(
                    color: red,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                addButton(food),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  Widget addButton(Food food) => IconButton.filled(
    onPressed: () => add(food),
    icon: const Icon(Icons.add, size: 18),
    style: IconButton.styleFrom(
      backgroundColor: red,
      foregroundColor: Colors.white,
      minimumSize: const Size(33, 33),
      padding: EdgeInsets.zero,
    ),
  );

  Widget cartPage() => Column(
    children: [
      header(),
      Expanded(
        child: cart.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFE6D9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 53,
                          color: red,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Your bag is waiting.',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'A little pizza would look great in here.',
                        style: TextStyle(color: muted),
                      ),
                      const SizedBox(height: 22),
                      FilledButton(
                        onPressed: () => menu(),
                        style: FilledButton.styleFrom(backgroundColor: red),
                        child: const Text('Explore the menu'),
                      ),
                    ],
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(24, 9, 24, 24),
                children: [
                  Text(
                    'Your bag',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$count delicious ${count == 1 ? 'item' : 'items'} coming right up',
                    style: const TextStyle(color: muted, fontSize: 13),
                  ),
                  const SizedBox(height: 21),
                  for (final food in cart.keys.toList()) cartRow(food),
                  TextButton.icon(
                    onPressed: () => menu(),
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Add more tasty things'),
                    style: TextButton.styleFrom(
                      foregroundColor: red,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(19),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: Column(
                      children: [
                        priceRow('Subtotal', subtotal),
                        const SizedBox(height: 10),
                        priceRow('Delivery', 2.49),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Divider(height: 1),
                        ),
                        priceRow('Total', subtotal + 2.49, bold: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: muted),
                      SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          'Demo checkout: no real order or payment is made.',
                          style: TextStyle(color: muted, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
      if (cart.isNotEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 6, 24, 15),
          child: SizedBox(
            width: double.infinity,
            height: 53,
            child: FilledButton(
              key: const ValueKey('place-order'),
              onPressed: () {
                final ordered = count;
                setState(cart.clear);
                showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: cream,
                    title: const Text(
                      'Order up! 🍕',
                      style: TextStyle(color: ink, fontWeight: FontWeight.w900),
                    ),
                    content: Text(
                      'Your demo order for $ordered ${ordered == 1 ? 'item' : 'items'} is confirmed. Thanks for trying Py!',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Nice!'),
                      ),
                    ],
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Place demo order  •  ${cash(subtotal + 2.49)}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
    ],
  );
  Widget cartRow(Food food) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(19),
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Image.asset(
            food.image,
            width: 86,
            height: 86,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                food.name,
                maxLines: 2,
                style: const TextStyle(
                  color: ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                cash(food.price),
                style: const TextStyle(color: red, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: cream,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Column(
            children: [
              qtyButton(Icons.add, () => quantity(food, 1)),
              Text(
                '${cart[food]}',
                style: const TextStyle(color: ink, fontWeight: FontWeight.w900),
              ),
              qtyButton(Icons.remove, () => quantity(food, -1)),
            ],
          ),
        ),
      ],
    ),
  );
  Widget qtyButton(IconData icon, VoidCallback action) => InkWell(
    onTap: action,
    child: SizedBox(
      width: 29,
      height: 27,
      child: Icon(icon, size: 15, color: ink),
    ),
  );
  Widget priceRow(String label, double value, {bool bold = false}) => Row(
    children: [
      Text(
        label,
        style: TextStyle(
          color: bold ? ink : muted,
          fontWeight: bold ? FontWeight.w900 : FontWeight.w500,
          fontSize: bold ? 17 : 13,
        ),
      ),
      const Spacer(),
      Text(
        cash(value),
        style: TextStyle(
          color: bold ? red : ink,
          fontWeight: FontWeight.w900,
          fontSize: bold ? 18 : 13,
        ),
      ),
    ],
  );

  Widget bottomBar() => Container(
    padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: Color(0xFFF0EBE3))),
    ),
    child: SafeArea(
      top: false,
      child: Row(
        children: [
          nav(0, Icons.home_rounded, 'Home'),
          nav(1, Icons.restaurant_menu_rounded, 'Menu'),
          nav(2, Icons.shopping_bag_rounded, 'Bag'),
        ],
      ),
    ),
  );
  Widget nav(int index, IconData icon, String label) => Expanded(
    child: InkWell(
      key: ValueKey('nav-${label.toLowerCase()}'),
      onTap: () => setState(() => page = index),
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: page == index ? red : muted, size: 23),
                if (index == 2 && count > 0)
                  Positioned(
                    top: -5,
                    right: -8,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor: red,
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: page == index ? red : muted,
                fontSize: 11,
                fontWeight: page == index ? FontWeight.w900 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class FoodSheet extends StatefulWidget {
  const FoodSheet({super.key, required this.food, required this.onAdd});
  final Food food;
  final void Function(Food, int) onAdd;
  @override
  State<FoodSheet> createState() => _FoodSheetState();
}

class _FoodSheetState extends State<FoodSheet> {
  int count = 1;
  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D3CB),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(21),
            child: Image.asset(
              widget.food.image,
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * .27,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: yellow,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              widget.food.tag,
              style: const TextStyle(
                color: ink,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            widget.food.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 5),
          Text(
            widget.food.description,
            style: const TextStyle(color: muted, fontSize: 14),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Text(
                cash(widget.food.price),
                style: const TextStyle(
                  color: red,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              IconButton.outlined(
                onPressed: count > 1 ? () => setState(() => count--) : null,
                icon: const Icon(Icons.remove, size: 18),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton.outlined(
                onPressed: () => setState(() => count++),
                icon: const Icon(Icons.add, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onAdd(widget.food, count);
              },
              style: FilledButton.styleFrom(
                backgroundColor: red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Add to bag  •  ${cash(widget.food.price * count)}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
