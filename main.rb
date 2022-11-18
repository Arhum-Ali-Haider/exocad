# str = 'Please visit our "customer portal" at http://www.exocad.com now!'
while true
  puts 'Please Enter Text:'
  str = gets.chomp
  str.empty? ? puts("Text can't be blank.") : break
end

@quotes = []
@collection_of_words = []

def get_quotes_positions(quote, phrase)
  phrase.split('').each_with_index do |c, index|
    @quotes << index if c == quote
  end
end

# remove unnecessary quotes from string
def remove_unnecessary_quote(quote, phrase)
  get_quotes_positions(quote, phrase).slice!(@quotes.last)
  @quotes.pop
  phrase
end

def quote_check_and_execute(without_special_ch, phrase)
  if without_special_ch.count('"').odd? || without_special_ch.count("'").odd?
    return remove_unnecessary_quote('"', phrase) if without_special_ch.include?('"')
    return remove_unnecessary_quote("'", phrase) if without_special_ch.include?("'")
  else
    get_quotes_positions('"', phrase) if without_special_ch.include?('"')
    get_quotes_positions('"', phrase) if without_special_ch.include?("'")
  end
end

def get_filtered_string(phrase)
  without_special_ch = phrase.downcase.split('').map do |c|
    c = if c.count('a-z') > 0 || c.count('0-9') > 0
          c
        else
          c.include?('"') || c.include?("'") ? c : ' '
        end
  end .join('')
  quote_check_and_execute(without_special_ch, phrase)
  without_special_ch
end

def has_number?(word)
  word.count('0-9') > 0
end

def get_quoted_word(phrase)
  # create couples
  arr_of_couples = []
  @quotes.each_with_index do |_q, index|
    if index.odd?
      arr_of_couples <<
        [@quotes[index - 1], @quotes[index]]
    end
  end   # creating couples
  arr_of_couples.each do |couple|
    @collection_of_words <<
      phrase[couple[0]..couple[1]]
  end   # getting word using couples
  @collection_of_words.each { |w| phrase[w] = ' ' }
  phrase
end

def result(phrase)
  phrase.split(' ').each { |word| @collection_of_words << word }
  @collection_of_words.each_with_index do |word, index|
    puts @collection_of_words.delete(word) if has_number?(word)
    @collection_of_words[index] =
      @collection_of_words[index].split.join(' ').delete('\"').strip
  end
  puts 'Results:'
  puts "The text contains #{@collection_of_words.size} word#{@collection_of_words.count > 1 ? 's' : ''}."
  sequence = []
  @collection_of_words.sort_by(&:length).each_with_index do |word, _index|
    occurance = @collection_of_words.sort_by(&:length).keep_if do |a|
      a.strip.size ==
        word.strip.size
    end
    sequence << "Words with #{word.strip.size} letter#{word.strip.size > 1 ? 's' : ''} occured #{occurance.count} time#{occurance.count > 1 ? 's' : ''}: #{occurance.join(', ')}"
  end
  puts sequence.uniq
end

def string_determine(phrase)
  filtered_phrase = get_filtered_string(phrase)
  filtered_phrase = get_quoted_word(filtered_phrase)
  result(filtered_phrase)
end

string_determine(str)
