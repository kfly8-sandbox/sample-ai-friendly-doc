use Test2::V0;

use My::PriceCalculator qw(
    total_discount_rate
    selling_price
);

use My::User;
use My::Discount;
use My::SaleProduct;

subtest 'total_discount_rate' => sub {
    my $normal_user = My::User->new( id => 1, is_premium => 0 );
    my $premium_user = My::User->new( id => 2, is_premium => 1 );

    my $no_discount = My::Discount->new( rate => 0.0 );
    my $ten_discount = My::Discount->new( rate => 0.10 );

    is total_discount_rate($normal_user, $no_discount), 0.0, 'TC01: normal user, no discount';
    is total_discount_rate($normal_user, $ten_discount), 0.10, 'TC02: normal user, 10% discount';
    is total_discount_rate($premium_user, $no_discount), 0.10, 'TC03: premium user, no discount';
    is total_discount_rate($premium_user, $ten_discount), 0.20, 'TC04: premium user, 10% discount';
};

subtest 'selling_price' => sub {
    my $sale_product = My::SaleProduct->new( id => 1, price => 1000 );

    my $normal_user = My::User->new( id => 1, is_premium => 0 );
    my $premium_user = My::User->new( id => 2, is_premium => 1 );

    my $no_discount = My::Discount->new( rate => 0.0 );
    my $ten_discount = My::Discount->new( rate => 0.10 );

    is selling_price($sale_product, $normal_user, $no_discount), 1000, 'TC01: normal user, no discount';
    is selling_price($sale_product, $normal_user, $ten_discount), 900, 'TC02: normal user, 10% discount';
    is selling_price($sale_product, $premium_user, $no_discount), 900, 'TC03: premium user, no discount';
    is selling_price($sale_product, $premium_user, $ten_discount), 800, 'TC04: premium user, 10% discount';
};

done_testing;
