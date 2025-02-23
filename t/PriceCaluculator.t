use Test2::V0;

use My::PriceCalculator qw(
    total_discount_percentage
    selling_price
);

use My::User;
use My::Discount;
use My::SaleProduct;

subtest '販売価格 / selling_price' => sub {
    my $normal_user = My::User->new( id => 1, is_premium => 0 );
    my $premium_user = My::User->new( id => 2, is_premium => 1 );

    subtest '2. 販売価格の計算' => sub {
        my $sale_product = My::SaleProduct->new( id => 1, price => 1000 );

        my $no_discount = My::Discount->new( percentage => 0 );
        my $ten_discount = My::Discount->new( percentage => 10 );

        is selling_price($sale_product, $normal_user, $no_discount), 1000,  'TC001: normal user, no discount';
        is selling_price($sale_product, $normal_user, $ten_discount), 900,  'TC002: normal user, 10% discount';
        is selling_price($sale_product, $premium_user, $no_discount), 900,  'TC003: premium user, no discount';
        is selling_price($sale_product, $premium_user, $ten_discount), 800, 'TC004: premium user, 10% discount';
    };

    subtest '3. 注意事項' => sub {
        subtest '3.1 割引率の上限 / TC101' => sub {
            my $sale_product = My::SaleProduct->new( id => 1, price => 1000 );

            is selling_price($sale_product, $normal_user, My::Discount->new( percentage => 80 )), 200, 'just 80% discount';
            is selling_price($sale_product, $normal_user, My::Discount->new( percentage => 81 )), 200, '81% discount';
        };

        subtest '3.2 販売価格の端数 / TC201 販売価格の端数は切り捨てする' => sub {
            my $sale_product = My::SaleProduct->new(id => 2, price => 90);
            my $discount = My::Discount->new( percentage => 25);
            is selling_price($sale_product, $normal_user, $discount), 67;
        };
    };
};

subtest '割引率 / total_discount_percentage' => sub {
    my $normal_user = My::User->new( id => 1, is_premium => 0 );
    my $premium_user = My::User->new( id => 2, is_premium => 1 );

    subtest '適用される割引率の計算' => sub {
        my $no_discount = My::Discount->new( percentage => 0 );
        my $ten_discount = My::Discount->new( percentage => 10 );

        is total_discount_percentage($normal_user, $no_discount), 0, 'TC01: normal user, no discount';
        is total_discount_percentage($normal_user, $ten_discount), 10, 'TC02: normal user, 10% discount';
        is total_discount_percentage($premium_user, $no_discount), 10, 'TC03: premium user, no discount';
        is total_discount_percentage($premium_user, $ten_discount), 20, 'TC04: premium user, 10% discount';
    };

    subtest 'TC101 割引率の上限' => sub {
        is total_discount_percentage($normal_user, My::Discount->new( percentage => 80 )), 80, 'just 80% discount';
        is total_discount_percentage($normal_user, My::Discount->new( percentage => 81 )), 80, '81% discount';
    };
};

done_testing;
