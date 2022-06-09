import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MultipleCategorySelection()));
}

final categoryListProvider =
    StateNotifierProvider((_) => createCategoryList(["a", "b"]));

final selectedCategories = Provider((ref) => ref
    .watch(categoryListProvider)
    .entries
    .where((MapEntry<String, bool> category) => category.value)
    .map((e) => e.key)
    .toList());

final allCategories =
    Provider((ref) => ref.watch(categoryListProvider).keys.toList());

CategoryList createCategoryList(List<String> values) {
  final Map<String, bool> categories = Map();
  values.forEach((value) {
    categories.putIfAbsent(value, () => false);
  });
  return CategoryList(categories);
}

class CategoryList extends StateNotifier<Map<String, bool>> {
  CategoryList(Map<String, bool> state) : super(state);

  void toggle(String item) {
    final currentValue = state[item];
    if (currentValue != null) {
      state[item] = !currentValue;
      state = state;
    }
  }
}

class MultipleCategorySelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Interactive categories")),
        body: Column(
          children: [
            CategoryFilter(),
            //? Linea Verde separador
            Container(
              color: Colors.green,
              height: 2,
            ),
            SelectedCategories()
          ],
        ),
      ),
    );
  }
}

class CategoryFilter extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! La lista completa
    final categoryList = ref.watch(allCategories);
    //! La lista de seleccionados
    final selectedCategoryList = ref.watch(selectedCategories);
    //! Me sirve para poder usar una funcion dentro del StateNotifier
    final provider = ref.watch(categoryListProvider.notifier);

    return Flexible(
      //! Muestra la lista funcionando
      child: ListView.builder(
          itemCount: categoryList.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              value: selectedCategoryList.contains(categoryList[index]),
              onChanged: (bool? selected) {
                provider.toggle(categoryList[index]);
              },
              title: Text(categoryList[index]),
            );
          }),
      //! Solamente muestra la lista sin opcion de seleccionar!
      // ListView.builder(
      //     itemCount: categoryList.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       return Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Text(categoryList[index]),
      //       );
      //     }),
    );
  }
}

class SelectedCategories extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryList = ref.watch(selectedCategories);

    return Flexible(
      child: ListView.builder(
          itemCount: categoryList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(categoryList[index]),
            );
          }),
    );
  }
}
