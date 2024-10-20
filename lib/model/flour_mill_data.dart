// lib/data/flour_mill_data.dart
import 'package:flour_mill/model/flour_mills.dart';

class FlourMillData {
  static List<FlourMill> getFlourMills() {
    return [
      FlourMill(
        imageUrl: "lib/assets/mills/mill1.png",
        deliveryInfo: '20 mins • 1 km',
        tag: 'NEAR & FAST',
        name: 'Delhi Flour Mill',
        rating: 4.6,
        type: 'Flour • Grains',
      ),
      FlourMill(
        imageUrl: "lib/assets/mills/mill2.jpeg",
        deliveryInfo: '25 mins • 2 km',
        tag: 'ON TIME DELIVERY',
        name: 'Dinesh Flour Mill',
        rating: 4.5 ,
        type: 'Flour • Grains',
      ),
      FlourMill(
        imageUrl: "lib/assets/mills/mill3.jpeg",
        deliveryInfo: '35 mins • 4 km',
        tag: 'ON TIME DELIVERY',
        name: 'Virmani Flour Mill',
        rating: 4.2,
        type: 'Flour • Grains',
      ),
      // Add more flour mills as needed
    ];
  }
}
