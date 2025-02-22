use v5.40;
use experimental 'class';

class My::User {
    field $id :param :reader;
    field $is_premium :param :reader;
}
