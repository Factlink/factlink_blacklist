require_relative '../lib/factlink_blacklist.rb'
describe FactlinkBlacklist do
  subject do
    FactlinkBlacklist.default
  end

  describe "#should_return_true_on_match" do
    it { expect(subject.matches?('http://facebook.com/')).to be_truthy }
    it { expect(subject.matches?('http://facebook.com')).to be_truthy }
  end

  describe "#should_return_false_when_no_match" do
    it { expect(subject.matches?('http://google.com')).to be_falsey }
    it { expect(subject.matches?(' http://facebook.com')).to be_falsey }
  end

  describe "#should_also_match_non-first_blacklist_item" do
    it { expect(subject.matches?('http://twitter.com')).to be_truthy }
    it { expect(subject.matches?('http://dropbox.com')).to be_truthy }
  end

  describe "#should_also_match_subdomains" do
    it { expect(subject.matches?('http://static.demo.dropbox.com')).to be_truthy }
    it { expect(subject.matches?('http://demo.dropbox.com')).to be_truthy }
  end

  describe ".domain" do
    let(:regex) { FactlinkBlacklist.new [ FactlinkBlacklist.domain('foo.com') ] }

    it "should match the domain" do
      expect(regex.matches?('http://foo.com')).to be_truthy
      expect(regex.matches?('http://foo.com/')).to be_truthy
      expect(regex.matches?('https://foo.com/')).to be_truthy
      expect(regex.matches?('https://fooacom/')).to be_falsey
    end

    it "should match subdomains" do
      expect(regex.matches?('http://bar.foo.com')).to be_truthy
      expect(regex.matches?('http://bar.foo.com/')).to be_truthy
      expect(regex.matches?('http://barfoo.com/')).to be_falsey
      expect(regex.matches?('http://bar.com/arg.foo.com/')).to be_falsey
    end
  end

  describe ".strict_domain" do
    let(:regex) { FactlinkBlacklist.new [ FactlinkBlacklist.strict_domain('foo.com') ]}

    it "should match the domain" do
      expect(regex.matches?('http://foo.com')).to be_truthy
      expect(regex.matches?('http://foo.com:80')).to be_truthy
      expect(regex.matches?('http://foo.com:80/')).to be_truthy
      expect(regex.matches?('http://foo.com/')).to be_truthy
      expect(regex.matches?('https://foo.com/')).to be_truthy
      expect(regex.matches?('https://fooacom/')).to be_falsey
    end
    it "should not match subdomains" do
      expect(regex.matches?('http://bar.foo.com')).to be_falsey
      expect(regex.matches?('http://bar.foo.com/')).to be_falsey
    end
  end


  describe "#localhost" do
    let(:regex) { FactlinkBlacklist.default }

    it "should match localhost" do expect(regex.matches?('http://localhost/')).to be_truthy end
    it "should match 127.0.0.1" do expect(regex.matches?('http://127.0.0.1/')).to be_truthy end
    it "should match ::1" do expect(regex.matches?('http://::1/')).to be_truthy end
  end


  describe ".default" do
    let(:defaultlist) { FactlinkBlacklist.default }
    it "should not match blog.factlink.com" do
      expect(defaultlist.matches?('https://factlink.com/blog/')).to be_falsey
    end
    it "should match facebook.com" do
      expect(defaultlist.matches?('https://facebook.com/')).to be_truthy
    end
  end

end
