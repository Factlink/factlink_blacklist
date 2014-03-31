require "factlink_blacklist/version"

class FactlinkBlacklist
  def self.domain domain
    host_regex "([^/]*\\.)?" + domain.gsub(/\./, '\\\.')
  end

  def self.strict_domain domain
    host_regex domain.gsub(/\./, '\\\.')
  end

  def self.host_regex host_regex
    "https?://#{host_regex}([:/].*)?"
  end

  def self.default
    @@default ||= new [ domain('fct.li'), ] +
                          localhost + 
                          privacy + 
                          flash + 
                          frames + 
                          paywall +
                          browserpages +
                          content_security_policy
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

  def self.localhost
    [
        strict_domain('localhost'),
        strict_domain('127.0.0.1'),
        strict_domain('::1'),
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
    "about:.*"
    ]
  end

  def initialize(blacklist)
    @regex_string = '^(' + blacklist.join('|') + ')$'
    # we can't use Regexp.union because our regex needs to be JS-compatible and Regexp.union includes ruby-isms
    # Similarly, \A isn't allowed
    @regex = Regexp.new @regex_string
  end

  def matches?(str)
    !@regex.match(str).nil?
  end
  
  def to_s
    @regex_string
  end
end
