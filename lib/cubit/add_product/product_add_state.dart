// lib/cubit/product_add/product_add_state.dart
import 'package:equatable/equatable.dart';

abstract class ProductAddState extends Equatable {
  const ProductAddState();

  @override
  List<Object?> get props => [];
}

class ProductAddInitial extends ProductAddState {}
class ProductAddLoading extends ProductAddState {}
class ProductAddSuccess extends ProductAddState {}
class ProductAddFailure extends ProductAddState {
  final String error;
  const ProductAddFailure(this.error);

  @override
  List<Object?> get props => [error];
}