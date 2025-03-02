use v5.40;
use experimental 'class';

class My::Coupon {
    field $id :param :reader;
    field $percentage :param :reader;
}
