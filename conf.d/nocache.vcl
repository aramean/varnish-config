sub nocache {
  # Do not cache these paths.
  if (req.url ~ "^/status\.php$" ||
        req.url ~ "^/update\.php" ||
        req.url ~ "^/install\.php" ||
        req.url ~ "^/apc\.php$" ||
        req.url ~ "^/wp-json" ||
        req.url ~ "^/wp-json/.*$" ||
        req.url ~ "^/admin" ||
        req.url ~ "^/admin/.*$" ||
        req.url ~ "^/wp-admin" ||
        req.url ~ "^/wp-admin/.*$" ||
        req.url ~ "^/wp-login" ||
        req.url ~ "^/wp-login/.*$" ||
        req.url ~ "^/wp-content/plugins/elementor/.*$" ||
        req.url ~ "^/user" ||
        req.url ~ "^/user/.*$" ||
        req.url ~ "^/users/.*$" ||
        req.url ~ "^/info/.*$" ||
        req.url ~ "^/flag/.*$" ||
        req.url ~ "^/feed" ||
        req.url ~ "^.*/ajax/.*$" ||
        req.url ~ "^.*/ahah/.*$" ||
        req.url ~ "^/system/files/.*$") {

        return (pass);
    }
}
