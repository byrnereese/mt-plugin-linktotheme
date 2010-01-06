package LinkToThemeFile::Plugin;

use strict;

sub itemset_handler {
    my ($app,$link) = @_;
    $app->validate_magic or return;
    my @ids = $app->param('id');
    for my $tmpl_id (@ids) {
        my $tmpl = MT->model('template')->load($tmpl_id) or next;
        MT->log({
            blog_id => $tmpl->blog_id,
            message => ($link eq '*' ? "Linking" : "Unlinking") . " " . $tmpl->name . " to theme file."
                });
        $tmpl->linked_file($link);
        $tmpl->save();
    }
    $app->add_return_arg( link_changed => 1 );
    $app->call_return;
}

sub itemset_link { 
    return itemset_handler(@_, '*'); 
}
sub itemset_unlink { 
    return itemset_handler(@_, ''); 
}

1;
