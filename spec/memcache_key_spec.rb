require 'spec_helper'

describe MemcacheKey do
  it 'has a version number' do
    expect(MemcacheKey::VERSION).not_to be nil
  end

  describe '#each' do
    context 'unless block given' do
      it 'returns Enumerator instance' do
        expect(MemcacheKey::Items.new.each).to be_instance_of Enumerator
      end
    end

    context 'if block given' do
      let(:items)     { 'END' }
      let(:cachedump) { 'END' }

      before do
        @items = MemcacheKey::Items.new

        client = double
        allow(client).to receive(:stats).with(:items).and_return(items)
        allow(client).to receive(:stats).with(:cachedump, '1', '2').and_return(cachedump)
        allow(client).to receive(:close)

        allow(@items).to receive(:memcached_client).and_return(client)
      end

      subject { @items.each{|k| nil} }

      context 'when key dose not exist' do
        it 'returns empty key list' do
          expect(subject.size).to be_zero
        end
      end

      context 'when keys exist' do
        let(:items) { "STAT items:1:number 2\nEND" }
        let(:cachedump) { "ITEM hoge [6 b; 1442026965 s]\nITEM fuga [6 b; 1442026911 s]\nEND" }

        it 'returns key list' do
          expect(subject.size).to eql(2)
          expect(subject.map{|k| k.key}).to eql(["hoge", "fuga"])
        end
      end
    end
  end
end
