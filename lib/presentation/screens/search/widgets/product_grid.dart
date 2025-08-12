// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../../../../data/models/product_model.dart';
// import '../../product_details/product_details_screen.dart';
//
// class ProductsGrid extends StatelessWidget {
//   final List<ProductModel> products;
//
//   const ProductsGrid({super.key, required this.products});
//
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       padding: EdgeInsets.zero,
//       itemCount: products.length,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 0.65,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//       ),
//       itemBuilder: (ctx, i) {
//         final p = products[i];
//         return GestureDetector(
//           onTap: () => Navigator.push(
//             ctx,
//             MaterialPageRoute(
//               builder: (_) => ProductDetailsScreen(product: p),
//             ),
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 4,
//                   offset: Offset(2, 2),
//                 )
//               ],
//             ),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: CachedNetworkImage(
//                     imageUrl: p.productFile,
//                     placeholder: (_, __) =>
//                     const CircularProgressIndicator(strokeWidth: 2),
//                     errorWidget: (_, __, ___) => const Icon(Icons.error),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(p.name,
//                     maxLines: 1, overflow: TextOverflow.ellipsis),
//                 Text('\$${p.price}',
//                     style: const TextStyle(color: Colors.teal)),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
