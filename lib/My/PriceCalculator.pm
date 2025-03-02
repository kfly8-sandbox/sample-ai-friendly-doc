use v5.40;

package My::PriceCalculator;

use Exporter 'import';

our @EXPORT_OK = qw(
    total_discount_percentage
    selling_price
);

use List::Util qw(min);
use Result::Simple qw(Ok Err);

# 割引率の上限
use constant MAX_DISCOUNT_PERCENTAGE => 80;

# 販売価格を計算する
sub selling_price($sale_product, $user, $discount, $coupon) {
    my ($total_discount_percentage, $err) = total_discount_percentage($user, $discount);
    return Err($err) if $err;
    return Ok(floor($sale_product->price * (100 - $total_discount_percentage) / 100))
}

# 適用される割引率を計算する
sub total_discount_percentage($user, $discount, $coupon) {
    my $percentage = 0;
    if ($user->is_premium) {
        $percentage += 10
    }
    if ($discount->percentage > 0) {
        $percentage += $discount->percentage;
    }
    # TODO: クーポンの割引率を加算する
    # TODO: クーポンと$discountの併用を使用としていた場合は、Err('クーポンと割引は併用できません')を返す
    return Ok(min($percentage, MAX_DISCOUNT_PERCENTAGE));
}
