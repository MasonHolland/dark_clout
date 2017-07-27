class FileMetaDataService

  def initialize(meta_object, current_user)
    @yomu = meta_object
    @user = current_user
    @tgr = EngTagger.new
  end

  def collect
    text = yomu.text.to_s.delete!("\n")
    words = text_detector(text)
    MetaData.create!(text: text,
                      word_count: text.length,
                      top_adjective: words[:adjectives].first[0],
                      top_noun: words[:nouns].first[0],
                      user_id: @user.id)

  end

  private

  attr_reader :yomu, :user, :tgr

  def text_detector(text)
    output = {}
    tags = tgr.add_tags(text)
    output[:adjectives] = collect_adjectives(tgr, tags)
    output[:nouns] = collect_nouns(tgr, tags)
    output
  end

  def collect_adjectives(tgr, tags)
    tgr.get_adjectives(tags)
  end

  def collect_nouns(tgr, tags)
    tgr.get_nouns(tags)
  end
end
