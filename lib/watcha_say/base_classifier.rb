class WatchaSay::BaseClassifier
  attr_reader :training_count

  def initialize()
    @words = {}
    @types = {}

    @training_count = 0
  end

  # TRAINER

  # Trains the classifier
  def train(type, question)
    text = preprocess(question)
    text.split(' ').each { |w| increment_word(w, type) }
    increment_type(type)
  end

  # increment word `w` for type `type`
  def increment_word(word, type)
    @words[word] ||= {}

    @words[word][type] ||= 0
    @words[word][type] += 1
  end

  # Increment count (number of questions) for type `type`
  def increment_type(type)
    @types[type] ||= 0
    @types[type] += 1

    @training_count += 1
  end

  def train_from_training_set(file='tmp/training_set.txt')
    File.open(file, "r").each_line do |line|
      data = line.split " ", 2
      train(data[0], data[1])
    end
  end

  def benchmark(file='tmp/test_set.txt')
    total = 0.0
    success = 0.0

    File.open(file, "r").each_line do |line|
      data = line.split " ", 2
      guess = classify(data[1])
      total += 1.0
      success += 1.0 if guess == data[0]
    end

    p "Accuracy: %.2f" % (success/total * 100)
  end

  # CLASSIFIER

  # Returns the number of times a word appears in a type
  def word_count(word, type)
    return 0.0 unless @words[word] && @words[word][type]
    return @words[word][type]
  end

  # Returns the number of words in a type
  def total_word_count_in_type(type)
    @types[type] ? @types[type].to_f : 0.0
  end

  # Returns de number of times `word` appears in all types
  def total_word_count(word)
    return 0 unless @words[word]
    @words[word].values.reduce(:+)
  end

  # Returns the number of trained set elements for type `type`
  def type_count(type)
    @types[type] ? @types[type].to_f : 0.0
  end

  # Returns the number of training items
  def total_training_items
    @training_count
  end

  # Returns the names of the types
  def type_names
    return @types.keys
  end

  # Returns the type with the highest probability for `question`
  def classify(question)
    max_prob = 0.0
    best = nil

    scores = type_scores question
    scores.each do |score|
      type, prob = score
      if prob > max_prob
        max_prob = prob
        best = type
      end
    end

    return best ? best : 'ENTITY:other'
  end

  # PREPROCESS

  def preprocess(input)
    cleaned = clean(input)
    removed = remove_common_words(cleaned)
    return removed
  end

  # Cleans the string `input` by removing non alpha-numeric characters
  def clean(input)
    ret = input.downcase
    ret.gsub!(/[^0-9a-z ]/i, '').strip!

    return ret
  end

  # Removes common English words
  def remove_common_words(input)
    # TODO experiment
    common = %w(the be and of a in to for it)
    return input.gsub(/\b(?:#{ Regexp.union(common).source  })\b/, '').squeeze(' ').strip
  end
end
