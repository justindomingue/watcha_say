require 'spec_helper'

describe WatchaSay do

  context 'BaseClassifier' do
    before(:each) do
      @ws = WatchaSay::BaseClassifier.new
    end

    context 'preprocess' do
      it '.clean' do
        clean = 'tell me what is your orbit 15km'
        dirty=  '  ;/\ Tell me, WhAT Is your orbit?? 15km?'
        cleaned = @ws.clean dirty

        expect(cleaned).to eq(clean)
      end

      it '.remove_common_words' do
        clean = 'what is orbit pluto little more into'
        dirty = 'what is the orbit of pluto and a little more into it'

        cleaned = @ws.remove_common_words dirty
        expect(cleaned).to eq clean
      end
    end

    context 'training' do
      before(:each) do
        question = 'What is the full form of .com ?'
        type = 'ABBR:exp'
        @ws.train(type, question)

        question = 'What does the abbreviation AIDS stand for ?'
        type = 'ABBR:exp'
        @ws.train(type, question)

        question = 'Who is the founder of Scientology ?'
        type = 'HUM:ind'
        @ws.train(type, question)
      end

      it '.word_count' do expect(@ws.word_count('what', 'ABBR:exp')).to eq 2 end
      it '.training_count' do expect(@ws.training_count).to eq 3 end
    end
  end

  context 'BayesClassifier' do
    before(:each) do
      @ws = WatchaSay::BayesClassifier.new
    end
  end
end
