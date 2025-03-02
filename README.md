# 概要

商品の販売価格を計算するプロジェクト

# ファイル構成

```shell
❯ tree
.
├── doc
│   └── PriceCaluculator.md         # 販売価格計算の仕様書
├── lib
│   └── My
│       ├── Discount.pm             # 割引情報のクラス
│       ├── PriceCalculator.pm      # 販売価格計算の純粋関数
│       ├── SaleProduct.pm          # 商品情報のクラス
│       └── User.pm                 # ユーザ情報のクラス
└── t
    └── PriceCaluculator.t          # 販売計算のテスト
```
