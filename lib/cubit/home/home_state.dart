part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<String> categories;
  final List<ProductModel> products;

  HomeLoaded({required this.categories, required this.products});

  @override
  List<Object> get props => [categories, products];
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object> get props => [message];
}
