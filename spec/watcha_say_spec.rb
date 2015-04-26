require 'spec_helper'

describe WatchaSay do

  context 'BaseClassifier' do
    let(:ws) { WatchaSay::BaseClassifier.new }

    context 'preprocess' do
      it '.clean' do
        clean = 'tell me what is your orbit 15km'
        dirty=  '  ;/\ Tell me, WhAT Is your orbit?? 15km?'
        cleaned = ws.clean dirty

        expect(cleaned).to eq(clean)
      end

      it '.remove_common_words' do
        clean = 'what is orbit pluto little more into'
        dirty = 'what is the orbit of pluto and a little more into it'

        cleaned = ws.remove_common_words dirty
        expect(cleaned).to eq clean
      end
    end

    context 'training' do
      before(:each) do
        question = 'What is the full form of .com ?'
        type = 'ABBR:exp'
        ws.train(type, question)

        question = 'What does the abbreviation AIDS stand for ?'
        type = 'ABBR:exp'
        ws.train(type, question)

        question = 'What is the founder of Scientology ?'
        type = 'HUM:ind'
        ws.train(type, question)
      end

      context '.word_count' do
        it { expect(ws.word_count('what', 'ABBR:exp')).to eq 2 }
        it { expect(ws.word_count('', '')).to eq 0 }
      end

      context '.total_word_count' do
        it { expect(ws.total_word_count('')).to eq 0 }
        it { expect(ws.total_word_count('what')).to eq 3 }
      end

      context '.type_count' do
        it { expect(ws.type_count('ABBR:exp')).to eq 2.0 }
        it { expect(ws.type_count('')).to eq 0.0 }
      end

      it '.training_count' do expect(ws.training_count).to eq 3 end
    end
  end

  context 'BayesClassifier' do
    let(:ws) { WatchaSay::BayesClassifier.new }

    before(:each) do
      ws.train('ABBR:exp', 'What is the full form of .com ?')
      ws.train('ABBR:exp', 'What does the abbreviation AIDS stand for ?')
      ws.train('HUM:ind', 'Who discovered Pluto ?')
    end

    context '.word_prob' do
      context 'word not trained' do
        it { expect(ws.word_prob('', 'ANY')).to equal 0.0 }
      end

      context 'word trained' do
        it { expect(ws.word_prob('what', 'ABBR:exp')).to be > ws.word_prob('form', 'ABBR:exp') }
      end
    end

    context '.question_prob' do
      it { expect(
        ws.question_prob('What is the full form of .com ?', 'ABBR:exp')).to be >
        ws.question_prob('What is the full form of .com ?', 'HUM:ind')
      }
    end

    context '.type_scores' do
      it { expect(ws.type_scores('What is the full form of .com ?')[0][0]).to eq "ABBR:exp" }
    end
  end
end
