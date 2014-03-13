require_relative '../lib/factlink_blacklist.rb'
describe FactlinkBlacklist do
  subject do
    FactlinkBlacklist.new([
      /^http(s)?:\/\/([^\/]+\.)?facebook\.com/,
      /^http(s)?:\/\/([^\/]+\.)?factlink\.com/,
      /^http(s)?:\/\/([^\/]+\.)?twitter\.com/,
    ])
  end

  describe "#should_return_true_on_match" do
    it { expect(subject.matches?('http://facebook.com')).to be_truthy }
  end

  describe "#should_return_false_when_no_match" do
    it { expect(subject.matches?('http://google.com')).to be_falsey }
  end

  describe "#should_also_match_non-first_blacklist_item" do
    it { expect(subject.matches?('http://twitter.com')).to be_truthy }
    it { expect(subject.matches?('http://factlink.com')).to be_truthy }
  end

  describe "#should_also_match_subdomains" do
    it { expect(subject.matches?('http://static.demo.factlink.com')).to be_truthy }
    it { expect(subject.matches?('http://demo.factlink.com')).to be_truthy }
  end

  describe ".domain" do
    let(:regex) { FactlinkBlacklist.domain('foo.com') }

    it "should match the domain" do
      expect(regex.match('http://foo.com')).to be_truthy
      expect(regex.match('http://foo.com/')).to be_truthy
      expect(regex.match('https://foo.com/')).to be_truthy
      expect(regex.match('https://fooacom/')).to be_falsey
    end

    it "should match subdomains" do
      expect(regex.match('http://bar.foo.com')).to be_truthy
      expect(regex.match('http://bar.foo.com/')).to be_truthy
      expect(regex.match('http://barfoo.com/')).to be_falsey
      expect(regex.match('http://bar.com/arg.foo.com/')).to be_falsey
    end
  end

  describe ".strict_domain" do
    let(:regex) { FactlinkBlacklist.strict_domain('foo.com') }

    it "should match the domain" do
      expect(regex.match('http://foo.com')).to be_truthy
      expect(regex.match('http://foo.com/')).to be_truthy
      expect(regex.match('https://foo.com/')).to be_truthy
      expect(regex.match('https://fooacom/')).to be_falsey
    end
    it "should not match subdomains" do
      expect(regex.match('http://bar.foo.com')).to be_falsey
      expect(regex.match('http://bar.foo.com/')).to be_falsey
    end
  end

  describe ".default" do
    let(:defaultlist) { FactlinkBlacklist.default }
    it "should not match blog.factlink.com" do
      expect(defaultlist.matches?('https://blog.factlink.com/')).to be_falsey
    end
    it "should match facebook.com" do
      expect(defaultlist.matches?('https://facebook.com/')).to be_truthy
    end
  end

end
