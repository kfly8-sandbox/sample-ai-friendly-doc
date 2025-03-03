## プロジェクトの構成

```shell
.
├── doc # ドキュメント
│   └── PriceCaluculator.md # 販売計算の仕様
├── lib
│   └── My
│       ├── Discount.pm # 割引のValue Object
│       ├── PriceCalculator.pm # 販売計算のService / 純粋関数で定義する
│       ├── SaleProduct.pm # 販売商品のEntity
│       └── User.pm # ユーザーのEntity
└── t # テスト
    └── PriceCaluculator.t # 販売計算のテスト
```
