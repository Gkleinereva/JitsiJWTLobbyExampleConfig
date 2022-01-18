plugin_paths = { "/usr/share/jitsi-meet/prosody-plugins/" }

asap_accepted_issuers = { "*" }
asap_accepted_audiences = { "*" }

-- domain mapper options, must at least have domain base set to use the mapper
muc_mapper_domain_base = "meet.example.com";

external_service_secret = "tAOpmLS1YG9pf8Ly";
external_services = {
     { type = "stun", host = "meet.example.com", port = 3478 },
     { type = "turn", host = "meet.example.com", port = 3478, transport = "udp", secret = true, ttl = 86400, algorithm = "turn" },
     { type = "turns", host = "meet.example.com", port = 5349, transport = "tcp", secret = true, ttl = 86400, algorithm = "turn" }
};

cross_domain_bosh = false;
consider_bosh_secure = true;
-- https_ports = { }; -- Remove this line to prevent listening on port 5284

-- https://ssl-config.mozilla.org/#server=haproxy&version=2.1&config=intermediate&openssl=1.1.0g&guideline=5.4
ssl = {
    protocol = "tlsv1_2+";
    ciphers = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384"
}

unlimited_jids = {
    "focus@auth.meet.example.com",
    "jvb@auth.meet.example.com"
}

VirtualHost "meet.example.com"
    -- enabled = false -- Remove this line to enable this host
    authentication = "token"
    -- Properties below are modified by jitsi-meet-tokens package config
    -- and authentication above is switched to "token"
    app_id = "appName"
    app_secret = "<appSecret>"
    allow_empty_token = false
    -- Assign this host a certificate for TLS, otherwise it would use the one
    -- set in the global section (if any).
    -- Note that old-style SSL on port 5223 only supports one certificate, and will always
    -- use the global one.
    ssl = {
        key = "/etc/prosody/certs/meet.example.com.key";
        certificate = "/etc/prosody/certs/meet.example.com.crt";
    }
    av_moderation_component = "avmoderation.meet.example.com"
    speakerstats_component = "speakerstats.meet.example.com"
    conference_duration_component = "conferenceduration.meet.example.com"
    -- we need bosh
    modules_enabled = {
        "bosh";
        "pubsub";
        "ping"; -- Enable mod_ping
        "speakerstats";
        "external_services";
        "conference_duration";
        "muc_lobby_rooms";
        "muc_breakout_rooms";
        "av_moderation";
	    "presence_identity";
    }
    c2s_require_encryption = false
    lobby_muc = "lobby.meet.example.com"
    breakout_rooms_muc = "breakout.meet.example.com"
    main_muc = "conference.meet.example.com"
    -- muc_lobby_whitelist = { "recorder.meet.example.com" } -- Here we can whitelist jibri to enter lobby enabled rooms

--VirtualHost "guest.meet.example.com"
   -- authentication = "token"
   -- c2s_require_encryption = false

Component "conference.meet.example.com" "muc"
    restrict_room_creation = true
    storage = "memory"
    modules_enabled = {
        "muc_meeting_id";
        "muc_domain_mapper";
        "polls";
        "token_verification";
	    "token_affiliation";
        "muc_rate_limit";
    }
    admins = { "focus@auth.meet.example.com" }
    muc_room_locking = false
    muc_room_default_public_jids = true

Component "breakout.meet.example.com" "muc"
    restrict_room_creation = true
    storage = "memory"
    modules_enabled = {
        "muc_meeting_id";
        "muc_domain_mapper";
        "token_verification";
        "muc_rate_limit";
    }
    admins = { "focus@auth.meet.example.com" }
    muc_room_locking = false
    muc_room_default_public_jids = true

-- internal muc component
Component "internal.auth.meet.example.com" "muc"
    storage = "memory"
    modules_enabled = {
        "ping";
    }
    admins = { "focus@auth.meet.example.com", "jvb@auth.meet.example.com" }
    muc_room_locking = false
    muc_room_default_public_jids = true

VirtualHost "auth.meet.example.com"
    ssl = {
        key = "/etc/prosody/certs/auth.meet.example.com.key";
        certificate = "/etc/prosody/certs/auth.meet.example.com.crt";
    }
    modules_enabled = {
        "limits_exception";
    }
    authentication = "internal_hashed"

-- Proxy to jicofo's user JID, so that it doesn't have to register as a component.
Component "focus.meet.example.com" "client_proxy"
    target_address = "focus@auth.meet.example.com"

Component "speakerstats.meet.example.com" "speakerstats_component"
    muc_component = "conference.meet.example.com"

Component "conferenceduration.meet.example.com" "conference_duration_component"
    muc_component = "conference.meet.example.com"

Component "avmoderation.meet.example.com" "av_moderation_component"
    muc_component = "conference.meet.example.com"

Component "lobby.meet.example.com" "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true
    modules_enabled = {
        "muc_rate_limit";
    }
