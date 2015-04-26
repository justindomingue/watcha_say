module WatchaSay
  class BayesClassifier

    def initialize()
      super()
      @weight = 1.0
      @assumed_prob = 0.1
    end

    def word_prob(word, type)
      total_words_in_type = total_word_count_in_type(type)
      return total_words_in_type == 0 ? 0.0 : word_count(word, type).to_f / total_words_in_type
    end
  end
end
