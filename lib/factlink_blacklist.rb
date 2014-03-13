require "factlink_blacklist/version"

class FactlinkBlacklist
  def self.domain domain
    regexdomain = domain.gsub(/\./, '\\\.')
    r = "https?:\\\/\\\/([^/]*\\\.)?#{regexdomain}\\\/?"
    Regexp.new r
  end

  def self.strict_domain domain
    regexdomain = domain.gsub(/\./, '\\\.')
    r = "https?:\\\/\\\/#{regexdomain}\\\/?"
    Regexp.new r
  end

  def self.default
    @@default ||= new [
      domain('fct.li'),
      /^http:\/\/localhost[:\/]/,
    ] + privacy + flash + frames + paywall + browserpages + content_security_policy
  end

  def self.privacy
    [
      domain('icloud.com'),
      domain('twitter.com'),
      domain('gmail.com'),
      domain('irccloud.com'),
      domain('flowdock.com'),
      domain('yammer.com'),
      domain('moneybird.nl'),
      domain('newrelic.com'),
      domain('mixpanel.com'),
      domain('facebook.com'),
      domain('mail.google.com'),
      domain('dropbox.com'),
    ]
  end

  def self.flash
    [
      domain('kiprecepten.nl'),
      domain('grooveshark.com'),
    ]
  end

  def self.frames
    [
      domain('insiteproject.com'),
    ]
  end

  def self.paywall
    [
      domain('fd.nl'),
    ]
  end

  def self.content_security_policy
    [
      domain('github.com'),
      domain('hackerone.com'),
    ]
  end

  def self.browserpages
    [
    /\Aabout:.*/
    ]
  end

  def initialize(blacklist)
    @blacklist = blacklist
  end

  def matches?(str)
    @blacklist.each do |regex|
      return true if regex.match(str)
    end

    false
  end
end