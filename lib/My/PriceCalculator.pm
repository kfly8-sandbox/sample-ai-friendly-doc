use v5.40;

package My::PriceCalculator;

use Exporter 'import';

our @EXPORT_OK = qw(
    total_discount_percentage
    selling_price
);

use List::Util qw(min);

# 割引率の上限
use constant MAX_DISCOUNT_PERCENTAGE => 80;

# 販売価格を計算する
sub selling_price($sale_product, $user, $discount) {
    my $total_discount_percentage = total_discount_percentage($user, $discount);
    return floor($sale_product->price * (100 - $total_discount_percentage) / 100)
}

# 適用される割引率を計算する
sub total_discount_percentage($user, $discount) {
    my $percentage = 0;
    if ($user->is_premium) {
        $percentage += 10
    }
    if ($discount->percentage > 0) {
        $percentage += $discount->percentage;
    }
    return min($percentage, MAX_DISCOUNT_PERCENTAGE)
}
