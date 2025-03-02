use v5.40;
use utf8;

package My::PriceCalculator;

use Exporter 'import';

our @EXPORT_OK = qw(
    total_discount_percentage
    selling_price
);

use List::Util qw(min);
use POSIX qw(round floor);
use Result::Simple qw(Ok Err);

# 割引率の上限
use constant MAX_DISCOUNT_PERCENTAGE => 80;

# エラーメッセージ
use constant ERROR_COUPON_AND_SALE => 'クーポンとセール商品は併用できません';

# 販売価格を計算する
sub selling_price($sale_product, $user, $discount, $coupon = undef) {
    my ($total_discount_percentage, $err) = total_discount_percentage($user, $discount, $coupon);
    return Err($err) if $err;
    return Ok(floor($sale_product->price * (100 - $total_discount_percentage) / 100))
}

# 適用される割引率を計算する
sub total_discount_percentage($user, $discount, $coupon = undef) {
    my $percentage = 0;

    # プレミアム会員は10%オフ
    if ($user->is_premium) {
        $percentage += 10;
    }

    # クーポンとセール割引の併用チェック
    if (defined $coupon && $discount->percentage > 0) {
        return Err(ERROR_COUPON_AND_SALE);
    }

    # セール割引の適用
    if ($discount->percentage > 0) {
        $percentage += $discount->percentage;
    }

    # クーポンの割引率を適用
    if (defined $coupon) {
        $percentage += $coupon->percentage;
    }

    # 割引率の上限を適用
    $percentage = min($percentage, MAX_DISCOUNT_PERCENTAGE);

    # 四捨五入
    return Ok(round($percentage));
}
