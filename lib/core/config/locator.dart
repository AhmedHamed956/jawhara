import 'package:get_it/get_it.dart';
import 'package:jawhara/viewModel/cart_view_model.dart';
import 'package:jawhara/viewModel/home_view_model.dart';
import 'package:jawhara/viewModel/navigation_bar_view_model.dart';
import 'package:jawhara/viewModel/points_view_model.dart';
import 'package:jawhara/viewModel/products_view_model.dart';
import 'package:jawhara/viewModel/search_view_model.dart';
import 'package:jawhara/viewModel/shipping_address_view_model.dart';
import 'package:jawhara/viewModel/wallet_view_model.dart';
import 'package:jawhara/viewModel/wishList_view_model.dart';
import 'package:stacked_services/stacked_services.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<HomeViewModel>(HomeViewModel());
  locator.registerSingleton<ProductsViewModel>(ProductsViewModel());
  locator.registerSingleton<CartViewModel>(CartViewModel());
  locator.registerSingleton<ShippingAddressViewModel>(ShippingAddressViewModel());
  locator.registerSingleton<WalletViewModel>(WalletViewModel());
  locator.registerSingleton<PointsViewModel>(PointsViewModel());
  locator.registerSingleton<WishListViewModel>(WishListViewModel());
  locator.registerSingleton<SearchViewModel>(SearchViewModel());
  locator.registerSingleton<NavigationBarViewModel>(NavigationBarViewModel());
  locator.registerLazySingleton(() => NavigationService());
}
