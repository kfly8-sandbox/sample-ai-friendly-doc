use v5.40;

package My::PriceCalculator;

use Exporter 'import';

our @EXPORT_OK = qw(
    total_discount_rate
    selling_price
);

sub total_discount_rate($user, $discount) {
    my $rate = 0.0;
    if ($user->is_premium) {
        $rate += 0.10
    }
    if ($discount->rate > 0) {
        $rate += $discount->rate;
    }
    return $rate;
}

sub selling_price($sale_product, $user, $discount=undef) {
    my $total_discount_rate = total_discount_rate($user, $discount);
    return floor( $sale_product->price * (1 - $total_discount_rate) );
}
