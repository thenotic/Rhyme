#LibanAli
class Rhyme
  require 'open-uri'
  require 'json'
  require 'nokogiri'
  attr_accessor :two_syllable_rymes, :three_syllable_rymes, :one_syllable_rymes

  def lyrics=(new_lyrics)
    @lyrics = new_lyrics
  end

  def synthesize
    @lyrics =  @lyrics.gsub(/^$\n/, '//').gsub(/[']/,"").gsub(/[^a-zA-Z \/]/i, ' ').downcase
  end

  def get_dictionary
    @pronunciation_hash = {}
    File.open("Dictionary.txt") do |fp|
      fp.each do |line|
        word, pronunciation = line.chomp.split(",") rescue next
        word.downcase! rescue next
        @pronunciation_hash[word] = pronunciation
      end
    end
  end

  def lyrics_to_pronunciations_matrix
    synthesize
    get_dictionary
    wordpos = 0;
    syllpos = 0;
    linepos =0
    lyric_lines = @lyrics.split(/\n+/).compact
    pronun_matrix = []
    lyric_lines.each do |line|
      linepos += 1
      line = line.gsub(/[']/,"").gsub(/[^a-zA-Z \/]/i, ' ')
      line.scan(/\w+/).each do |word|
        wordpos +=1
        word_pronunciation = @pronunciation_hash[word]
        if word_pronunciation
          word_pronunciation = "#{word_pronunciation} |"  
        else
          word_pronunciation = "AE T |"
        end
        word_pronunciation_split =fix3(fix(word_pronunciation))
        word_pronunciation_split.each do |syllable|
          syllable.strip!
          syllpos += 1
          pronun_matrix << [syllpos, word, syllable, syllpos, wordpos,linepos]  
        end
      end
    end
    return pronun_matrix
  end

  def hanov_pronunciation
    link = "http://rhymebrain.com/talk?function=getWordInfo&word="+ self
    pronunciation_page = open(link).read().html_safe 
    json_parsed_page = JSON.parse(pronunciation_page) 
    search_term.to_s.downcase!
    json_pronunciation =  json_parsed_page['pron']
    return json_pronunciation
  end

  def fix3(barr)
    syll_all = barr
    syll_all.gsub!(" Y "," ")
    syll_all.gsub!(" HH "," ")
    syll_all = fix2(syll_all)
    syll_pieces = syll_all.scan(/\|[A-Z][A-Z][012] [_BCDFGHJHKLMNPQRSTVWXZ ]*\|/)
    syllables = []
    syll_pieces.each do |syll_piece|
      syll_without_vowel = syll_piece[1..syll_piece.length]
      constanant_count = syll_without_vowel.scan(/ [BCDFGHJKLMNPQRSTVWXZ] /).count
      if constanant_count>0
        syll_without_vowel.gsub!("|","")
      end
      syllables << syll_without_vowel
    end
    return syllables
  end

  def fix(pronun)
    array_search = ['0 A','0 E','0 I','0 O','0 U','0 W','1 A','1 E','1 I','1 0','1 U','1 W','2 A','2 E','2 I','2 O','2 U','2 W'];
    array_replace = ['0 _ A','0 _ E','0 _ I','0 _ O','0 _ U','0 _ W','1 _ A','1 _ E','1 _ I','1 _ O','1 _ U','1 _ W','2 _ A','2 _ E','2 _ I','2 _ O','2 _ U','2 _ W'];
    array_size = array_search.size-1
    for i in (0..array_size)
      pronun.gsub!(array_search[i],array_replace[i])
    end
    return pronun
  end

  def fix2(pronun)
    array_search = ['AA','AE','AH','AO','AW','AY','EH','ER','EY','IH','IY','OW','OY','UH','UW']
    array_replace = ['||AA','||AE','||AH','||AO','||AW','||AY','||EH','||ER','||EY','||IH','||IY','||OW','||OY','||UH','||UW']
    array_size = array_search.size-1
    for i in (0..array_size)
      pronun.gsub!(array_search[i],array_replace[i])
    end
    return pronun
  end

  def get_score_matrix
    @pronunciation_matrix = lyrics_to_pronunciations_matrix
    get_score_table
    combination_array = combinations
    @score_matrix = []
    combination_array.each do |wow3|
      syllable_one_position = wow3[0]
      syllable_two_position = wow3[1]
      syllable_one =  @pronunciation_matrix[syllable_one_position][2]
      syllable_two = @pronunciation_matrix[syllable_two_position][2]
      line_one_position =  @pronunciation_matrix[syllable_one_position][5]
      line_two_position = @pronunciation_matrix[syllable_two_position][5]
      word_one_position = @pronunciation_matrix[syllable_one_position][4]
      word_two_position = @pronunciation_matrix[syllable_two_position][4]
      word_one  = @pronunciation_matrix[syllable_one_position][1]
      word_two = @pronunciation_matrix[syllable_two_position][1]
      diff = line_one_position - line_two_position
      if diff <= 1
        score = score22(syllable_one,syllable_two)
        if score
          score_element = [syllable_one_position,   syllable_two_position, word_one_position,  
            word_two_position,  word_one, word_two, syllable_one, syllable_two, score, line_one_position,  line_two_position ]
            @score_matrix << score_element
          end
        end
      end
######score_matrix[i][0] = syll1pos
######score_matrix[i][1] = syll2pos
######score_matrix[i][2] = word1pos
######score_matrix[i][3] = word2pos
######score_matrix[i][4] = word1
######score_matrix[i][5] = word2
######score_matrix[i][6] = syll1
######score_matrix[i][7] = syll2
######score_matrix[i][8] = pairscore
######score_matrix[i][9] = line1pos
######score_matrix[i][10] = line2pos
return @score_matrix

end


def combinations
  syllcount = @pronunciation_matrix.last[0]-1
  a = *(0..syllcount)
  spl = (syllcount.to_f / @pronunciation_matrix.last[5]).round(2)
  aa = a.combination(2).to_a
  aacount = aa.size
  aareal=[]
  spl_plus = 30
  aa.each do |wow2|
    diff = wow2[1] - wow2[0]
    if diff < spl_plus
      aareal.push(wow2)
    end
  end
  return aareal
end

def get_score_table
  @score_table = {}
  File.open("Scores.txt") do |fp|
    fp.each do |line|
      letters,score = line.chomp.split(",")
      @score_table[letters] = score
    end
  end
  return @score_table
end




def score22(k1,k2)
  k1 = k1.strip
  k2 = k2.strip
  v1 = k1[0..1]
  v2 = k2[0..1]
  s1 = k1[2].to_s
  s2 = k2[2].to_s
  k1 = k1[3..k1.length]
  k2=k2[3..k2.length]
  c1 = k1.split(" ")
  c2 = k2.split(" ")
  cscore_total =[]
  c1.each do |wow|
    c2.each do |wow2|
      wow = wow.gsub("|","_")
      wow2 = wow2.gsub("|","_")
      cfinal = @score_table["#{wow}--#{wow2}"].to_f
      cscore_total.push(cfinal)
    end
  end
  vfinal = "#{v1}--#{v2}"
  sfinal = "#{s1}--#{s2}"
  cfinal2 = cscore_total.inject(:+).to_f / cscore_total.count
  c_count = (c1.count + c2.count).to_f / 2
  cfinal22 = cfinal2.to_f / c_count
  vscore = @score_table[vfinal].to_f + @score_table[sfinal].to_f + cfinal22
  return vscore
end

def score69(k1,k2)
  v1 = k1[0..1]
  v2 = k2[0..1]
  s1 = k1[2]
  s2 = k2[2]
  k1 = k1[3..k1.length]
  k2=k2[3..k2.length]
  c1 = k1.split(" ")
  c2 = k2.split(" ")
  cscore_total =[]
  c1.each do |wow|
    c2.each do |wow2|
      wow = wow.gsub("|","_")
      wow2 = wow2.gsub("|","_")
      cfinal = @score_table["#{wow}--#{wow2}"].to_f
      cscore_total.push(cfinal)
    end
  end
  vfinal = "#{v1}--#{v2}"
  sfinal = "#{s1}--#{s2}"
  cfinal2 = cscore_total.inject{|sum,x| sum + x }
  c_count = (c1.count + c2.count).to_f / 2
  cfinal22 = cfinal2.to_f / c_count
  if (s1=='1'&& s2=='1')
    temp_score = 1
  else
    temp_score=0
  end
  vscore = @score_table[vfinal].to_f +  cfinal22 + temp_score

  return vscore

end



def linebleed(starting,ending,hash_array)

  if (ending-starting==1)
    if hash_array[starting][5] != hash_array[ending][5]
      return 1
    end
  elsif (ending-starting==2)
# middle = starting+1
if (hash_array[starting][5] != hash_array[starting+1][5]) || (hash_array[starting+1][5] != hash_array[ending][5])
  return 1
end
end
end




def all_words2(c_array,k,l)
  answer = []
  for i in (k..l)
    if i==k
      newnew = c_array[i][1].to_s
      answer.push(newnew)
    elsif c_array[i][4] != c_array[i-1][4]
      newnew = c_array[i][1].to_s
      answer.push(newnew)
    end

  end
  answer2 = answer.join(" ")
  return answer2
end


def find_rhymes

  get_score_matrix
  hash2 = {}
  File.open("Scores.txt") do |fp|
    fp.each do |line|
      letters,score = line.chomp.split(",")
      hash2[letters] = score
    end
  end

  ii = @score_matrix.count
  @three_syllable_rymes = [];
  @two_syllable_rymes = []
  @one_syllable_rymes = []
  iii = ii-1
  @rhymed_output=[]
  for j in (0..iii)
    word_one_syllable_position = @score_matrix[j][0]
    word_one =  @pronunciation_matrix[word_one_syllable_position][1]
    word_one_syllable =  @pronunciation_matrix[word_one_syllable_position][2]
    word_two_syllable_position = @score_matrix[j][1]
    word_two =  @pronunciation_matrix[word_two_syllable_position][1]
    word_two_syllable = @pronunciation_matrix[word_two_syllable_position][2]
    if word_two_syllable_position + 2 < @pronunciation_matrix.last[0] 
      word_two_plus_one_syllable = @pronunciation_matrix[word_two_syllable_position+1][2]
      word_two_plus_two_syllable =  @pronunciation_matrix[word_two_syllable_position+2][2]
      word_one_plus_one_syllable =  @pronunciation_matrix[word_one_syllable_position+1][2] 
      word_one_plus_one_syllable = @pronunciation_matrix[word_one_syllable_position+2][2]
      if (@score_matrix[j][8] > 1.6 )    && score69(word_one_plus_one_syllable,word_two_plus_one_syllable) > 0.6 &&  score69(word_one_plus_one_syllable,word_two_plus_one_syllable) > 0.6 && linebleed(word_one_syllable_position,word_one_syllable_position+2,@pronunciation_matrix)!=1 && linebleed(word_two_syllable_position,word_two_syllable_position+2,@pronunciation_matrix)!=1 && wordcheck(word_one_syllable_position,word_two_syllable_position,word_one_syllable_position+2,word_two_syllable_position+2,@pronunciation_matrix)!=1  
        first = all_words2(@pronunciation_matrix,word_one_syllable_position,word_one_syllable_position+2) 
        second = all_words2(@pronunciation_matrix,word_two_syllable_position,word_two_syllable_position+2) 
        if (first.split(" ") & second.split(" ")).count < 1
          bruhh = [first,second,@score_matrix[j][2],@score_matrix[j][3],@score_matrix[j][9],@score_matrix[j][10]]
          @three_syllable_rymes.push(bruhh)

        end
      end
    end
    if word_two_syllable_position+1 < @pronunciation_matrix.last[0] 
      word22syllactual = @pronunciation_matrix[word_two_syllable_position+1][2]
      word11syllactual =  @pronunciation_matrix[word_one_syllable_position+1][2] 
      if (@score_matrix[j][8] > 1.6 )   &&   (score69(word11syllactual,word22syllactual) > 0.6 )    && linebleed(word_one_syllable_position,word_one_syllable_position+1,@pronunciation_matrix)!=1 && linebleed(word_two_syllable_position,word_two_syllable_position+1,@pronunciation_matrix)!=1 

        first = all_words2(@pronunciation_matrix,word_one_syllable_position,word_one_syllable_position+1) 
        second = all_words2(@pronunciation_matrix,word_two_syllable_position,word_two_syllable_position+1) 
        if first!=second
          syll_pairwise_score_element = [first,second,@score_matrix[j][2],@score_matrix[j][3],@score_matrix[j][9],@score_matrix[j][10]]
          @two_syllable_rymes.push(syll_pairwise_score_element)
        end
      end
    end

    if ( @score_matrix[j][8] > 1.96 )
      first = all_words2(@pronunciation_matrix,word_one_syllable_position,word_one_syllable_position) 
      second = all_words2(@pronunciation_matrix,word_two_syllable_position,word_two_syllable_position) 
      if first!=second
        bruhh = ["#{first} -- #{second}",word_one_syllable,word_two_syllable]
        @one_syllable_rymes.push(bruhh)
        huhha = [word_one_syllable_position,word_two_syllable_position  ]
        @rhymed_output << huhha

      end   
    end



  end

  return "success"
end



def wordcheck(start1,start2,end1,end2,hash_array)

wordcount1 = hash_array[end1][4] - hash_array[start1][4]
wordcount2 = hash_array[end2][4] - hash_array[start2][4]

total_w = wordcount1 + wordcount2


if hash_array[end1][1] == hash_array[end2][1]  && wordcount1>= 1 && wordcount2 >= 1
  return 1
end

if hash_array[start1][1] == hash_array[start2][1] 
  return 1
end


end

end


a = Rhyme.new
a.lyrics = "Good grief, I been reaping what I sowed
Nigga, I ain't been outside in a minute
I been living what I wrote
And all I see is snakes in the eyes of these niggas
Momma taught me how to read 'em when I look
Miss me at the precinct getting booked
Fishy niggas stick to eating off of hooks
Say you eating, but we see you getting cooked, nigga" #Earl Sweatshirt - Grief
a.find_rhymes

a.two_syllable_rymes








