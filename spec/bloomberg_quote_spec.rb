require 'spec_helper'
require 'bloomberg_quote'
require 'fakeweb'

describe BloombergQuote do
  describe 'Indexes' do
    describe '#valid?' do
      context 'when wrong symbol' do
        it { BloombergQuote::Quote.new('DUMMY:IND').valid?.should be_false }
      end

      context 'when right symbol' do
        it { BloombergQuote::Quote.new('TPX:IND').valid?.should be_true }
      end
    end

    describe '#data' do
      context 'when wrong symbol' do
        it { BloombergQuote::Quote.new('DUMMY:IND').data.should be_empty }
      end

      shared_examples_for 'TPX:IND data' do |options|
        subject { BloombergQuote::Quote.new('TPX:IND').data }
        it { should_not be_empty }
        it { should have_key('Price') }
        it { should have_key('Previous Close') }
        it { should have_key('Open') }
        its(['Price']) { should be_instance_of(Float) }
        its(['Previous Close']) { should be_instance_of(Float) }
        its(['Open']) { should be_instance_of(Float) }

        if options.has_key?(:use_fakeweb) && options[:use_fakeweb]
          its(['Price']) { should == 813.33 }
          its(['Previous Close']) { should == 819.27 }
          its(['Open']) { should == 814.37 }
        end
      end

      context 'when right symbol' do
        it_should_behave_like 'TPX:IND data', {}

        describe 'values' do
          before(:all) do
            FakeWeb.register_uri(
              :get, "http://www.bloomberg.com/quote/TPX:IND",
              :body => File.read('spec/fakeweb/tpx.html'))
              FakeWeb.allow_net_connect = false
          end

          after(:all) do
            FakeWeb.clean_registry
          end

          it_should_behave_like 'TPX:IND data', :use_fakeweb => true
        end
      end
    end
  end
end
