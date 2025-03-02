use v5.40;
use Test2::V0;
use utf8;

use My::PriceCalculator qw(selling_price total_discount_percentage);

use My::User ();
use My::Discount ();
use My::SaleProduct ();
use My::Coupon ();

subtest '販売価格 / selling_price' => sub {
    my $normal_user = My::User->new( id => 1, is_premium => 0 );
    my $premium_user = My::User->new( id => 2, is_premium => 1 );

    my sub subject(@args) {
        my ($result, $err) = selling_price(@args);
        return [ $result, $err ];
    }

    subtest '2. 販売価格の計算' => sub {
        my $sale_product = My::SaleProduct->new( id => 1, price => 1000 );

        my $no_discount = My::Discount->new( percentage => 0 );
        my $ten_discount = My::Discount->new( percentage => 10 );
        my $ten_coupon = My::Coupon->new( id => 1, percentage => 10 );
        my $twenty_coupon = My::Coupon->new( id => 2, percentage => 20 );

        is subject($sale_product, $normal_user, $no_discount), [1000, U],  'TC001: normal user, no discount';
        is subject($sale_product, $normal_user, $ten_discount), [900, U],  'TC002: normal user, 10% discount';
        is subject($sale_product, $premium_user, $no_discount), [900, U],  'TC003: premium user, no discount';
        is subject($sale_product, $premium_user, $ten_discount), [800, U], 'TC004: premium user, 10% discount';
        is subject($sale_product, $normal_user, $no_discount, $ten_coupon), [900, U], 'TC005: normal user, no discount, 10% coupon';
        is subject($sale_product, $premium_user, $no_discount, $twenty_coupon), [700,U], 'TC006: premium user, no discount, 20% coupon';
    };

    subtest '3. 注意事項' => sub {
        subtest '3.1 割引率の上限 / TC101' => sub {
            my $sale_product = My::SaleProduct->new( id => 1, price => 1000 );

            is subject($sale_product, $normal_user, My::Discount->new( percentage => 80 )), [200, U], 'just 80% discount';
            is subject($sale_product, $normal_user, My::Discount->new( percentage => 81 )), [200, U], '81% discount';
        };

        subtest '3.2 販売価格の端数 / TC201 販売価格の端数は切り捨てする' => sub {
            my $sale_product = My::SaleProduct->new(id => 2, price => 90);
            my $discount = My::Discount->new( percentage => 25);
            is subject($sale_product, $normal_user, $discount), [67, U];
        };

        subtest '3.3 セール商品とクーポン券の併用 / TC301' => sub {
            my $sale_product = My::SaleProduct->new( id => 1, price => 100 );
            my $ten_discount = My::Discount->new( percentage => 10 );
            my $twenty_coupon = My::Coupon->new( id => 2, percentage => 20 );

            my ($price, $err) = selling_price($sale_product, $normal_user, $ten_discount, $twenty_coupon);
            is $price, U, 'price should be undefined';
            is $err, match qr/クーポンとセール商品は併用できません/, 'error message should indicate incompatibility';
        };
    };
};

subtest '割引率 / total_discount_percentage' => sub {
    my $normal_user = My::User->new( id => 1, is_premium => 0 );
    my $premium_user = My::User->new( id => 2, is_premium => 1 );

    my sub subject(@args) {
        my ($result, $err) = total_discount_percentage(@args);
        return [ $result, $err ];
    }

    subtest '適用される割引率の計算' => sub {
        my $no_discount = My::Discount->new( percentage => 0 );
        my $ten_discount = My::Discount->new( percentage => 10 );

        is subject($normal_user, $no_discount), [0, U], 'TC01: normal user, no discount';
        is subject($normal_user, $ten_discount), [10, U], 'TC02: normal user, 10% discount';
        is subject($premium_user, $no_discount), [10, U], 'TC03: premium user, no discount';
        is subject($premium_user, $ten_discount), [20, U], 'TC04: premium user, 10% discount';
    };

    subtest 'TC101 割引率の上限' => sub {
        is subject($normal_user, My::Discount->new( percentage => 80 )), [80, U], 'just 80% discount';
        is subject($normal_user, My::Discount->new( percentage => 81 )), [80, U], '81% discount';
    };

    subtest 'tC301 セール商品とクーポン券の併用' => sub {
        my $ten_discount = My::Discount->new( percentage => 10 );
        my $twenty_coupon = My::Coupon->new( id => 2, percentage => 20 );

        my ($discount, $err) = total_discount_percentage($normal_user, $ten_discount, $twenty_coupon);
        is $discount, U, 'discount should be undefined';
        is $err, match qr/クーポンとセール商品は併用できません/, 'error message should indicate incompatibility';
    };
};

done_testing;
