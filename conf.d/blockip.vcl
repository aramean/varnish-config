acl forbiddenip {
    "192.168.168.0"/24;
    "10.10.10.0"/24;
}

sub blockip {
    if (client.ip ~ forbiddenip) {
        return(synth(401, "Blocked IP"));
    }
}