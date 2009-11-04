require File.dirname(__FILE__) + '/test_helper.rb'
context "config" do

  before :all do
    FileUtils.copy(File.join(RAILS_ROOT, 'config', 'workling.yml'),
                   File.join(RAILS_ROOT, 'config', '.workling.yml-save'))
  end

  specify "should return the hash of the rails environment when everything is normal" do
    File.open(File.join(RAILS_ROOT, 'config', 'workling.yml'), 'w') do |file|
      file.print(YAML.dump({ 'development' => { 'listens_on' => 'localhost:9876' },
                             'test' => { 'listens_on' => 'localhost:12345'} }))
    end

    Workling.config(true).should.equal({ :listens_on => "localhost:12345" })
  end

  specify "should return an empty hash when the current environment is not configured" do
    File.open(File.join(RAILS_ROOT, 'config', 'workling.yml'), 'w') do |file|
      file.print(YAML.dump({ 'development' => { 'listens_on' => 'localhost:98765' },
                   'production' => { 'listens_on' => 'localhost:12345'} }))
    end

    Workling.config(true).should.equal({})
  end

  specify "should raise an error when workling.yml is missing" do
    File.delete(File.join(RAILS_ROOT, 'config', 'workling.yml'))
    lambda {  Workling.config(true) }.should.raise Workling::ConfigurationError
  end

  after :all do
    File.delete(File.join(RAILS_ROOT, 'config', 'workling.yml')) rescue nil
    File.rename(File.join(RAILS_ROOT, 'config', '.workling.yml-save'),
                File.join(RAILS_ROOT, 'config', 'workling.yml'))
    Workling.config(true)
  end
end
