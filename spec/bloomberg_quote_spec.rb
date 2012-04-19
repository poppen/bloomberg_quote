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
          end

          after(:all) do
            FakeWeb.clean_registry
          end

          it_should_behave_like 'TPX:IND data', :use_fakeweb => true
        end
      end
    end
  end

  describe 'Currency' do
    describe '#valid?' do
      context 'when wrong symbol' do
        it { BloombergQuote::Quote.new('DUMMY:CUR').valid?.should be_false }
      end

      context 'when right symbol' do
        it { BloombergQuote::Quote.new('USDJPY:CUR').valid?.should be_true }
      end
    end

    describe '#data' do
      context 'when wrong symbol' do
        it { BloombergQuote::Quote.new('DUMMY:CUR').data.should be_empty }
      end

      shared_examples_for 'USDJPY:CUR data' do |options|
        subject { BloombergQuote::Quote.new('USDJPY:CUR').data }
        it { should_not be_empty }
        it { should have_key('Price') }
        it { should have_key('Previous Close') }
        it { should have_key('Open') }
        its(['Price']) { should be_instance_of(Float) }
        its(['Previous Close']) { should be_instance_of(Float) }
        its(['Open']) { should be_instance_of(Float) }

        if options.has_key?(:use_fakeweb) && options[:use_fakeweb]
          its(['Price']) { should == 81.68 }
          its(['Previous Close']) { should == 81.26 }
          its(['Open']) { should == 81.26 }
        end
      end

      context 'when right symbol' do
        it_should_behave_like 'USDJPY:CUR data', {}

        describe 'values' do
          before(:all) do
            FakeWeb.register_uri(
              :get, "http://www.bloomberg.com/quote/USDJPY:CUR",
              :body => File.read('spec/fakeweb/usdjpy.html'))
          end

          after(:all) do
            FakeWeb.clean_registry
          end

          it_should_behave_like 'USDJPY:CUR data', :use_fakeweb => true
        end
      end
    end
  end

  describe 'Stock' do
    describe '#valid?' do
      context 'when wrong symbol' do
        it { BloombergQuote::Quote.new('DUMMY:JP').valid?.should be_false }
      end

      context 'when right symbol' do
        it { BloombergQuote::Quote.new('9437:JP').valid?.should be_true }
        it { BloombergQuote::Quote.new('1557:JP').valid?.should be_true }
      end
    end

    describe '#data' do
      context 'when wrong symbol' do
        it { BloombergQuote::Quote.new('DUMMY:JP').data.should be_empty }
      end

      shared_examples_for 'stock data' do |symbol, data|
        subject { BloombergQuote::Quote.new(symbol).data }
        it { should_not be_empty }
        it { should have_key('Price') }
        it { should have_key('Previous Close') }
        it { should have_key('Open') }
        its(['Price']) { should be_instance_of(Float) }
        its(['Previous Close']) { should be_instance_of(Float) }
        its(['Open']) { should be_instance_of(Float) }

        describe 'values' do
          before(:all) do
            FakeWeb.register_uri(
              :get, "http://www.bloomberg.com/quote/#{symbol}",
              :body => File.read("spec/fakeweb/#{symbol}.html"))
          end

          after(:all) do
            FakeWeb.clean_registry
          end

          its(['Price']) { should == data[:price] }
          its(['Previous Close']) { should == data[:previous_close] }
          its(['Open']) { should == data[:open] }
        end
      end

      context 'when right symbol' do
        it_should_behave_like 'stock data', '9437:JP',
          {:price => 136300, :previous_close => 136600, :open => 137100}

        it_should_behave_like 'stock data', '1557:JP',
          {:price => 11270, :previous_close => 11290, :open => 11420 }
      end
    end
  end
end
