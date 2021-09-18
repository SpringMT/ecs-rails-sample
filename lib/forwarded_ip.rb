class ForwardedIp
  class << self
    # @param forwarded_ip_string [String] HTTP_X_FORWARDED_FORの値
    # @return [String] HTTP_X_FORWARDED_FORの左端のIPアドレス
    def forwarded_ip(forwarded_ip_string)
      forwarded_ips = split_ip_addresses(forwarded_ip_string)
      reject_trusted_ip_addresses(forwarded_ips).first
    end

    def split_ip_addresses(ip_addresses)
      ip_addresses ? ip_addresses.strip.split(/[,\s]+/) : []
    end

    def reject_trusted_ip_addresses(ip_addresses)
      ip_addresses.reject {|ip| trusted_proxy?(ip) }
    end

    # https://github.com/rack/rack/blob/2e92a25342b5d51f4094366c3b8dd797cbd208a4/lib/rack/request.rb#L419
    def trusted_proxy?(ip)
      ip =~ /\A127\.0\.0\.1\Z|\A(10|172\.(1[6-9]|2[0-9]|30|31)|192\.168)\.|\A::1\Z|\Afd[0-9a-f]{2}:.+|\Alocalhost\Z|\Aunix\Z|\Aunix:/i
    end
  end
end
