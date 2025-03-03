{ lib
, ...
}: {
   environment.etc = {
    # Define an action that will trigger a Ntfy push notification upon the issue of every new ban
    "fail2ban/action.d/ntfy.local".text = lib.mkDefault (lib.mkAfter ''
      [Definition]
      norestored = true # Needed to avoid receiving a new notification after every restart
      actionban = curl -H "Title: <ip> has been banned" -d "<name> jail has banned <ip> from accessing $(hostname) after <failures> attempts of hacking the system." https://ntfy.leftrmodule.com/Fail2banNotifications
    '');
    # Defines a filter that detects URL probing by reading the Nginx access log
    "fail2ban/filter.d/nginx-url-probe.local".text = lib.mkDefault (lib.mkAfter ''
      [Definition]
      failregex = ^<HOST>.*(GET /(wp-|admin|boaform|phpmyadmin|\.env|\.git)|\.(dll|so|cfm|asp)|(\?|&)(=PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000|=PHPE9568F36-D428-11d2-A769-00AA001ACF42|=PHPE9568F35-D428-11d2-A769-00AA001ACF42|=PHPE9568F34-D428-11d2-A769-00AA001ACF42)|\\x[0-9a-zA-Z]{2})
    '');
  };
  services.fail2ban = {
    enable = true;
    jails = {
      ngnix-url-probe.settings = { 
        enabled = true;
        filter = "nginx-url-probe";
        logpath = "/var/log/nginx/access.log";
        action = ''%(action_)s[blocktype=DROP]
                 ntfy'';
        backend = "auto";
        maxretry = 5; 
        findtime = 600;
      }; 
    };
  };
}
