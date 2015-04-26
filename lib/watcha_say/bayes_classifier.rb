module WatchaSay
  class BayesClassifier < BaseClassifier

    def initialize()
      super()

      @weight = 1.0
      @assumed_prob = 0.1 # TODO experiment
    end

    # Returns the probability between [0-1] of `word` belonging to a question of type `type`
    def word_prob(word, type)
      total_words_in_type = total_word_count_in_type(type)
      return total_words_in_type == 0 ? 0.0 : word_count(word, type).to_f / total_words_in_type
    end

    # Returns the Bayesian (weighted) average of `word` appearing in `type`
    def word_weighted_average(word, type)
      basic_prob = word_prob(word, type)

      totals = total_word_count(word)

      (@weight * @assumed_prob + totals * basic_prob) / (@weight + totals)
    end

    # Returns the probability of `question` being of type `type`
    def question_prob(question, type)
      type_prob = type_count(type) / @training_count
      doc_prob = question.split(' ').map { |w|
        word_weighted_average w, type
      }.inject(1) { |p,c| p * c }
      type_prob * doc_prob
    end

    def type_scores(question)
      probs = {}
      type_names.each do |type|
        probs[type] = question_prob(question, type)
      end
      probs.map { |k,v| [k,v] }.sort { |a,b| b[1] <=> a[1] }
    end

    # DEBUGGIN INFORMATION
    def word_classification_detail(word)
      p "question types"
      p type_names

      p "word prob"
      p type_names.inject({}) { |h, type| h[type]=word_prob(word,type);h }

      p "word_weighted_average"
      p type_names.inject({}) { |h, type| h[type]=word_weighted_average(word,type);h }
    end
  end
end
